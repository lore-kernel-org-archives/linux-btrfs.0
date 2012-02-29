From: Travis Shivers <ttshivers@gmail.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Wed, 29 Feb 2012 15:57:19 -0600
Message-ID: <CAPeorG9u6Z-Z5QnxAc5QB3ZzrR17+3Y2t-UQFd8v_aqN-rVwTA@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com> <20120229025027.GB15383@shiny>
 <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
 <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
 <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com> <20120229135926.GB5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Travis Shivers <ttshivers@gmail.com>,
	cwillu <cwillu@cwillu.com>, Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120229135926.GB5054@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Here is the output from the commands:

# ./btrfs-debug-tree -R /dev/sdh
failed to read /dev/sr0: No medium found
failed to read /dev/sde: No medium found
failed to read /dev/sdd: No medium found
failed to read /dev/sdc: No medium found
failed to read /dev/sdb: No medium found
failed to read /dev/sda: No medium found
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
Ignoring transid failure
root tree: 5568194412544 level 1
chunk tree: 20979712 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 5568194416640 level 3
device tree key (DEV_TREE ROOT_ITEM 0) 4895076519936 level 1
fs tree key (FS_TREE ROOT_ITEM 0) 4895092506624 level 2
checksum tree key (CSUM_TREE ROOT_ITEM 0) 5568194695168 level 0
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
Ignoring transid failure
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568195043328 wanted 43477 found 43151
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
Ignoring transid failure
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
Ignoring transid failure
btrfs root backup slot 0
        tree root gen 9799893461141291008 block 0
                extent root gen 67174399 block 9799996369115086847
                chunk root gen 18446605274118684671 block 9799972705260=
863487
                device root gen 9799997658994114559 block 1844663853462=
8474880
                csum root gen 94490787839 block 18446638559949619199
                fs root gen 262144 block 1048576
                9799994850661629952 used 0 total 9799997659432419327 de=
vices
btrfs root backup slot 1
        tree root gen 16777216 block 38655295488
                extent root gen 1179648 block 6989415099341275135
                chunk root gen 18446605285113004031 block 9799997659432=
353792
                device root gen 9223372036861329408 block 0
                csum root gen 65535 block 9799997659424489472
                fs root gen 4295032832 block 25769803776
                282399669551104 used 282400664715264 total
9799892621752008704 devices
btrfs root backup slot 2
        tree root gen 65535 block 18446744073709551615
                extent root gen 9799997659447099391 block 9799997659447=
033856
                chunk root gen 0 block 0
                device root gen 9799997659449196543 block 9799997659449=
196543
                csum root gen 9799997659450703872 block 901956960255
                fs root gen 9799997659448147967 block 97999976594481479=
67
                9799893460940029951 used 9799997659450769407 total 6553=
5 devices
btrfs root backup slot 3
        tree root gen 0 block 0
                extent root gen 65535 block 9799979012494262271
                chunk root gen 9799979012481613824 block 0
                device root gen 65535 block 9799892621364101119
                csum root gen 9799997659461255167 block 979999765946118=
9632
                fs root gen 9799997659459158015 block 97999976594590924=
80
                131071 used 9799892620200181759 total
9799997659463286784 devices
total bytes 5001013592064
bytes used 1186021638144
uuid 2c11a326-5630-484e-9f1d-9dab777a1028
Btrfs Btrfs v0.19



# ./btrfs-debug-tree -b 5568194695168 /dev/sdh
failed to read /dev/sr0: No medium found
failed to read /dev/sde: No medium found
failed to read /dev/sdd: No medium found
failed to read /dev/sdc: No medium found
failed to read /dev/sdb: No medium found
failed to read /dev/sda: No medium found
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
Ignoring transid failure
leaf 5568194695168 items 31 free space 2073 generation 43151 owner 2
fs uuid 2c11a326-5630-484e-9f1d-9dab777a1028
chunk uuid eb803623-85bd-4854-b39a-5c8126133242
        item 0 key (5670333079552 EXTENT_ITEM 524288) itemoff 3958 item=
size 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818740224 count 1
        item 1 key (5670333603840 EXTENT_ITEM 524288) itemoff 3921 item=
size 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818740224 count 1
        item 2 key (5670334128128 EXTENT_ITEM 524288) itemoff 3884 item=
size 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818740224 count 1
        item 3 key (5670334652416 EXTENT_ITEM 524288) itemoff 3847 item=
size 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818740224 count 1
        item 4 key (5670335176704 EXTENT_ITEM 524288) itemoff 3810 item=
size 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818740224 count 1
        item 5 key (5670335700992 EXTENT_ITEM 4096) itemoff 3773 itemsi=
ze 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306856251392 count 1
        item 6 key (5670335705088 EXTENT_ITEM 4096) itemoff 3736 itemsi=
ze 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306856251392 count 1
        item 7 key (5670335709184 EXTENT_ITEM 4096) itemoff 3699 itemsi=
ze 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306856251392 count 1
        item 8 key (5670335713280 EXTENT_ITEM 4096) itemoff 3662 itemsi=
ze 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306856251392 count 1
        item 9 key (5670335717376 EXTENT_ITEM 4096) itemoff 3625 itemsi=
ze 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818945024 count 1
        item 10 key (5670335721472 EXTENT_ITEM 4096) itemoff 3588 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818945024 count 1
        item 11 key (5670335725568 EXTENT_ITEM 4096) itemoff 3551 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306818945024 count 1
        item 12 key (5670335729664 EXTENT_ITEM 4096) itemoff 3514 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306819330048 count 1
        item 13 key (5670335733760 EXTENT_ITEM 4096) itemoff 3477 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306819330048 count 1
        item 14 key (5670335737856 EXTENT_ITEM 4096) itemoff 3440 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306819330048 count 1
        item 15 key (5670335741952 EXTENT_ITEM 4096) itemoff 3403 items=
ize 37
                extent refs 1 gen 42674 flags 1
                shared data backref parent 5306820034560 count 1
        item 16 key (5670335746048 EXTENT_ITEM 118784) itemoff 3366 ite=
msize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306850168832 count 1
        item 17 key (5670335864832 EXTENT_ITEM 118784) itemoff 3329 ite=
msize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306850168832 count 1
        item 18 key (5670335983616 EXTENT_ITEM 4096) itemoff 3292 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306815574016 count 1
        item 19 key (5670335987712 EXTENT_ITEM 4096) itemoff 3255 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306815574016 count 1
        item 20 key (5670335991808 EXTENT_ITEM 4096) itemoff 3218 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306815574016 count 1
        item 21 key (5670335995904 EXTENT_ITEM 4096) itemoff 3181 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306858049536 count 1
        item 22 key (5670336000000 EXTENT_ITEM 4096) itemoff 3144 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306822180864 count 1
        item 23 key (5670336004096 EXTENT_ITEM 4096) itemoff 3107 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306820034560 count 1
        item 24 key (5670336008192 EXTENT_ITEM 53248) itemoff 3070 item=
size 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306820165632 count 1
        item 25 key (5670336061440 EXTENT_ITEM 4096) itemoff 3033 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306858049536 count 1
        item 26 key (5670336065536 EXTENT_ITEM 4096) itemoff 2996 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306820034560 count 1
        item 27 key (5670336069632 EXTENT_ITEM 4096) itemoff 2959 items=
ize 37
                extent refs 1 gen 42683 flags 1
                shared data backref parent 5306820034560 count 1
        item 28 key (5670336073728 EXTENT_ITEM 126976) itemoff 2922 ite=
msize 37
                extent refs 1 gen 42845 flags 1
                shared data backref parent 5306845855744 count 1
        item 29 key (5670336200704 EXTENT_ITEM 122880) itemoff 2885 ite=
msize 37
                extent refs 1 gen 42845 flags 1
                shared data backref parent 5306845855744 count 1
        item 30 key (5670336401408 EXTENT_ITEM 122880) itemoff 2848 ite=
msize 37
                extent refs 1 gen 42845 flags 1
                shared data backref parent 5306845855744 count 1



# ./btrfsck /dev/sdh
failed to read /dev/sr0: No medium found
failed to read /dev/sde: No medium found
failed to read /dev/sdd: No medium found
failed to read /dev/sdc: No medium found
failed to read /dev/sdb: No medium found
failed to read /dev/sda: No medium found
failed to read /dev/sr0: No medium found
failed to read /dev/sde: No medium found
failed to read /dev/sdd: No medium found
failed to read /dev/sdc: No medium found
failed to read /dev/sdb: No medium found
failed to read /dev/sda: No medium found
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
parent transid verify failed on 5568194695168 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
parent transid verify failed on 5568194748416 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
parent transid verify failed on 5568194801664 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
parent transid verify failed on 5568194674688 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
parent transid verify failed on 5568194678784 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
parent transid verify failed on 5568194809856 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
parent transid verify failed on 5568194875392 wanted 43477 found 42983
Ignoring transid failure
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
parent transid verify failed on 5568195104768 wanted 43477 found 43151
Ignoring transid failure
parent transid verify failed on 5568195043328 wanted 43477 found 43151
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
parent transid verify failed on 5568195162112 wanted 43477 found 43175
Ignoring transid failure
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
parent transid verify failed on 5568195166208 wanted 43477 found 43175
Ignoring transid failure
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
parent transid verify failed on 5568195178496 wanted 43477 found 43151
Ignoring transid failure
leaf 5568195178496 items 33 free space 1487 generation 43151 owner 2
fs uuid 2c11a326-5630-484e-9f1d-9dab777a1028
chunk uuid eb803623-85bd-4854-b39a-5c8126133242
        item 0 key (4788521545728 EXTENT_ITEM 4096) itemoff 3944 itemsi=
ze 51
                extent refs 1 gen 43146 flags 2
                tree block key (5650061463552 a8 126976) level 0
                tree block backref root 2
        item 1 key (4788521578496 EXTENT_ITEM 4096) itemoff 3893 itemsi=
ze 51
                extent refs 1 gen 43146 flags 2
                tree block key (5689786920960 a8 524288) level 0
                tree block backref root 2
        item 2 key (4788521582592 EXTENT_ITEM 4096) itemoff 3842 itemsi=
ze 51
                extent refs 1 gen 43146 flags 2
                tree block key (5690869415936 c0 1073741824) level 0
                tree block backref root 2
        item 3 key (4788521607168 EXTENT_ITEM 4096) itemoff 3791 itemsi=
ze 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895059722240 a8 4096) level 0
                tree block backref root 2
        item 4 key (4788521615360 EXTENT_ITEM 4096) itemoff 3740 itemsi=
ze 51
                extent refs 1 gen 43080 flags 2
                tree block key (5412215951360 a8 524288) level 0
                tree block backref root 2
        item 5 key (4788521648128 EXTENT_ITEM 4096) itemoff 3689 itemsi=
ze 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 2302121607168) =
level 2
                tree block backref root 7
        item 6 key (4788521652224 EXTENT_ITEM 4096) itemoff 3638 itemsi=
ze 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 2303572869120) =
level 1
                tree block backref root 7
        item 7 key (4788521656320 EXTENT_ITEM 4096) itemoff 3587 itemsi=
ze 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 2303659085824) =
level 0
                tree block backref root 7
        item 8 key (4788521660416 EXTENT_ITEM 4096) itemoff 3536 itemsi=
ze 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 4605637316608) =
level 2
                tree block backref root 7
        item 9 key (4788521664512 EXTENT_ITEM 4096) itemoff 3485 itemsi=
ze 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 4619434360832) =
level 1
                tree block backref root 7
        item 10 key (4788521668608 EXTENT_ITEM 4096) itemoff 3434 items=
ize 51
                extent refs 1 gen 43066 flags 2
                tree block key (18446744073709551606 80 4619539591168) =
level 0
                tree block backref root 7
        item 11 key (4788521672704 EXTENT_ITEM 4096) itemoff 3383 items=
ize 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895089258496 a8 4096) level 0
                tree block backref root 2
        item 12 key (4788521684992 EXTENT_ITEM 4096) itemoff 3332 items=
ize 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895175733248 a8 4096) level 0
                tree block backref root 2
        item 13 key (4788521693184 EXTENT_ITEM 4096) itemoff 3281 items=
ize 51
                extent refs 1 gen 38544 flags 2
                tree block key (5038561599488 a8 524288) level 0
                tree block backref root 2
        item 14 key (4788521701376 EXTENT_ITEM 4096) itemoff 3230 items=
ize 51
                extent refs 1 gen 38544 flags 2
                tree block key (5038573133824 a8 524288) level 0
                tree block backref root 2
        item 15 key (4788521709568 EXTENT_ITEM 4096) itemoff 3179 items=
ize 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895187546112 a8 4096) level 0
                tree block backref root 2
        item 16 key (4788521713664 EXTENT_ITEM 4096) itemoff 3128 items=
ize 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895194083328 a8 4096) level 0
                tree block backref root 2
        item 17 key (4788521717760 EXTENT_ITEM 4096) itemoff 3077 items=
ize 51
                extent refs 1 gen 41843 flags 2
                tree block key (2258862821376 a8 4096) level 0
                tree block backref root 2
        item 18 key (4788521721856 EXTENT_ITEM 4096) itemoff 3026 items=
ize 51
                extent refs 1 gen 43146 flags 2
                tree block key (4895209906176 a8 4096) level 0
                tree block backref root 2
        item 19 key (4788521750528 EXTENT_ITEM 4096) itemoff 2975 items=
ize 51
                extent refs 1 gen 42948 flags 2
                tree block key (4665125572608 a8 4096) level 0
                tree block backref root 2
        item 20 key (4788521762816 EXTENT_ITEM 4096) itemoff 2924 items=
ize 51
                extent refs 1 gen 42957 flags 2
                tree block key (5701354262528 a8 524288) level 0
                tree block backref root 2
        item 21 key (4788521766912 EXTENT_ITEM 4096) itemoff 2873 items=
ize 51
                extent refs 1 gen 42957 flags 2
                tree block key (5701371514880 a8 524288) level 0
                tree block backref root 2
        item 22 key (4788521803776 EXTENT_ITEM 4096) itemoff 2822 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (4895112712192 a8 4096) level 0
                tree block backref root 2
        item 23 key (4788521807872 EXTENT_ITEM 4096) itemoff 2771 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (4895100817408 a8 4096) level 0
                tree block backref root 2
        item 24 key (4788521852928 EXTENT_ITEM 4096) itemoff 2720 items=
ize 51
                extent refs 1 gen 38079 flags 2
                tree block key (5122365489152 a8 524288) level 0
                tree block backref root 2
        item 25 key (4788521857024 EXTENT_ITEM 4096) itemoff 2669 items=
ize 51
                extent refs 1 gen 38079 flags 2
                tree block key (5123019517952 a8 524288) level 0
                tree block backref root 2
        item 26 key (4788521865216 EXTENT_ITEM 4096) itemoff 2618 items=
ize 51
                extent refs 1 gen 42388 flags 2
                tree block key (4713088446464 a8 4096) level 0
                tree block backref root 2
        item 27 key (4788521893888 EXTENT_ITEM 4096) itemoff 2567 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (5562510573568 a8 524288) level 0
                tree block backref root 2
        item 28 key (4788521902080 EXTENT_ITEM 4096) itemoff 2516 items=
ize 51
                extent refs 1 gen 43147 flags 2
                tree block key (4788458668032 a8 4096) level 0
                tree block backref root 2
        item 29 key (4788521906176 EXTENT_ITEM 4096) itemoff 2465 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (18446744073709551606 80 5562460946432) =
level 1
                tree block backref root 7
        item 30 key (4788521910272 EXTENT_ITEM 4096) itemoff 2414 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (18446744073709551606 80 5562515656704) =
level 0
                tree block backref root 7
        item 31 key (4788521930752 EXTENT_ITEM 4096) itemoff 2363 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (18446744073709551606 80 5625948966912) =
level 0
                tree block backref root 7
        item 32 key (4788521938944 EXTENT_ITEM 4096) itemoff 2312 items=
ize 51
                extent refs 1 gen 43145 flags 2
                tree block key (5627336638464 a8 524288) level 0
                tree block backref root 2
failed to find block number 4895076519936
Aborted


On Wed, Feb 29, 2012 at 7:59 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, Feb 28, 2012 at 09:36:35PM -0600, Travis Shivers wrote:
>> I upgraded my kernel so my version is now:
>> Linux server 3.3.0-030300rc5-generic #201202251535 SMP Sat Feb 25
>> 20:36:29 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>>
>> The problem has not been solved and I still get the previous errors.
>
> Ok,
>
> Step one is to grab the development version of btrfs-progs, which
> currently sits in the dangerdonteveruse branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git d=
angerdonteveruse
>
> Run btrfs-debug-tree -R /dev/sdh
>
> and then run btrfs-debug-tree -b 5568194695168 /dev/sdh
>
> and then run btrfsck /dev/sdh
>
> Send the results of all three here, it should tell us which tree that
> block belongs to, and from there we'll figure out the best way to fix
> it.
>
> -chris
>
>>
>> # mount /dev/sdh /mnt/main
>> mount: wrong fs type, bad option, bad superblock on /dev/sdh,
>> =A0 =A0 =A0 =A0missing codepage or helper program, or other error
>> =A0 =A0 =A0 =A0In some cases useful info is found in syslog - try
>> =A0 =A0 =A0 =A0dmesg | tail =A0or so
>>
>> # dmesg
>> [ =A0232.985248] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 de=
vid
>> 4 transid 43477 /dev/sdi
>> [ =A0232.985434] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 de=
vid
>> 3 transid 43477 /dev/sdh
>> [ =A0233.027881] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 de=
vid
>> 2 transid 43477 /dev/sdg
>> [ =A0233.065675] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 de=
vid
>> 1 transid 43476 /dev/sdf
>> [ =A0284.384320] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 de=
vid
>> 3 transid 43477 /dev/sdh
>> [ =A0284.427076] btrfs: disk space caching is enabled
>> [ =A0284.442565] verify_parent_transid: 2 callbacks suppressed
>> [ =A0284.442572] parent transid verify failed on 5568194695168 wante=
d
>> 43477 found 43151
>> [ =A0284.442834] parent transid verify failed on 5568194695168 wante=
d
>> 43477 found 43151
>> [ =A0284.443151] parent transid verify failed on 5568194695168 wante=
d
>> 43477 found 43151
>> [ =A0284.443159] parent transid verify failed on 5568194695168 wante=
d
>> 43477 found 43151
>> [ =A0284.445740] btrfs: open_ctree failed
>>
>>
>> On Tue, Feb 28, 2012 at 9:16 PM, cwillu <cwillu@cwillu.com> wrote:
>> > On Tue, Feb 28, 2012 at 9:00 PM, Travis Shivers <ttshivers@gmail.c=
om> wrote:
>> >> Where should I grab the source from? The main repo that you have
>> >> listed on your main wiki page
>> >> (https://btrfs.wiki.kernel.org/articles/b/t/r/Btrfs_source_reposi=
tories.html)
>> >> is down: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrf=
s-progs-unstable.git
>> >
>> > The btrfs wiki is at http://btrfs.ipv5.de . =A0The kernel.org one =
is a
>> > static snapshot of the contents made nearly a year ago, prior to t=
he
>> > kernel.org break-in, and should be ignored.
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.gi=
t is
>> > the development tree, although the above patch is in mainline as o=
f
>> > 3.3rc5, which probably makes that the easiest way to try it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
