#@if (version >= "1.8.0")
= class UnboundMethod < Object
#@else
= class UnboundMethod < Method
#@end

レシーバを持たないメソッドオブジェクトのクラスです。
[[m:Module#instance_method]] や
[[m:Method#unbind]] により生成し、後で
[[m:UnboundMethod#bind]] によりレシーバを
割り当てた [[c:Method]] オブジェクトを作ることができます。

例: [[c:Method]] クラスの冒頭にある例を UnboundMethod で書くと以下のようになる

  class Foo
    def foo() "foo" end
    def bar() "bar" end
    def baz() "baz" end
  end

  # 任意のキーとメソッドの関係をハッシュに保持しておく
  # レシーバの情報がここにはないことに注意
  methods = {1 => Foo.instance_method(:foo),
             2 => Foo.instance_method(:bar),
             3 => Foo.instance_method(:baz)}

  # キーを使って関連するメソッドを呼び出す
  # レシーバは任意(Foo クラスのインスタンスでなければならない)
  p methods[1].bind(Foo.new).call      # => "foo"
  p methods[2].bind(Foo.new).call      # => "bar"
  p methods[3].bind(Foo.new).call      # => "baz"

例: メソッドの再定義を UnboundMethod を使って行う方法(普通は、
[[unknown:クラス／メソッドの定義/alias]] や [[unknown:メソッド呼び出し/super]] を使う)

  class Foo
    def foo
      p :foo
      end
    @@orig_foo = instance_method :foo
    def foo
      p :bar
      @@orig_foo.bind(self).call
    end
  end

  Foo.new.foo

  => :bar
     :foo

== Instance Methods

#@if (version < "1.8.0")
--- [](args, ...)
--- call(args, ...)
--- call(args, ...) { ... }

UnboundMethod は [[m:UnboundMethod#bind]] しなければ起動できません。
常に例外 [[c:TypeError]] が発生します。

    class Foo
      def foo
      end
    end
    Foo.instance_method(:foo).call

    # => -:5:in `call': you cannot call unbound method; bind first (TypeError)
#@end

--- bind(obj)

self を obj にバインドして bound method オブジェクト
(つまり [[c:Method]] オブジェクト) を生成し返します。ただしバイン
ドできるのは、unbind したオブジェクトのクラスのインスタンスか、メ
ソッド定義元のモジュールをインクルードしたクラスのインスタンスだけ
です。そうでなければ例外 [[c:TypeError]] が発生します。

例:

    # クラスのインスタンスメソッドの UnboundMethod の場合

    class Foo
      def foo
        "foo"
      end
    end

    # UnboundMethod `m' を生成
    p m = Foo.instance_method(:foo) # => #<UnboundMethod: Foo(Foo)#foo>

    # Foo のインスタンスをレシーバとする Method オブジェクトを生成
    p m.bind(Foo.new)               # => #<Method: Foo(Foo)#foo>

    # Foo のサブクラス Bar のインスタンスをレシーバとする Method
#@if (version < "1.8.0")
    # オブジェクトを生成(これは許されない)
#@end
    #@#  ruby 1.8 feature: 許されるようになりました

    class Bar < Foo
    end
    # p m.bind(Bar.new)               # => -18:in `bind': bind argument must be an instance of Foo (TypeError)

    # 同名の特異メソッドが定義されているとダメ
    class << obj = Foo.new
      def foo
      end
    end
    p m.bind(obj)                   # => -:25:in `bind': method `foo' overridden (TypeError)

    # モジュールのインスタンスメソッドの UnboundMethod の場合

    module Foo
      def foo
        "foo"
      end
    end

    # UnboundMethod `m' を生成
    p m = Foo.instance_method(:foo) # => #<UnboundMethod: Foo(Foo)#foo>

    # Foo をインクルードしたクラス Bar のインスタンスをレシーバと
    # する Method オブジェクトを生成
    class Bar
      include Foo
    end
    p m.bind(Bar.new)               # => #<Method: Bar(Foo)#foo>

    # Bar のサブクラスは Foo をインクルードしているのと同等なのでよい
    class Baz <Bar
    end
    p m.bind(Baz.new)               # => #<Method: Baz(Foo)#foo>

    # 同名の特異メソッドが定義されているとダメ
    class << obj = Baz.new
      def foo
      end
    end
    p m.bind(obj)                   # => -:27:in `bind': method `foo' overridden (TypeError)

#@if (version < "1.8.0")
--- to_proc

self を call する [[c:Proc]] オブジェクトを生成して返します。
#@end

#@if (version < "1.8.0")
--- unbind

self を返します。
#@end

--- arity   
#@# => fixnum

Returns an indication of the number of arguments accepted by
a method. Returns a nonnegative integer for methods that take
a fixed number of arguments. For Ruby methods that take a variable
number of arguments, returns -n-1, where n is the number of required
arguments. For methods written in C, returns -1 if the call takes
a variable number of arguments.

  
  class C
    def one;    end
    def two(a); end
    def three(*a);  end
    def four(a, b); end
    def five(a, b, *c);    end
    def six(a, b, *c, &d); end
  end
  
  p C.instance_method(:one).arity     #=> 0
  p C.instance_method(:two).arity     #=> 1
  p C.instance_method(:three).arity   #=> -1
  p C.instance_method(:four).arity    #=> 2
  p C.instance_method(:five).arity    #=> -3
  p C.instance_method(:six).arity     #=> -3
  
  
  String.instance_method(:size).arity      #=> 0
  String.instance_method(:replace).arity   #=> 1
  String.instance_method(:squeeze).arity   #=> -1
  String.instance_method(:count).arity     #=> -1
