Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48557 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2GBJpn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 05:45:43 -0400
Received: by wgbdr13 with SMTP id dr13so5056880wgb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 02:45:41 -0700 (PDT)
MIME-Version: 1.0
From: Chester <somethingsome2000@gmail.com>
Date: Mon, 2 Jul 2012 05:45:21 -0400
Message-ID: <CAAE6i0jpnOGzkDBXjApQ46ASv4j0KNpNCYapakVm942hoZye-w@mail.gmail.com>
Subject: btrfsck: warning, bad space info total_bytes NNNN.. used NNNN..
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had some problems with extents earlier. I was instructed to run the
btrfsck --repair. The previous problem was fixed by fsck, but after
running the repair, my filesystem has hit more problems. I can't have
the filesystem mounted for more than a minute or two before it crashes
again.. The btrfsck output is below.


found 231386730496 bytes used err is 1
total csum bytes: 224533128
total tree bytes: 2067677184
total fs tree bytes: 1730035712
btree space waste bytes: 369336884
file data blocks allocated: 572131295232
 referenced 565174681600
Btrfs Btrfs v0.19
18240
warning, bad space info total_bytes 6442450944 used 12884901888
warning, bad space info total_bytes 7516192768 used 15032336384
warning, bad space info total_bytes 8589934592 used 17177165824
warning, bad space info total_bytes 9663676416 used 19324567552
warning, bad space info total_bytes 10737418240 used 21380055040
warning, bad space info total_bytes 11811160064 used 23527538688
warning, bad space info total_bytes 12884901888 used 25674924032
warning, bad space info total_bytes 13958643712 used 27749941248
warning, bad space info total_bytes 15032385536 used 29897392128
warning, bad space info total_bytes 16106127360 used 32044851200
warning, bad space info total_bytes 17179869184 used 34192220160
warning, bad space info total_bytes 18253611008 used 36339515392
warning, bad space info total_bytes 19327352832 used 38486941696
warning, bad space info total_bytes 20401094656 used 40634417152
warning, bad space info total_bytes 21474836480 used 42781900800
warning, bad space info total_bytes 22548578304 used 44929359872
warning, bad space info total_bytes 23622320128 used 47076786176
warning, bad space info total_bytes 24696061952 used 49224269824
warning, bad space info total_bytes 25769803776 used 51371663360
warning, bad space info total_bytes 26843545600 used 53519147008
warning, bad space info total_bytes 27917287424 used 55666548736
warning, bad space info total_bytes 28991029248 used 57814032384
warning, bad space info total_bytes 30064771072 used 59961507840
warning, bad space info total_bytes 31138512896 used 62108917760
warning, bad space info total_bytes 32212254720 used 64256401408
warning, bad space info total_bytes 33285996544 used 66403885056
warning, bad space info total_bytes 34359738368 used 68551368704
warning, bad space info total_bytes 35433480192 used 70698827776
warning, bad space info total_bytes 36507222016 used 72846311424
warning, bad space info total_bytes 37580963840 used 74993795072
warning, bad space info total_bytes 38654705664 used 77141245952
warning, bad space info total_bytes 39728447488 used 79288672256
warning, bad space info total_bytes 40802189312 used 81436139520
warning, bad space info total_bytes 41875931136 used 83583139840
warning, bad space info total_bytes 42949672960 used 85728083968
warning, bad space info total_bytes 44023414784 used 87868211200
warning, bad space info total_bytes 45097156608 used 89985007616
warning, bad space info total_bytes 46170898432 used 92125323264
warning, bad space info total_bytes 47244640256 used 94260412416
warning, bad space info total_bytes 48318382080 used 96370556928
warning, bad space info total_bytes 49392123904 used 98321285120
warning, bad space info total_bytes 50465865728 used 100468613120
warning, bad space info total_bytes 51539607552 used 102616047616
warning, bad space info total_bytes 52613349376 used 104702590976
warning, bad space info total_bytes 53687091200 used 106849697792
warning, bad space info total_bytes 54760833024 used 108996411392
warning, bad space info total_bytes 55834574848 used 111143419904
warning, bad space info total_bytes 56908316672 used 113290747904
warning, bad space info total_bytes 57982058496 used 115438100480
warning, bad space info total_bytes 59055800320 used 117580193792
warning, bad space info total_bytes 60129542144 used 119698923520
warning, bad space info total_bytes 61203283968 used 121843990528
warning, bad space info total_bytes 62277025792 used 123963088896
warning, bad space info total_bytes 63350767616 used 126091001856
warning, bad space info total_bytes 64424509440 used 128236519424
warning, bad space info total_bytes 65498251264 used 130265522176
warning, bad space info total_bytes 66571993088 used 132387274752
warning, bad space info total_bytes 67645734912 used 134489604096
warning, bad space info total_bytes 68719476736 used 136618803200
warning, bad space info total_bytes 69793218560 used 138647904256
warning, bad space info total_bytes 70866960384 used 140616761344
warning, bad space info total_bytes 71940702208 used 142670536704
warning, bad space info total_bytes 73014444032 used 144584245248
warning, bad space info total_bytes 74088185856 used 146611224576
warning, bad space info total_bytes 2147483648 used 2936504320
warning, bad space info total_bytes 3221225472 used 4199350272
warning, bad space info total_bytes 4294967296 used 4470013952
warning, bad space info total_bytes 75161927680 used 148758708224
warning, bad space info total_bytes 76235669504 used 150906191872
warning, bad space info total_bytes 77309411328 used 153053675520
warning, bad space info total_bytes 78383153152 used 155201159168
warning, bad space info total_bytes 79456894976 used 157348642816
warning, bad space info total_bytes 80530636800 used 159496126464
warning, bad space info total_bytes 81604378624 used 161643610112
warning, bad space info total_bytes 82678120448 used 163791093760
warning, bad space info total_bytes 83751862272 used 165938577408
warning, bad space info total_bytes 84825604096 used 168086061056
warning, bad space info total_bytes 85899345920 used 170233544704
warning, bad space info total_bytes 86973087744 used 172381020160
warning, bad space info total_bytes 88046829568 used 174528495616
warning, bad space info total_bytes 89120571392 used 176675979264
warning, bad space info total_bytes 90194313216 used 178823454720
warning, bad space info total_bytes 91268055040 used 180970938368
warning, bad space info total_bytes 92341796864 used 183118422016
warning, bad space info total_bytes 93415538688 used 185265905664
warning, bad space info total_bytes 94489280512 used 187413389312
warning, bad space info total_bytes 95563022336 used 189560872960
warning, bad space info total_bytes 96636764160 used 191708348416
warning, bad space info total_bytes 97710505984 used 193855832064
warning, bad space info total_bytes 98784247808 used 196003307520
warning, bad space info total_bytes 99857989632 used 198150791168
warning, bad space info total_bytes 100931731456 used 200298274816
warning, bad space info total_bytes 102005473280 used 202445758464
warning, bad space info total_bytes 103079215104 used 204593242112
warning, bad space info total_bytes 104152956928 used 206740725760
warning, bad space info total_bytes 105226698752 used 208888209408
warning, bad space info total_bytes 106300440576 used 211035693056
warning, bad space info total_bytes 107374182400 used 213183168512
warning, bad space info total_bytes 108447924224 used 215330652160
warning, bad space info total_bytes 109521666048 used 217478127616
warning, bad space info total_bytes 110595407872 used 219625611264
warning, bad space info total_bytes 111669149696 used 221773094912
warning, bad space info total_bytes 112742891520 used 223920578560
warning, bad space info total_bytes 113816633344 used 226068062208
warning, bad space info total_bytes 114890375168 used 228215537664
warning, bad space info total_bytes 115964116992 used 230363013120
warning, bad space info total_bytes 117037858816 used 232510357504
warning, bad space info total_bytes 118111600640 used 234657832960
warning, bad space info total_bytes 119185342464 used 236805308416
warning, bad space info total_bytes 120259084288 used 238952079360
warning, bad space info total_bytes 121332826112 used 241098891264
warning, bad space info total_bytes 122406567936 used 243245867008
warning, bad space info total_bytes 123480309760 used 245392891904
warning, bad space info total_bytes 124554051584 used 247540367360
warning, bad space info total_bytes 125627793408 used 249687236608
warning, bad space info total_bytes 126701535232 used 251834671104
warning, bad space info total_bytes 127775277056 used 253982154752
warning, bad space info total_bytes 128849018880 used 256129540096
warning, bad space info total_bytes 129922760704 used 258276810752
warning, bad space info total_bytes 130996502528 used 260424294400
warning, bad space info total_bytes 132070244352 used 262571778048
warning, bad space info total_bytes 133143986176 used 264719253504
warning, bad space info total_bytes 134217728000 used 266866728960
warning, bad space info total_bytes 135291469824 used 269014204416
warning, bad space info total_bytes 136365211648 used 271161688064
warning, bad space info total_bytes 137438953472 used 273309171712
warning, bad space info total_bytes 138512695296 used 275456647168
warning, bad space info total_bytes 139586437120 used 277604122624
warning, bad space info total_bytes 140660178944 used 279751606272
warning, bad space info total_bytes 141733920768 used 281899081728
warning, bad space info total_bytes 142807662592 used 284046557184
warning, bad space info total_bytes 143881404416 used 286194032640
warning, bad space info total_bytes 144955146240 used 288341508096
warning, bad space info total_bytes 146028888064 used 290488991744
warning, bad space info total_bytes 147102629888 used 292636467200
warning, bad space info total_bytes 148176371712 used 294783950848
warning, bad space info total_bytes 149250113536 used 296931434496
warning, bad space info total_bytes 150323855360 used 299078918144
warning, bad space info total_bytes 151397597184 used 301226393600
warning, bad space info total_bytes 152471339008 used 303373869056
warning, bad space info total_bytes 153545080832 used 305520566272
warning, bad space info total_bytes 154618822656 used 307667943424
warning, bad space info total_bytes 155692564480 used 309815427072
warning, bad space info total_bytes 156766306304 used 311962910720
warning, bad space info total_bytes 157840048128 used 314110386176
warning, bad space info total_bytes 158913789952 used 316257804288
warning, bad space info total_bytes 159987531776 used 318405279744
warning, bad space info total_bytes 161061273600 used 320552632320
warning, bad space info total_bytes 162135015424 used 322700107776
warning, bad space info total_bytes 163208757248 used 324847443968
warning, bad space info total_bytes 164282499072 used 326994911232
warning, bad space info total_bytes 165356240896 used 329142312960
warning, bad space info total_bytes 166429982720 used 331289772032
warning, bad space info total_bytes 167503724544 used 333437247488
warning, bad space info total_bytes 168577466368 used 335584731136
warning, bad space info total_bytes 169651208192 used 337732214784
warning, bad space info total_bytes 170724950016 used 339879591936
warning, bad space info total_bytes 171798691840 used 342026977280
warning, bad space info total_bytes 172872433664 used 344174452736
warning, bad space info total_bytes 173946175488 used 346321838080
warning, bad space info total_bytes 175019917312 used 348469321728
warning, bad space info total_bytes 176093659136 used 350616805376
warning, bad space info total_bytes 177167400960 used 352764289024
warning, bad space info total_bytes 178241142784 used 354911551488
warning, bad space info total_bytes 179314884608 used 357058764800
warning, bad space info total_bytes 180388626432 used 359206232064
warning, bad space info total_bytes 181462368256 used 361353691136
warning, bad space info total_bytes 182536110080 used 363501166592
warning, bad space info total_bytes 183609851904 used 365648560128
warning, bad space info total_bytes 184683593728 used 367795945472
warning, bad space info total_bytes 185757335552 used 369943429120
warning, bad space info total_bytes 186831077376 used 372090765312
warning, bad space info total_bytes 187904819200 used 374238216192
warning, bad space info total_bytes 188978561024 used 376385699840
warning, bad space info total_bytes 190052302848 used 378533044224
warning, bad space info total_bytes 191126044672 used 380680290304
warning, bad space info total_bytes 192199786496 used 382826323968
warning, bad space info total_bytes 193273528320 used 384973447168
warning, bad space info total_bytes 194347270144 used 387119497216
warning, bad space info total_bytes 195421011968 used 389266612224
warning, bad space info total_bytes 196494753792 used 391413088256
warning, bad space info total_bytes 197568495616 used 393560571904
warning, bad space info total_bytes 198642237440 used 395708022784
warning, bad space info total_bytes 199715979264 used 397855506432
warning, bad space info total_bytes 200789721088 used 400002785280
warning, bad space info total_bytes 201863462912 used 402148892672
warning, bad space info total_bytes 202937204736 used 404296376320
warning, bad space info total_bytes 204010946560 used 406443622400
warning, bad space info total_bytes 205084688384 used 408590753792
warning, bad space info total_bytes 206158430208 used 410738221056
warning, bad space info total_bytes 207232172032 used 412884492288
warning, bad space info total_bytes 208305913856 used 415031468032
warning, bad space info total_bytes 209379655680 used 417178460160
warning, bad space info total_bytes 210453397504 used 419325640704
warning, bad space info total_bytes 211527139328 used 421470142464
warning, bad space info total_bytes 212600881152 used 423612448768
warning, bad space info total_bytes 213674622976 used 425756303360
warning, bad space info total_bytes 214748364800 used 427903614976
warning, bad space info total_bytes 215822106624 used 430045601792
warning, bad space info total_bytes 216895848448 used 432187211776
warning, bad space info total_bytes 217969590272 used 434328330240
warning, bad space info total_bytes 219043332096 used 436474945536
warning, bad space info total_bytes 220117073920 used 438617088000
warning, bad space info total_bytes 221190815744 used 440756846592
warning, bad space info total_bytes 222264557568 used 442895261696
warning, bad space info total_bytes 223338299392 used 445032554496
warning, bad space info total_bytes 224412041216 used 447173214208
warning, bad space info total_bytes 225485783040 used 449252073472
warning, bad space info total_bytes 226559524864 used 451373924352
warning, bad space info total_bytes 4328521728 used 4470013952
warning, bad space info total_bytes 227633266688 used 453496963072
warning, bad space info total_bytes 228707008512 used 455629258752
warning, bad space info total_bytes 229780750336 used 457758793728
warning, bad space info total_bytes 230854492160 used 458312785920
warning, bad space info total_bytes 231928233984 used 458312785920
warning, bad space info total_bytes 233001975808 used 458312785920
warning, bad space info total_bytes 234075717632 used 458312785920
warning, bad space info total_bytes 235149459456 used 458312785920
warning, bad space info total_bytes 236223201280 used 458312785920
warning, bad space info total_bytes 237296943104 used 458312785920
warning, bad space info total_bytes 238370684928 used 458312785920
warning, bad space info total_bytes 239444426752 used 458312785920
warning, bad space info total_bytes 240518168576 used 458312785920
warning, bad space info total_bytes 241591910400 used 458312785920
warning, bad space info total_bytes 242665652224 used 458312785920
warning, bad space info total_bytes 243739394048 used 458312785920
warning, bad space info total_bytes 244813135872 used 458312785920
warning, bad space info total_bytes 245886877696 used 458312785920
warning, bad space info total_bytes 246960619520 used 458312785920
warning, bad space info total_bytes 248034361344 used 458312785920
warning, bad space info total_bytes 249108103168 used 458312785920
warning, bad space info total_bytes 250181844992 used 458312785920
warning, bad space info total_bytes 251255586816 used 458312785920
warning, bad space info total_bytes 252329328640 used 458312785920
warning, bad space info total_bytes 253403070464 used 458312785920
warning, bad space info total_bytes 254476812288 used 458312785920
warning, bad space info total_bytes 255550554112 used 458312785920
warning, bad space info total_bytes 256624295936 used 458312785920
warning, bad space info total_bytes 257698037760 used 458312785920
warning, bad space info total_bytes 258771779584 used 458312785920
warning, bad space info total_bytes 259845521408 used 458312785920
warning, bad space info total_bytes 260919263232 used 458312785920
warning, bad space info total_bytes 261993005056 used 458312785920
warning, bad space info total_bytes 263066746880 used 458312785920
warning, bad space info total_bytes 264140488704 used 458312785920
warning, bad space info total_bytes 265214230528 used 458312785920
warning, bad space info total_bytes 266287972352 used 458312785920
warning, bad space info total_bytes 267361714176 used 458312785920
warning, bad space info total_bytes 268435456000 used 458312785920
warning, bad space info total_bytes 269509197824 used 458312785920
warning, bad space info total_bytes 270582939648 used 458312785920
warning, bad space info total_bytes 271656681472 used 458312785920
warning, bad space info total_bytes 272730423296 used 458312785920
warning, bad space info total_bytes 273804165120 used 458312785920
warning, bad space info total_bytes 274877906944 used 458312785920
warning, bad space info total_bytes 275951648768 used 458312785920
warning, bad space info total_bytes 277025390592 used 458312785920
warning, bad space info total_bytes 278099132416 used 458312785920
warning, bad space info total_bytes 279172874240 used 458312785920
warning, bad space info total_bytes 280246616064 used 458312785920
warning, bad space info total_bytes 281320357888 used 458312785920
warning, bad space info total_bytes 282394099712 used 458312785920
warning, bad space info total_bytes 283467841536 used 458312785920
warning, bad space info total_bytes 284541583360 used 458312785920
warning, bad space info total_bytes 285615325184 used 458312785920
warning, bad space info total_bytes 286689067008 used 458312785920
warning, bad space info total_bytes 287762808832 used 458312785920
checking extents
checking fs roots
root 268 inode 199959 errors 4c0
root 804 inode 199959 errors 4c0
root 949 inode 199959 errors 4c0
root 951 inode 199959 errors 4c0
root 1249 inode 199959 errors 4c0
