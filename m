From: =?UTF-8?B?QWRhbSBLxYJvYnVrb3dza2k=?= <adamklobukowski@gmail.com>
Subject: fsck.btrfs dumps core
Date: Thu, 25 Feb 2010 09:45:33 +0100
Message-ID: <4B8638AD.5090408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I'm running Ubuntu Lucid (2.6.32-14-generic-pae #20-Ubuntu SMP Sat Feb
20 07:07:46 UTC 2010 i686 GNU/Linux)

Doing online fsck.btrfs on 2TB volume dumps core:

$ sudo fsck.btrfs /dev/mapper/truecrypt1
parent transid verify failed on 899904352256 wanted 71346 found 71328
parent transid verify failed on 899904352256 wanted 71346 found 71328
parent transid verify failed on 899904389120 wanted 71336 found 71331
parent transid verify failed on 899904389120 wanted 71336 found 71331
parent transid verify failed on 899904393216 wanted 71336 found 71331
parent transid verify failed on 899904393216 wanted 71336 found 71331
parent transid verify failed on 899904376832 wanted 71335 found 71331
parent transid verify failed on 899904376832 wanted 71335 found 71331
parent transid verify failed on 899904442368 wanted 71341 found 71329
parent transid verify failed on 899904442368 wanted 71341 found 71329
parent transid verify failed on 899904352256 wanted 71346 found 71328
parent transid verify failed on 899904352256 wanted 71346 found 71328
parent transid verify failed on 899904389120 wanted 71336 found 71331
parent transid verify failed on 899904389120 wanted 71336 found 71331
parent transid verify failed on 899904393216 wanted 71336 found 71331
parent transid verify failed on 899904393216 wanted 71336 found 71331
parent transid verify failed on 899904376832 wanted 71335 found 71331
parent transid verify failed on 899904376832 wanted 71335 found 71331
parent transid verify failed on 899904442368 wanted 71341 found 71329
parent transid verify failed on 899904442368 wanted 71341 found 71329
bad block 899904208896
Extent back ref already exists for 899904000000 parent 0 root 2
Extent back ref already exists for 899903991808 parent 0 root 2
Extent back ref already exists for 899903950848 parent 0 root 2
Extent back ref already exists for 899903782912 parent 0 root 2
Extent back ref already exists for 899901321216 parent 0 root 2
Extent back ref already exists for 899890225152 parent 0 root 2
Extent back ref already exists for 1176982183936 parent 0 root 2
Extent back ref already exists for 899890229248 parent 0 root 2
Extent back ref already exists for 822561927168 parent 0 root 2
Extent back ref already exists for 822562041856 parent 0 root 2
Extent back ref already exists for 899889643520 parent 0 root 2
Extent back ref already exists for 899883573248 parent 0 root 2
Extent back ref already exists for 1047033856000 parent 0 root 2
Extent back ref already exists for 899914276864 parent 0 root 2
Extent back ref already exists for 822690476032 parent 0 root 2
Extent back ref already exists for 899913060352 parent 0 root 2
Extent back ref already exists for 968627875840 parent 0 root 2
Extent back ref already exists for 1046943080448 parent 0 root 2
Extent back ref already exists for 968673046528 parent 0 root 2
Extent back ref already exists for 968672169984 parent 0 root 2
Extent back ref already exists for 1046943096832 parent 0 root 2
Extent back ref already exists for 968660586496 parent 0 root 2
Extent back ref already exists for 1047032619008 parent 0 root 2
Extent back ref already exists for 1176869920768 parent 0 root 2
Extent back ref already exists for 968661278720 parent 0 root 2
Extent back ref already exists for 899882000384 parent 0 root 2
Extent back ref already exists for 899890130944 parent 0 root 2
Extent back ref already exists for 1176866443264 parent 0 root 2
Extent back ref already exists for 822677385216 parent 0 root 2
Extent back ref already exists for 899931934720 parent 0 root 2
Extent back ref already exists for 1047034281984 parent 0 root 2
Extent back ref already exists for 1176921595904 parent 0 root 2
Extent back ref already exists for 1176920952832 parent 0 root 2
Extent back ref already exists for 899825037312 parent 0 root 2
Extent back ref already exists for 899904389120 parent 0 root 2
Extent back ref already exists for 899889414144 parent 0 root 2
Extent back ref already exists for 899904352256 parent 0 root 2
Extent back ref already exists for 822602641408 parent 0 root 2
Extent back ref already exists for 899889197056 parent 0 root 2
Extent back ref already exists for 899889401856 parent 0 root 2
Extent back ref already exists for 1253113155584 parent 0 root 2
Extent back ref already exists for 1253666136064 parent 0 root 2
Extent back ref already exists for 899889205248 parent 0 root 2
Extent back ref already exists for 1176982151168 parent 0 root 2
Extent back ref already exists for 899890929664 parent 0 root 2
bad block 899904217088
Extent back ref already exists for 968585400320 parent 0 root 2
Extent back ref already exists for 822565847040 parent 0 root 2
Extent back ref already exists for 899868700672 parent 0 root 2
Extent back ref already exists for 822553374720 parent 0 root 2
Extent back ref already exists for 822552805376 parent 0 root 2
Extent back ref already exists for 899892625408 parent 0 root 2
Extent back ref already exists for 822555660288 parent 0 root 2
Extent back ref already exists for 822557659136 parent 0 root 2
Extent back ref already exists for 822555734016 parent 0 root 2
Extent back ref already exists for 899879940096 parent 0 root 2
Extent back ref already exists for 822574837760 parent 0 root 2
Extent back ref already exists for 899886739456 parent 0 root 2
Extent back ref already exists for 822556057600 parent 0 root 2
Extent back ref already exists for 1176859234304 parent 0 root 2
Extent back ref already exists for 822556090368 parent 0 root 2
Extent back ref already exists for 822555459584 parent 0 root 2
Extent back ref already exists for 1176860024832 parent 0 root 2
Extent back ref already exists for 899899105280 parent 0 root 2
Extent back ref already exists for 822596603904 parent 0 root 2
Extent back ref already exists for 822553538560 parent 0 root 2
Extent back ref already exists for 899889885184 parent 0 root 2
Extent back ref already exists for 899898212352 parent 0 root 2
Extent back ref already exists for 1176864645120 parent 0 root 2
Extent back ref already exists for 1176869376000 parent 0 root 2
Extent back ref already exists for 899880157184 parent 0 root 2
Extent back ref already exists for 822584619008 parent 0 root 2
Extent back ref already exists for 899900350464 parent 0 root 2
Extent back ref already exists for 822552875008 parent 0 root 2
Extent back ref already exists for 899882872832 parent 0 root 2
Extent back ref already exists for 899878047744 parent 0 root 2
Extent back ref already exists for 1176862851072 parent 0 root 2
Extent back ref already exists for 899890319360 parent 0 root 2
Extent back ref already exists for 822552203264 parent 0 root 2
Extent back ref already exists for 899886747648 parent 0 root 2
Extent back ref already exists for 822556540928 parent 0 root 2
Extent back ref already exists for 822554595328 parent 0 root 2
Extent back ref already exists for 822553583616 parent 0 root 2
Extent back ref already exists for 822554345472 parent 0 root 2
Extent back ref already exists for 899880861696 parent 0 root 2
Extent back ref already exists for 822580912128 parent 0 root 2
Extent back ref already exists for 822554968064 parent 0 root 2
Extent back ref already exists for 822550724608 parent 0 root 2
Extent back ref already exists for 822555652096 parent 0 root 2
Extent back ref already exists for 899891175424 parent 0 root 2
Extent back ref already exists for 899891265536 parent 0 root 2
Extent back ref already exists for 899873103872 parent 0 root 2
Extent back ref already exists for 899896008704 parent 0 root 2
Extent back ref already exists for 899892858880 parent 0 root 2
Extent back ref already exists for 899885625344 parent 0 root 2
Extent back ref already exists for 899881668608 parent 0 root 2
Extent back ref already exists for 899891134464 parent 0 root 2
Extent back ref already exists for 899884429312 parent 0 root 2
Extent back ref already exists for 899891032064 parent 0 root 2
Extent back ref already exists for 899899863040 parent 0 root 2
Extent back ref already exists for 899900104704 parent 0 root 2
Extent back ref already exists for 899894284288 parent 0 root 2
Extent back ref already exists for 899887419392 parent 0 root 2
Extent back ref already exists for 899877638144 parent 0 root 2
Extent back ref already exists for 899867930624 parent 0 root 2
Extent back ref already exists for 899872485376 parent 0 root 2
Extent back ref already exists for 899902320640 parent 0 root 2
Extent back ref already exists for 899903303680 parent 0 root 2
Extent back ref already exists for 899885551616 parent 0 root 2
Extent back ref already exists for 899891593216 parent 0 root 2
Extent back ref already exists for 899874852864 parent 0 root 2
Extent back ref already exists for 899879665664 parent 0 root 2
Extent back ref already exists for 899872681984 parent 0 root 2
Extent back ref already exists for 899883786240 parent 0 root 2
Extent back ref already exists for 899900608512 parent 0 root 2
Extent back ref already exists for 899885555712 parent 0 root 2
Extent back ref already exists for 899876745216 parent 0 root 2
Extent back ref already exists for 899882737664 parent 0 root 2
Extent back ref already exists for 899887038464 parent 0 root 2
Extent back ref already exists for 899888332800 parent 0 root 2
Extent back ref already exists for 899889823744 parent 0 root 2
Extent back ref already exists for 899880955904 parent 0 root 2
Extent back ref already exists for 822554624000 parent 0 root 2
Extent back ref already exists for 899899625472 parent 0 root 2
Extent back ref already exists for 899881246720 parent 0 root 2
Extent back ref already exists for 822556037120 parent 0 root 2
Extent back ref already exists for 899878350848 parent 0 root 2
Extent back ref already exists for 899885268992 parent 0 root 2
Extent back ref already exists for 899874516992 parent 0 root 2
Extent back ref already exists for 899893297152 parent 0 root 2
Extent back ref already exists for 899900436480 parent 0 root 2
Extent back ref already exists for 899879632896 parent 0 root 2
Extent back ref already exists for 899882881024 parent 0 root 2
Extent back ref already exists for 899891986432 parent 0 root 2
Extent back ref already exists for 899899158528 parent 0 root 2
Extent back ref already exists for 899890499584 parent 0 root 2
Extent back ref already exists for 899899170816 parent 0 root 2
Extent back ref already exists for 899894296576 parent 0 root 2
Extent back ref already exists for 899890597888 parent 0 root 2
Extent back ref already exists for 899892867072 parent 0 root 2
Extent back ref already exists for 899889909760 parent 0 root 2
Extent back ref already exists for 899892125696 parent 0 root 2
Extent back ref already exists for 899888717824 parent 0 root 2
Extent back ref already exists for 899891605504 parent 0 root 2
Extent back ref already exists for 899890659328 parent 0 root 2
Extent back ref already exists for 899896324096 parent 0 root 2
Extent back ref already exists for 899888115712 parent 0 root 2
leaf parent key incorrect 899904221184
bad block 899904221184
Extent back ref already exists for 899895926784 parent 0 root 2
Extent back ref already exists for 899899277312 parent 0 root 2
Extent back ref already exists for 899901886464 parent 0 root 2
Extent back ref already exists for 899886325760 parent 0 root 2
Extent back ref already exists for 899893858304 parent 0 root 2
Extent back ref already exists for 899881414656 parent 0 root 2
Extent back ref already exists for 899904163840 parent 0 root 2
Extent back ref already exists for 899898023936 parent 0 root 2
Extent back ref already exists for 899881664512 parent 0 root 2
Extent back ref already exists for 899887919104 parent 0 root 2
Extent back ref already exists for 899884298240 parent 0 root 2
Extent back ref already exists for 899887771648 parent 0 root 2
Extent back ref already exists for 899898609664 parent 0 root 2
Extent back ref already exists for 899898580992 parent 0 root 2
Extent back ref already exists for 899899248640 parent 0 root 2
Extent back ref already exists for 899900755968 parent 0 root 2
Extent back ref already exists for 899900366848 parent 0 root 2
Extent back ref already exists for 899897851904 parent 0 root 2
Extent back ref already exists for 899904241664 parent 0 root 2
Extent back ref already exists for 899890470912 parent 0 root 2
Extent back ref already exists for 899898114048 parent 0 root 2
Extent back ref already exists for 899899850752 parent 0 root 2
Extent back ref already exists for 899900588032 parent 0 root 2
Extent back ref already exists for 899899609088 parent 0 root 2
Extent back ref already exists for 899894935552 parent 0 root 2
Extent back ref already exists for 899897532416 parent 0 root 2
Extent back ref already exists for 899900387328 parent 0 root 2
Extent back ref already exists for 899888701440 parent 0 root 2
Extent back ref already exists for 899899576320 parent 0 root 2
Extent back ref already exists for 899890548736 parent 0 root 2
Extent back ref already exists for 899904249856 parent 0 root 2
Extent back ref already exists for 899825541120 parent 0 root 2
Extent back ref already exists for 899891478528 parent 0 root 2
Extent back ref already exists for 899900391424 parent 0 root 2
Extent back ref already exists for 899898601472 parent 0 root 2
Extent back ref already exists for 899887464448 parent 0 root 2
Extent back ref already exists for 899899846656 parent 0 root 2
Extent back ref already exists for 899900776448 parent 0 root 2
Extent back ref already exists for 899894341632 parent 0 root 2
Extent back ref already exists for 899900293120 parent 0 root 2
Extent back ref already exists for 899903528960 parent 0 root 2
Extent back ref already exists for 899894964224 parent 0 root 2
Extent back ref already exists for 899900215296 parent 0 root 2
Extent back ref already exists for 899899707392 parent 0 root 2
Extent back ref already exists for 899900162048 parent 0 root 2
Extent back ref already exists for 899881631744 parent 0 root 2
Extent back ref already exists for 899900604416 parent 0 root 2
Extent back ref already exists for 899825147904 parent 0 root 2
Extent back ref already exists for 899895406592 parent 0 root 2
leaf parent key incorrect 899904274432
bad block 899904274432
Extent back ref already exists for 899899928576 parent 0 root 2
Extent back ref already exists for 899891548160 parent 0 root 2
Extent back ref already exists for 899825455104 parent 0 root 2
Extent back ref already exists for 899885404160 parent 0 root 2
Extent back ref already exists for 899825537024 parent 0 root 2
Extent back ref already exists for 899903811584 parent 0 root 2
Extent back ref already exists for 899900035072 parent 0 root 2
Extent back ref already exists for 899884118016 parent 0 root 2
Extent back ref already exists for 899900190720 parent 0 root 2
Extent back ref already exists for 899900129280 parent 0 root 2
Extent back ref already exists for 899900231680 parent 0 root 2
Extent back ref already exists for 899896307712 parent 0 root 2
Extent back ref already exists for 899825160192 parent 0 root 2
Extent back ref already exists for 899892842496 parent 0 root 2
Extent back ref already exists for 899897610240 parent 0 root 2
Extent back ref already exists for 899885895680 parent 0 root 2
Extent back ref already exists for 899900878848 parent 0 root 2
Extent back ref already exists for 899899744256 parent 0 root 2
Extent back ref already exists for 899894427648 parent 0 root 2
Extent back ref already exists for 899887890432 parent 0 root 2
Extent back ref already exists for 899892723712 parent 0 root 2
Extent back ref already exists for 899899658240 parent 0 root 2
Extent back ref already exists for 899899842560 parent 0 root 2
Extent back ref already exists for 899904315392 parent 0 root 2
Extent back ref already exists for 899900338176 parent 0 root 2
Extent back ref already exists for 899899830272 parent 0 root 2
Extent back ref already exists for 899900010496 parent 0 root 2
Extent back ref already exists for 899903725568 parent 0 root 2
Extent back ref already exists for 899889758208 parent 0 root 2
Extent back ref already exists for 899903664128 parent 0 root 2
Extent back ref already exists for 899903475712 parent 0 root 2
Extent back ref already exists for 899895103488 parent 0 root 2
Extent back ref already exists for 899900239872 parent 0 root 2
Extent back ref already exists for 899897294848 parent 0 root 2
Extent back ref already exists for 899904294912 parent 0 root 2
Extent back ref already exists for 899900305408 parent 0 root 2
Extent back ref already exists for 899898109952 parent 0 root 2
Extent back ref already exists for 899890544640 parent 0 root 2
Extent back ref already exists for 899900747776 parent 0 root 2
Extent back ref already exists for 899900006400 parent 0 root 2
Extent back ref already exists for 899900411904 parent 0 root 2
Extent back ref already exists for 899898642432 parent 0 root 2
Extent back ref already exists for 899904262144 parent 0 root 2
Extent back ref already exists for 899895136256 parent 0 root 2
Extent back ref already exists for 899898646528 parent 0 root 2
Extent back ref already exists for 899900612608 parent 0 root 2
Extent back ref already exists for 899899920384 parent 0 root 2
Extent back ref already exists for 899890446336 parent 0 root 2
Extent back ref already exists for 899899740160 parent 0 root 2
Extent back ref already exists for 899901923328 parent 0 root 2
Extent back ref already exists for 899904147456 parent 0 root 2
Extent back ref already exists for 899900456960 parent 0 root 2
Extent back ref already exists for 899902140416 parent 0 root 2
Extent back ref already exists for 899904065536 parent 0 root 2
Extent back ref already exists for 899900825600 parent 0 root 2
Extent back ref already exists for 899825524736 parent 0 root 2
Extent back ref already exists for 899900874752 parent 0 root 2
Extent back ref already exists for 899900030976 parent 0 root 2
Extent back ref already exists for 899903787008 parent 0 root 2
Extent back ref already exists for 899902296064 parent 0 root 2
Extent back ref already exists for 899825532928 parent 0 root 2
Extent back ref already exists for 899904139264 parent 0 root 2
Extent back ref already exists for 899895173120 parent 0 root 2
Extent back ref already exists for 899893899264 parent 0 root 2
Extent back ref already exists for 899899858944 parent 0 root 2
Extent back ref already exists for 899895463936 parent 0 root 2
Extent back ref already exists for 899904135168 parent 0 root 2
Extent back ref already exists for 899903119360 parent 0 root 2
Extent back ref already exists for 899894378496 parent 0 root 2
Extent back ref already exists for 899894304768 parent 0 root 2
Extent back ref already exists for 899825504256 parent 0 root 2
Extent back ref already exists for 899903205376 parent 0 root 2
Extent back ref already exists for 899902070784 parent 0 root 2
Extent back ref already exists for 899902144512 parent 0 root 2
Extent back ref already exists for 899903836160 parent 0 root 2
Extent back ref already exists for 899825500160 parent 0 root 2
Extent back ref already exists for 899903815680 parent 0 root 2
Extent back ref already exists for 899825426432 parent 0 root 2
Extent back ref already exists for 899900018688 parent 0 root 2
Extent back ref already exists for 899880271872 parent 0 root 2
Extent back ref already exists for 899904413696 parent 0 root 2
Extent back ref already exists for 899885834240 parent 0 root 2
Extent back ref already exists for 899900055552 parent 0 root 2
Extent back ref already exists for 899904401408 parent 0 root 2
Extent back ref already exists for 899901120512 parent 0 root 2
Extent back ref already exists for 899903856640 parent 0 root 2
Extent back ref already exists for 899899887616 parent 0 root 2
Extent back ref already exists for 899903819776 parent 0 root 2
Extent back ref already exists for 899903852544 parent 0 root 2
Extent back ref already exists for 899886088192 parent 0 root 2
Extent back ref already exists for 899904409600 parent 0 root 2
Extent back ref already exists for 899904430080 parent 0 root 2
Extent back ref already exists for 899904266240 parent 0 root 2
Extent back ref already exists for 899895943168 parent 0 root 2
Extent back ref already exists for 899896287232 parent 0 root 2
Extent back ref already exists for 899903897600 parent 0 root 2
Extent back ref already exists for 899896553472 parent 0 root 2
Extent back ref already exists for 899902058496 parent 0 root 2
Extent back ref already exists for 899901874176 parent 0 root 2
Extent back ref already exists for 899902128128 parent 0 root 2
Extent back ref already exists for 899904094208 parent 0 root 2
Extent back ref already exists for 899904405504 parent 0 root 2
Extent back ref already exists for 899904098304 parent 0 root 2
Extent back ref already exists for 899902550016 parent 0 root 2
Extent back ref already exists for 899902722048 parent 0 root 2
Extent back ref already exists for 899825442816 parent 0 root 2
Extent back ref already exists for 899825528832 parent 0 root 2
Extent back ref already exists for 899904417792 parent 0 root 2
Extent back ref already exists for 899904421888 parent 0 root 2
Extent back ref already exists for 899904311296 parent 0 root 2
Extent back ref already exists for 899904376832 parent 0 root 2
Extent back ref already exists for 899904380928 parent 0 root 2
Extent back ref already exists for 899904307200 parent 0 root 2
Extent back ref already exists for 1176957710336 parent 0 root 2
Extent back ref already exists for 899883954176 parent 0 root 2
Extent back ref already exists for 1253106851840 parent 0 root 2
Extent back ref already exists for 1253094600704 parent 0 root 2
Extent back ref already exists for 822590058496 parent 0 root 2
Extent back ref already exists for 822607646720 parent 0 root 2
Extent back ref already exists for 822608965632 parent 0 root 2
Extent back ref already exists for 899889393664 parent 0 root 2
Extent back ref already exists for 1176964173824 parent 0 root 2
Extent back ref already exists for 1176939741184 parent 0 root 2
Extent back ref already exists for 899848839168 parent 0 root 2
Extent back ref already exists for 1253570670592 parent 0 root 2
Extent back ref already exists for 1253509734400 parent 0 root 2
Extent back ref already exists for 1253488431104 parent 0 root 2
Extent back ref already exists for 1253494444032 parent 0 root 2
Extent back ref already exists for 1253497716736 parent 0 root 2
Extent back ref already exists for 1253427380224 parent 0 root 2
leaf parent key incorrect 899904376832
bad block 899904376832
leaf parent key incorrect 899904380928
bad block 899904380928
leaf parent key incorrect 899904389120
bad block 899904389120
block 899825254400 rec extent_item_refs 1, passed 1
block 899825270784 rec extent_item_refs 1, passed 1
block 899825274880 rec extent_item_refs 1, passed 1
block 899825278976 rec extent_item_refs 1, passed 1
block 899825291264 rec extent_item_refs 1, passed 1
block 899825295360 rec extent_item_refs 1, passed 1
block 899825307648 rec extent_item_refs 1, passed 1
block 899825315840 rec extent_item_refs 1, passed 1
block 899825328128 rec extent_item_refs 1, passed 1
block 899825340416 rec extent_item_refs 1, passed 1
block 899825377280 rec extent_item_refs 1, passed 1
block 899825385472 rec extent_item_refs 1, passed 1
block 899825397760 rec extent_item_refs 1, passed 1
block 899825401856 rec extent_item_refs 1, passed 1
block 899825405952 rec extent_item_refs 1, passed 1
block 899825418240 rec extent_item_refs 1, passed 1
block 899825422336 rec extent_item_refs 1, passed 1
block 899825426432 rec extent_item_refs 1, passed 1
Extent back ref already exists for 899825426432 parent 0 root 2
block 899825442816 rec extent_item_refs 1, passed 1
Extent back ref already exists for 899825442816 parent 0 root 2
block 899825451008 rec extent_item_refs 1, passed 1
block 899825455104 rec extent_item_refs 1, passed 1
Extent back ref already exists for 899825455104 parent 0 root 2
block 899825463296 rec extent_item_refs 1, passed 1
block 899825479680 rec extent_item_refs 1, passed 1
leaf 899904557056 items 23 free space 2247 generation 71336 owner 2
fs uuid 10cd3023-e147-406e-8ee1-7ffffd842f78
chunk uuid ec622945-515e-4372-b9a7-2940962082c0
	item 0 key (899825254400 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
		extent refs 1 gen 15457 flags 2
		tree block key (229358 6c 526929920) level 0
		tree block backref root 5
	item 1 key (899825270784 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
		extent refs 1 gen 33014 flags 2
		tree block key (18446744073709551606 80 876202725376) level 0
		tree block backref root 7
	item 2 key (899825274880 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
		extent refs 1 gen 33020 flags 2
		tree block key (18446744073709551606 80 876202725376) level 0
		tree block backref root 7
	item 3 key (899825278976 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
		extent refs 1 gen 15452 flags 2
		tree block key (229323 6c 867704832) level 0
		tree block backref root 5
	item 4 key (899825291264 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
		extent refs 1 gen 15467 flags 2
		tree block key (229326 6c 51318784) level 0
		tree block backref root 5
	item 5 key (899825295360 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
		extent refs 1 gen 33014 flags 2
		tree block key (18446744073709551606 80 876202725376) level 0
		tree block backref root 7
	item 6 key (899825307648 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
		extent refs 1 gen 19658 flags 2
		tree block key (229449 6c 303013888) level 0
		tree block backref root 5
	item 7 key (899825315840 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
		extent refs 1 gen 33014 flags 2
		tree block key (18446744073709551606 80 876202692608) level 0
		tree block backref root 7
	item 8 key (899825328128 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
		extent refs 1 gen 33028 flags 2
		tree block key (18446744073709551606 80 875670032384) level 0
		tree block backref root 7
	item 9 key (899825340416 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
		extent refs 1 gen 48471 flags 2
		tree block key (1047329595392 a8 4096) level 0
		tree block backref root 2
	item 10 key (899825377280 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
		extent refs 1 gen 33024 flags 2
		tree block key (18446744073709551606 80 875539238912) level 0
		tree block backref root 7
	item 11 key (899825385472 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
		extent refs 1 gen 33016 flags 2
		tree block key (18446744073709551606 80 876202725376) level 0
		tree block backref root 7
	item 12 key (899825397760 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
		extent refs 1 gen 33016 flags 2
		tree block key (18446744073709551606 80 876202692608) level 0
		tree block backref root 7
	item 13 key (899825401856 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
		extent refs 1 gen 15452 flags 2
		tree block key (18446744073709551606 80 764018331648) level 0
		tree block backref root 7
	item 14 key (899825405952 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
		extent refs 1 gen 15537 flags 2
		tree block key (229299 6c 164470784) level 0
		tree block backref root 5
	item 15 key (899825418240 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
		extent refs 1 gen 19660 flags 2
		tree block key (229352 6c 167321600) level 0
		tree block backref root 5
	item 16 key (899825422336 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
		extent refs 1 gen 33016 flags 2
		tree block key (18446744073709551606 80 876202692608) level 0
		tree block backref root 7
	item 17 key (899825426432 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
		extent refs 1 gen 71326 flags 2
		tree block key (899896332288 a8 4096) level 0
		tree block backref root 2
	item 18 key (899825442816 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
		extent refs 1 gen 71326 flags 2
		tree block key (899902763008 a8 4096) level 0
		tree block backref root 2
	item 19 key (899825451008 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
		extent refs 1 gen 33022 flags 2
		tree block key (18446744073709551606 80 875468374016) level 0
		tree block backref root 7
	item 20 key (899825455104 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
		extent refs 1 gen 71326 flags 2
		tree block key (899879698432 a8 4096) level 0
		tree block backref root 2
	item 21 key (899825463296 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
		extent refs 1 gen 33024 flags 2
		tree block key (18446744073709551606 80 876202725376) level 0
		tree block backref root 7
	item 22 key (899825479680 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
		extent refs 1 gen 33027 flags 2
		tree block key (247161 60 15) level 0
		tree block backref root 5
failed to find block number 899825430528
Aborted (core dumped)

I uploaded compressed core dump here:
http://dl.dropbox.com/u/174491/core.tar.bz2

Adam Klobukowski
