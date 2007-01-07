= class DBM < Object

include Enumerable

NDBM ファイルをアクセスするクラス。キー、データともに文字列でなければな
らないという制限と、データがファイルに保存されるという点を除いては
Hash クラスと全く同様に扱うことがでます。

#@#=== 使いかた

#@#  require 'dbm'

== Class Methods

--- open(dbname[, mode[, flags]])
--- open(dbname[, mode[, flags]]) {|db| ...}

#@todo

dbname で指定したデータベースをモードを
mode に設定してオープンします。mode の省
略値は 0666 です。mode として nil を指定
するとデータベースが存在しない時には新たなデータベースを作らず
nil を返します。

#@if (version >= "1.8.2")
flags 引数を指定できます。
flags には以下のいずれかを指定します。
  * DBM::READER : データベースの読み込みのみを行う
  * DBM::WRITER : データベースの新規作成はせず読み書きする
  * DBM::WRCREAT : データベースが存在しなければ新規作成して読み書きする
  * DBM::NEWDB : データベースを常に新規作成して既存のデータは破棄する
#@end

== Instance Methods

--- [](key)

key をキーとする値を返します。

--- []=(key, value)

key をキーとして、value を格納します。
value として nil を指定すると、key に対
する項目を削除します。

--- clear

DBM ファイルを空にします。

--- close

DBM ファイルをクローズします。以後の操作は例外を発生させます。

#@since 1.8.3
--- closed?

#@todo

#@end

--- delete(key)

key をキーとする項目を削除します。

--- reject! { |key, value|  ...  }
--- delete_if { |key, value|  ...  }

ブロックを評価した値が真であれば該当する項目を削除します。

--- reject

#@todo

--- each {|key, value|  ...  }
--- each_pair {|key, value|  ...  }

各要素に対するイテレータ。

--- each_key {|key|  ...  }

全ての key に対して繰り返すイテレータ。

--- each_value {|value|  ...  }

全ての value に対して繰り返すイテレータ。

--- empty?()

データベースが空の時、真を返します。

--- has_key?(key)
--- key?(key)
--- include?(key)
--- member?(key)

key がデータベース中に存在する時、真を返します。

--- has_value?(value)
--- value?(value)

value を値とする組がデータベース中に存在する時、真を返します。

#@if (version < "1.9.0")
--- indexes(key_1, ... )
--- indices(key_1, ... )

このメソッドは obsolete です。

各引数の値をキーとする要素を含む配列を返します。

#@end

--- keys

データベース中に存在するキー全てを含む配列を返します。

--- length
--- size

データベース中の要素の数を返します。(注意:現在の実現では要素数を数
えるためにデータベースを全部検索します)

--- shift

データベース中の要素を一つ取り出し、データベースから削除します。

--- values

データベース中に存在する値全てを含む配列を返します。

--- replace(other)

#@todo

--- fetch

--- store

--- select

--- values_at

--- invert

--- update

--- to_a

--- to_hash

--- index 

== Constants

#@if (version >= "1.8.2")
--- READER

読み込みモードでオープンします．
#@end

#@if (version >= "1.8.2")
--- WRITER

書き込みモードでオープンします．
#@end

#@if (version >= "1.8.2")
--- WRCREAT

書き込みモードで、すでにファイルが存在しなかったら作ります．
#@end

#@if (version >= "1.8.2")
--- NEWDB

書き込みモードで、すでにファイルが存在したら削除して作り直します．
#@end

--- VERSION
#@todo
