From: corey richey <thewhitetruck@gmail.com>
Subject: mount freezes and btrsfck aborts...
Date: Sat, 5 Mar 2011 21:55:53 -0800
Message-ID: <AANLkTinvO6r-Rdi7=-=aa9A=Dd8vsCGS=dijhiWhCf0k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have kernel 2.6.35-27 I had -25 but upgraded. When I had -25 I could
mount /dev/sda /media/tank and I could cd into directories on my pool
I just hung on ls. Same as this person's problem.
http://kerneltrap.org/mailarchive/linux-btrfs/2010/11/23/6886281/thread
same problem similar output on dmesg

Now I can't even mount it just freezes on mount. I had a power outage
and ever since my btrsfck aborts.

Here is the output of btrsfck. Any help would be greatly appreciated.
I am about to re-install and try and remount(export then import in
zfs) my volume. I am very worried about losing the data.

failed to read /dev/sr0
parent transid verify failed on 949899927552 wanted 27464 found 27272
parent transid verify failed on 949899927552 wanted 27464 found 27272
parent transid verify failed on 949973196800 wanted 27463 found 27395
parent transid verify failed on 949973196800 wanted 27463 found 27395
parent transid verify failed on 949973200896 wanted 27463 found 27395
parent transid verify failed on 949973200896 wanted 27463 found 27395
parent transid verify failed on 949973209088 wanted 27463 found 27395
parent transid verify failed on 949973209088 wanted 27463 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949971496960 wanted 27472 found 27395
parent transid verify failed on 949971496960 wanted 27472 found 27395
parent transid verify failed on 949980672000 wanted 27407 found 27394
parent transid verify failed on 949980672000 wanted 27407 found 27394
parent transid verify failed on 949980364800 wanted 27415 found 27392
parent transid verify failed on 949980364800 wanted 27415 found 27392
parent transid verify failed on 949983412224 wanted 27423 found 27394
parent transid verify failed on 949983412224 wanted 27423 found 27394
parent transid verify failed on 949981847552 wanted 27450 found 27394
parent transid verify failed on 949981847552 wanted 27450 found 27394
parent transid verify failed on 949981470720 wanted 27464 found 27394
parent transid verify failed on 949981470720 wanted 27464 found 27394
parent transid verify failed on 949964521472 wanted 27465 found 27395
parent transid verify failed on 949964521472 wanted 27465 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
bad block 949888532480
parent transid verify failed on 949896486912 wanted 27471 found 27234
parent transid verify failed on 949896486912 wanted 27471 found 27234
parent transid verify failed on 949971591168 wanted 27471 found 27395
parent transid verify failed on 949971591168 wanted 27471 found 27395
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
parent transid verify failed on 949967835136 wanted 27472 found 27395
parent transid verify failed on 949967835136 wanted 27472 found 27395
leaf parent key incorrect 949903310848
bad block 949903310848
parent transid verify failed on 949968351232 wanted 27472 found 27395
parent transid verify failed on 949968351232 wanted 27472 found 27395
leaf parent key incorrect 949937262592
bad block 949937262592
leaf parent key incorrect 949948174336
bad block 949948174336
parent transid verify failed on 949971087360 wanted 27472 found 27395
parent transid verify failed on 949971087360 wanted 27472 found 27395
parent transid verify failed on 949970014208 wanted 27472 found 27395
parent transid verify failed on 949970014208 wanted 27472 found 27395
parent transid verify failed on 949966995456 wanted 27418 found 27395
parent transid verify failed on 949966995456 wanted 27418 found 27395
bad block 949969018880
parent transid verify failed on 949947502592 wanted 27465 found 27396
parent transid verify failed on 949947502592 wanted 27465 found 27396
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971382272 wanted 27472 found 27395
parent transid verify failed on 949971382272 wanted 27472 found 27395
parent transid verify failed on 949965828096 wanted 27445 found 27395
parent transid verify failed on 949965828096 wanted 27445 found 27395
parent transid verify failed on 949969412096 wanted 27426 found 27395
parent transid verify failed on 949969412096 wanted 27426 found 27395
parent transid verify failed on 949970583552 wanted 27472 found 27395
parent transid verify failed on 949970583552 wanted 27472 found 27395
parent transid verify failed on 949959938048 wanted 27403 found 27395
parent transid verify failed on 949959938048 wanted 27403 found 27395
parent transid verify failed on 949970563072 wanted 27472 found 27395
parent transid verify failed on 949970563072 wanted 27472 found 27395
parent transid verify failed on 949971853312 wanted 27471 found 27395
parent transid verify failed on 949971853312 wanted 27471 found 27395
parent transid verify failed on 949974736896 wanted 27464 found 27395
parent transid verify failed on 949974736896 wanted 27464 found 27395
parent transid verify failed on 949974740992 wanted 27464 found 27395
parent transid verify failed on 949974740992 wanted 27464 found 27395
parent transid verify failed on 949970841600 wanted 27472 found 27395
parent transid verify failed on 949970841600 wanted 27472 found 27395
parent transid verify failed on 949970554880 wanted 27472 found 27395
parent transid verify failed on 949970554880 wanted 27472 found 27395
parent transid verify failed on 949970567168 wanted 27472 found 27395
parent transid verify failed on 949970567168 wanted 27472 found 27395
parent transid verify failed on 949964406784 wanted 27415 found 27395
parent transid verify failed on 949964406784 wanted 27415 found 27395
leaf parent key incorrect 949954445312
bad block 949954445312
parent transid verify failed on 949970432000 wanted 27472 found 27395
parent transid verify failed on 949970432000 wanted 27472 found 27395
parent transid verify failed on 949964673024 wanted 27420 found 27395
parent transid verify failed on 949964673024 wanted 27420 found 27395
parent transid verify failed on 949971210240 wanted 27460 found 27395
parent transid verify failed on 949971210240 wanted 27460 found 27395
parent transid verify failed on 949971079168 wanted 27472 found 27395
parent transid verify failed on 949971079168 wanted 27472 found 27395
parent transid verify failed on 949969911808 wanted 27447 found 27395
parent transid verify failed on 949969911808 wanted 27447 found 27395
parent transid verify failed on 949971247104 wanted 27472 found 27395
parent transid verify failed on 949971247104 wanted 27472 found 27395
parent transid verify failed on 949970681856 wanted 27458 found 27395
parent transid verify failed on 949970681856 wanted 27458 found 27395
parent transid verify failed on 949970690048 wanted 27458 found 27395
parent transid verify failed on 949970690048 wanted 27458 found 27395
parent transid verify failed on 949970018304 wanted 27472 found 27395
parent transid verify failed on 949970018304 wanted 27472 found 27395
Extent back ref already exists for 786523324416 parent 0 root 2
Extent back ref already exists for 786519486464 parent 0 root 2
Extent back ref already exists for 866011860992 parent 0 root 2
Extent back ref already exists for 786523312128 parent 0 root 2
Extent back ref already exists for 786521419776 parent 0 root 2
Extent back ref already exists for 786523308032 parent 0 root 2
Extent back ref already exists for 786521124864 parent 0 root 2
Extent back ref already exists for 786523299840 parent 0 root 2
Extent back ref already exists for 786520580096 parent 0 root 2
Extent back ref already exists for 786523295744 parent 0 root 2
Extent back ref already exists for 786522353664 parent 0 root 2
Extent back ref already exists for 786520428544 parent 0 root 2
Extent back ref already exists for 786523283456 parent 0 root 2
Extent back ref already exists for 786520395776 parent 0 root 2
Extent back ref already exists for 786523492352 parent 0 root 2
Extent back ref already exists for 786523279360 parent 0 root 2
Extent back ref already exists for 786522836992 parent 0 root 2
Extent back ref already exists for 786521321472 parent 0 root 2
Extent back ref already exists for 786523275264 parent 0 root 2
Extent back ref already exists for 786520944640 parent 0 root 2
Extent back ref already exists for 786523262976 parent 0 root 2
Extent back ref already exists for 786523258880 parent 0 root 2
Extent back ref already exists for 786523254784 parent 0 root 2
Extent back ref already exists for 786523246592 parent 0 root 2
Extent back ref already exists for 786523230208 parent 0 root 2
Extent back ref already exists for 786494099456 parent 0 root 2
Extent back ref already exists for 786523226112 parent 0 root 2
Extent back ref already exists for 786520256512 parent 0 root 2
Extent back ref already exists for 786523201536 parent 0 root 2
Extent back ref already exists for 786522349568 parent 0 root 2
Extent back ref already exists for 949888536576 parent 0 root 2
Extent back ref already exists for 786523197440 parent 0 root 2
Extent back ref already exists for 786523136000 parent 0 root 2
Extent back ref already exists for 786522345472 parent 0 root 2
Extent back ref already exists for 786522341376 parent 0 root 2
Extent back ref already exists for 786475098112 parent 0 root 2
Extent back ref already exists for 786523062272 parent 0 root 2
Extent back ref already exists for 866003828736 parent 0 root 2
Extent back ref already exists for 786520170496 parent 0 root 2
Extent back ref already exists for 786522329088 parent 0 root 2
Extent back ref already exists for 786523021312 parent 0 root 2
Extent back ref already exists for 786523009024 parent 0 root 2
Extent back ref already exists for 786520694784 parent 0 root 2
Extent back ref already exists for 786523004928 parent 0 root 2
Extent back ref already exists for 786522996736 parent 0 root 2
Extent back ref already exists for 786522316800 parent 0 root 2
Extent back ref already exists for 786522992640 parent 0 root 2
Extent back ref already exists for 786522980352 parent 0 root 2
Extent back ref already exists for 786522976256 parent 0 root 2
Extent back ref already exists for 786522296320 parent 0 root 2
Extent back ref already exists for 786522968064 parent 0 root 2
Extent back ref already exists for 786521223168 parent 0 root 2
Extent back ref already exists for 786476355584 parent 0 root 2
Extent back ref already exists for 786522951680 parent 0 root 2
Extent back ref already exists for 786522947584 parent 0 root 2
Extent back ref already exists for 786522931200 parent 0 root 2
Extent back ref already exists for 786522927104 parent 0 root 2
parent transid verify failed on 949970857984 wanted 27468 found 27395
parent transid verify failed on 949970857984 wanted 27468 found 27395
parent transid verify failed on 949970165760 wanted 27472 found 27395
parent transid verify failed on 949970165760 wanted 27472 found 27395
parent transid verify failed on 949969272832 wanted 27472 found 27395
parent transid verify failed on 949969272832 wanted 27472 found 27395
parent transid verify failed on 949969248256 wanted 27472 found 27395
parent transid verify failed on 949969248256 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949969649664 wanted 27468 found 27395
parent transid verify failed on 949969649664 wanted 27468 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949969661952 wanted 27468 found 27395
parent transid verify failed on 949969661952 wanted 27468 found 27395
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949895487488 wanted 27471 found 27218
parent transid verify failed on 949895487488 wanted 27471 found 27218
parent transid verify failed on 949969670144 wanted 27468 found 27395
parent transid verify failed on 949969670144 wanted 27468 found 27395
parent transid verify failed on 949969674240 wanted 27468 found 27395
parent transid verify failed on 949969674240 wanted 27468 found 27395
parent transid verify failed on 949962035200 wanted 27442 found 27395
parent transid verify failed on 949962035200 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949970026496 wanted 27468 found 27395
parent transid verify failed on 949970026496 wanted 27468 found 27395
parent transid verify failed on 949972238336 wanted 27468 found 27395
parent transid verify failed on 949972238336 wanted 27468 found 27395
parent transid verify failed on 949970063360 wanted 27468 found 27395
parent transid verify failed on 949970063360 wanted 27468 found 27395
parent transid verify failed on 949972156416 wanted 27468 found 27395
parent transid verify failed on 949972156416 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972013056 wanted 27468 found 27395
parent transid verify failed on 949972013056 wanted 27468 found 27395
parent transid verify failed on 949972000768 wanted 27468 found 27395
parent transid verify failed on 949972000768 wanted 27468 found 27395
parent transid verify failed on 949971996672 wanted 27468 found 27395
parent transid verify failed on 949971996672 wanted 27468 found 27395
parent transid verify failed on 949968322560 wanted 27442 found 27395
parent transid verify failed on 949968322560 wanted 27442 found 27395
parent transid verify failed on 949972242432 wanted 27468 found 27395
parent transid verify failed on 949972242432 wanted 27468 found 27395
parent transid verify failed on 949971488768 wanted 27472 found 27395
parent transid verify failed on 949971488768 wanted 27472 found 27395
leaf 949971968000 items 42 free space 803 generation 27468 owner 2
fs uuid fa1d901a-c398-4301-9245-f22ea22be759
chunk uuid 641cefae-a07f-48eb-a673-6bc5816c0dac
    item 0 key (786523049984 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
        extent refs 1 gen 26861 flags 2
        tree block key (18446744073709551606 80 483688468480) level 0
        tree block backref root 7
    item 1 key (786523054080 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
        extent refs 1 gen 26861 flags 2
        tree block key (18446744073709551606 80 483684999168) level 0
        tree block backref root 7
    item 2 key (786523058176 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
        extent refs 1 gen 26861 flags 2
        tree block key (18446744073709551606 80 483692503040) level 0
        tree block backref root 7
    item 3 key (786523062272 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694009442304 a8 4096) level 0
        tree block backref root 2
    item 4 key (786523066368 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
        extent refs 1 gen 26861 flags 2
        tree block key (18446744073709551606 80 483696537600) level 0
        tree block backref root 7
    item 5 key (786523074560 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
        extent refs 1 gen 26771 flags 2
        tree block key (693973000192 a8 4096) level 0
        tree block backref root 2
    item 6 key (786523082752 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
        extent refs 1 gen 22602 flags 2
        tree block key (18446744073709551606 80 923407785984) level 0
        tree block backref root 7
    item 7 key (786523086848 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
        extent refs 1 gen 14615 flags 2
        tree block key (18446744073709551606 80 836780044288) level 0
        tree block backref root 7
    item 8 key (786523090944 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
        extent refs 1 gen 14615 flags 2
        tree block key (18446744073709551606 80 836784078848) level 0
        tree block backref root 7
    item 9 key (786523095040 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
        extent refs 1 gen 22602 flags 2
        tree block key (18446744073709551606 80 923411820544) level 0
        tree block backref root 7
    item 10 key (786523099136 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
        extent refs 1 gen 22602 flags 2
        tree block key (18446744073709551606 80 923415855104) level 0
        tree block backref root 7
    item 11 key (786523103232 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
        extent refs 1 gen 22602 flags 2
        tree block key (18446744073709551606 80 923419889664) level 0
        tree block backref root 7
    item 12 key (786523107328 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
        extent refs 1 gen 22602 flags 2
        tree block key (18446744073709551606 80 923423924224) level 0
        tree block backref root 7
    item 13 key (786523115520 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
        extent refs 1 gen 26771 flags 2
        tree block key (693959757824 a8 4096) level 0
        tree block backref root 2
    item 14 key (786523123712 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
        extent refs 1 gen 26771 flags 2
        tree block key (693986676736 a8 4096) level 0
        tree block backref root 2
    item 15 key (786523127808 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
        extent refs 1 gen 26955 flags 2
        tree block key (694000599040 a8 4096) level 0
        tree block backref root 2
    item 16 key (786523136000 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694008442880 a8 4096) level 0
        tree block backref root 2
    item 17 key (786523140096 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
        extent refs 1 gen 26955 flags 2
        tree block key (693987901440 a8 4096) level 0
        tree block backref root 2
    item 18 key (786523144192 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
        extent refs 1 gen 26600 flags 2
        tree block key (39918 54 3064511953) level 0
        tree block backref root 5
    item 19 key (786523148288 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
        extent refs 1 gen 26600 flags 2
        tree block key (39919 54 1894042088) level 0
        tree block backref root 5
    item 20 key (786523152384 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
        extent refs 1 gen 26977 flags 2
        tree block key (18446744073709551606 80 483969298432) level 0
        tree block backref root 7
    item 21 key (786523156480 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
        extent refs 1 gen 26977 flags 2
        tree block key (18446744073709551606 80 483973332992) level 0
        tree block backref root 7
    item 22 key (786523160576 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919900106752) level 0
        tree block backref root 7
    item 23 key (786523164672 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919904141312) level 0
        tree block backref root 7
    item 24 key (786523168768 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919908175872) level 0
        tree block backref root 7
    item 25 key (786523172864 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919912210432) level 0
        tree block backref root 7
    item 26 key (786523176960 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919916244992) level 0
        tree block backref root 7
    item 27 key (786523181056 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
        extent refs 1 gen 22564 flags 2
        tree block key (18446744073709551606 80 919920279552) level 0
        tree block backref root 7
    item 28 key (786523185152 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
        extent refs 1 gen 26846 flags 2
        tree block key (18446744073709551606 80 153864380416) level 0
        tree block backref root 7
    item 29 key (786523193344 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
        extent refs 1 gen 26600 flags 2
        tree block key (39919 60 33) level 0
        tree block backref root 5
    item 30 key (786523197440 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694008307712 a8 4096) level 0
        tree block backref root 2
    item 31 key (786523201536 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694007767040 a8 4096) level 0
        tree block backref root 2
    item 32 key (786523226112 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694007443456 a8 4096) level 0
        tree block backref root 2
    item 33 key (786523230208 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694007017472 a8 4096) level 0
        tree block backref root 2
    item 34 key (786523246592 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694006706176 a8 4096) level 0
        tree block backref root 2
    item 35 key (786523250688 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
        extent refs 1 gen 26856 flags 2
        tree block key (18446744073709551606 80 316290113536) level 0
        tree block backref root 7
    item 36 key (786523254784 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694006484992 a8 4096) level 0
        tree block backref root 2
    item 37 key (786523258880 EXTENT_ITEM 4096) itemoff 2057 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694006312960 a8 4096) level 0
        tree block backref root 2
    item 38 key (786523262976 EXTENT_ITEM 4096) itemoff 2006 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694006108160 a8 4096) level 0
        tree block backref root 2
    item 39 key (786523267072 EXTENT_ITEM 4096) itemoff 1955 itemsize 51
        extent refs 1 gen 22593 flags 2
        tree block key (18446744073709551606 80 922572083200) level 0
        tree block backref root 7
    item 40 key (786523271168 EXTENT_ITEM 4096) itemoff 1904 itemsize 51
        extent refs 1 gen 22593 flags 2
        tree block key (18446744073709551606 80 922576117760) level 0
        tree block backref root 7
    item 41 key (786523275264 EXTENT_ITEM 4096) itemoff 1853 itemsize 51
        extent refs 1 gen 26934 flags 2
        tree block key (694005637120 a8 4096) level 0
        tree block backref root 2
failed to find block number 786523070464
Aborted
