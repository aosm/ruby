#
# menus widget demo (called by 'widget')
#

# toplevel widget が存在すれば削除する
if defined?($menu8x_demo) && $menu8x_demo
  $menu8x_demo.destroy 
  $menu8x_demo = nil
end

# demo 用の toplevel widget を生成
$menu8x_demo = TkToplevel.new {|w|
  title("Menu Demonstration (Tk8.x)")
  iconname("menu")
  positionWindow(w)
}

# version check
if $tk_version.to_f < 8.0

# label 生成
TkLabel.new($menu8x_demo,'font'=>$font,'wraplength'=>'4i','justify'=>'left') {
    text("実行しようとしたスクリプトは Tk8.0 以上で利用できる機能を利用しているため、あなたの Ruby#{VERSION}/Tk#{$tk_version}#{(Tk::JAPANIZED_TK)? 'jp': ''} では正常に実行できません。よってデモの実行を中止しました。ただし、下のコード参照ボタンを押すことで、実行が中止されたスクリプトのソースを参照することは可能です。")
}.pack('side'=>'top')

# frame 生成
TkFrame.new($menu8x_demo) {|frame|
  TkButton.new(frame) {
    #text '了解'
    text '閉じる'
    command proc{
      tmppath = $menu8x_demo
      $menu8x_demo = nil
      tmppath.destroy
    }
  }.pack('side'=>'left', 'expand'=>'yes')

  TkButton.new(frame) {
    text 'コード参照'
    command proc{showCode 'menu8x'}
  }.pack('side'=>'left', 'expand'=>'yes')
}.pack('side'=>'bottom', 'fill'=>'x', 'pady'=>'2m')

else ; # Tk8.x

# label 生成
TkLabel.new($menu8x_demo,'font'=>$font,'wraplength'=>'4i','justify'=>'left') {
  if $tk_platform['platform'] == 'macintosh'
    text("このウィンドウは様々なメニューとカスケードメニューから構成されています。Command-X を入力すると、Xがコマンドキー記号に続いて表示されている文字ならば、アクセラレータを使った項目起動を行うことができます。メニュー要素中、最後のものは、そのメニューの最初の項目を選択することで独立させることができます。")
  else
    text("このウィンドウは様々なメニューとカスケードメニューから構成されています。Alt-X を入力すると、Xがメニューにアンダーライン付きで表示されている文字ならば、キーボードからの指定ができます。矢印キーでメニューのトラバースも可能です。メニューが指定された際には、スペースキーで実行することができます。あるいは、アンダーライン付きの文字を入力することでも実行できます。メニューのエントリがアクセラレータを持っている場合は、そのアクセラレータを入力することでメニューを指定することなしに実行することができます。メニュー要素中、最後のものは、そのメニューの最初の項目を選択することで独立させることができます。")
  end
}.pack('side'=>'top')

# 状態表示の生成
$menu8xstatus = TkVariable.new("    ")
TkFrame.new($menu8x_demo) {|frame|
  TkLabel.new(frame, 'textvariable'=>$menu8xstatus, 'relief'=>'sunken', 
              'bd'=>1, 'font'=>['Helvetica', '10'], 'anchor'=>'w')\
  .pack('side'=>'left', 'padx'=>2, 'expand'=>'yes', 'fill'=>'both')
}.pack('side'=>'bottom', 'fill'=>'x', 'pady'=>2)

# frame 生成
TkFrame.new($menu8x_demo) {|frame|
  TkButton.new(frame) {
    #text '了解'
    text '閉じる'
    command proc{
      tmppath = $menu8x_demo
      $menu8x_demo = nil
      tmppath.destroy
    }
  }.pack('side'=>'left', 'expand'=>'yes')

  TkButton.new(frame) {
    text 'コード参照'
    command proc{showCode 'menu8x'}
  }.pack('side'=>'left', 'expand'=>'yes')
}.pack('side'=>'bottom', 'fill'=>'x', 'pady'=>'2m')

# menu 生成
TkMenu.new($menu8x_demo, 'tearoff'=>false) {|m|
  TkMenu.new(m, 'tearoff'=>false) {|file_menu|
    m.add('cascade', 'label'=>'File', 'menu'=>file_menu, 'underline'=>0)
    add('command', 'label'=>'開く ...', 'command'=>proc{fail 'これは、デモですので"開く ..."に対するアクションは定義されていません。'})
    add('command', 'label'=>'新規', 'command'=>proc{fail 'これは、デモですので"新規"に対するアクションは定義されていません。'})
    add('command', 'label'=>'保存', 'command'=>proc{fail 'これは、デモですので"保存"に対するアクションは定義されていません。'})
    add('command', 'label'=>'保存(指定) ...', 'command'=>proc{fail 'これは、デモですので"保存(指定) ..."に対するアクションは定義されていません。'})
    add('separator')
    add('command', 'label'=>'プリント設定 ...', 'command'=>proc{fail 'これは、デモですので"プリント設定 ..."に対するアクションは定義されていません。'})
    add('command', 'label'=>'プリント ...', 'command'=>proc{fail 'これは、デモですので"プリント ..."に対するアクションは定義されていません。'})
    add('separator')
    add('command', 'label'=>'終了', 'command'=>proc{$menu8x_demo.destroy})
  }

  if $tk_platform['platform'] == 'macintosh'
    modifier = 'Command'
  elsif $tk_platform['platform'] == 'windows'
    modifier = 'Control'
  else
    modifier = 'Meta'
  end

  TkMenu.new(m, 'tearoff'=>false) {|basic_menu|
    m.add('cascade', 'label'=>'Basic', 'menu'=>basic_menu, 'underline'=>0)
    add('command', 'label'=>'何もしない長いエントリ')
    ['A','B','C','D','E','F','G'].each{|c|
      # add('command', 'label'=>"文字 \"#{c}\" を印字", 'underline'=>4, 
      add('command', 'label'=>"Print letter \"#{c}\" (文字 \"#{c}\" を印字)", 
          'underline'=>14, 'accelerator'=>"Meta+#{c}", 
          'command'=>proc{print c,"\n"}, 'accelerator'=>"#{modifier}+#{c}")
      $menu8x_demo.bind("#{modifier}-#{c.downcase}", proc{print c,"\n"})
    }
  }

  TkMenu.new(m, 'tearoff'=>false) {|cascade_menu|
    m.add('cascade', 'label'=>'Cascades', 'menu'=>cascade_menu, 'underline'=>0)
    add('command', 'label'=>'Print hello(こんにちは)', 
        'command'=>proc{print "Hello(こんにちは)\n"}, 
        'accelerator'=>"#{modifier}+H", 'underline'=>6)
    $menu8x_demo.bind("#{modifier}-h", proc{print "Hello(こんにちは)\n"})
    add('command', 'label'=>'Print goodbye(さようなら)', 
        'command'=>proc{print "Goodbye(さようなら)\n"}, 
        'accelerator'=>"#{modifier}+G", 'underline'=>6)
    $menu8x_demo.bind("#{modifier}-g", proc{print "Goodbye(さようなら)\n"})

    TkMenu.new(m, 'tearoff'=>false) {|cascade_check|
      cascade_menu.add('cascade', 'label'=>'Check buttons(チェックボタン)', 
                       'menu'=>cascade_check, 'underline'=>0)
      oil = TkVariable.new(0)
      add('check', 'label'=>'オイル点検', 'variable'=>oil)
      trans = TkVariable.new(0)
      add('check', 'label'=>'トランスミッション点検', 'variable'=>trans)
      brakes = TkVariable.new(0)
      add('check', 'label'=>'ブレーキ点検', 'variable'=>brakes)
      lights = TkVariable.new(0)
      add('check', 'label'=>'ライト点検', 'variable'=>lights)
      add('separator')
      add('command', 'label'=>'現在の値を表示', 
          'command'=>proc{showVars($menu8x_demo, 
                                   ['オイル点検', oil], 
                                   ['トランスミッション点検', trans], 
                                   ['ブレーキ点検', brakes], 
                                   ['ライト点検', lights])} )
      invoke 1
      invoke 3
    }

    TkMenu.new(m, 'tearoff'=>false) {|cascade_radio|
      cascade_menu.add('cascade', 'label'=>'Radio buttons(ラジオボタン)', 
                       'menu'=>cascade_radio, 'underline'=>0)
      pointSize = TkVariable.new
      add('radio', 'label'=>'10 ポイント', 'variable'=>pointSize, 'value'=>10)
      add('radio', 'label'=>'14 ポイント', 'variable'=>pointSize, 'value'=>14)
      add('radio', 'label'=>'18 ポイント', 'variable'=>pointSize, 'value'=>18)
      add('radio', 'label'=>'24 ポイント', 'variable'=>pointSize, 'value'=>24)
      add('radio', 'label'=>'32 ポイント', 'variable'=>pointSize, 'value'=>32)
      add('separator')
      style = TkVariable.new
      add('radio', 'label'=>'ローマン', 'variable'=>style, 'value'=>'roman')
      add('radio', 'label'=>'ボールド', 'variable'=>style, 'value'=>'bold')
      add('radio', 'label'=>'イタリック', 'variable'=>style, 'value'=>'italic')
      add('separator')
      add('command', 'label'=>'現在の値を表示', 
          'command'=>proc{showVars($menu8x_demo, 
                                   ['ポイントサイズ', pointSize], 
                                   ['スタイル', style])} )
      invoke 1
      invoke 7
    }
  }

  TkMenu.new(m, 'tearoff'=>false) {|icon_menu|
    m.add('cascade', 'label'=>'Icons', 'menu'=>icon_menu, 'underline'=>0)
    add('command', 
        'bitmap'=>'@'+[$demo_dir,'..',
                        'images','pattern.xbm'].join(File::Separator),
        'hidemargin'=>1, 
        'command'=>proc{TkDialog.new('title'=>'Bitmap Menu Entry', 
                                     'text'=>'今あなたが選択したメニューの項目はテキストではなくビットマップを表示していました。それ以外の点では他のメニュー項目と変わりません。',
                                     'bitmap'=>'', 'default'=>0, 
                                     'buttons'=>'了解')} )
    ['info', 'questhead', 'error'].each{|icon|
      add('command', 'bitmap'=>icon, 'hidemargin'=>1, 
          'command'=>proc{print "You invoked the #{icon} bitmap\n"})
    }

    entryconfigure(2, 'columnbreak'=>1)
  }

  TkMenu.new(m, 'tearoff'=>false) {|more_menu|
    m.add('cascade', 'label'=>'More', 'menu'=>more_menu, 'underline'=>0)
    [ 'エントリ','別のエントリ','何もしない','ほとんど何もしない',
      '人生を意義あるものに' ].each{|i|
      add('command', 'label'=>i, 
          'command'=>proc{print "You invoked \"#{i}\"\n"})
    }
  }

  TkMenu.new(m) {|colors_menu|
    m.add('cascade', 'label'=>'Colors', 'menu'=>colors_menu, 'underline'=>1)
    ['red', 'orange', 'yellow', 'green', 'blue'].each{|c|
      add('command', 'label'=>c, 'background'=>c, 
          'command'=>proc{print "You invoked \"#{c}\"\n"})
    }
  }

  $menu8x_demo.configure('menu'=>m)
}

TkMenu.bind('<MenuSelect>', 
            proc{|w| 
              begin
                label = w.entrycget('active', 'label')
              rescue
                label = '    '
              end
              $menu8xstatus.value = label
              Tk.update('idletasks')
            }, '%W')

end ; # Tk 8.x
