Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-1.smtp-out.eu-west-1.amazonses.com ([54.240.4.1]:43016 "EHLO
        a4-1.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756069AbcKVQYS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 11:24:18 -0500
From: Martin Raiber <martin@urbackup.org>
Subject: Inconsistent free space with false ENOSPC
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
Date: Tue, 22 Nov 2016 14:16:42 +0000
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030902000904030707010707"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030902000904030707010707
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having a file system which is currently broken because of ENOSPC issu=
es.

It is a single device file system with no compression and no quotas
enabled but with some snapshots. Creation and initial ENOSPC/free space
inconsistency with 4.4.20 and 4.4.30 (both vanilla).
Currently I am on 4.9.0-rc6 and still getting ENOSPC. Interestingly,
after running "btrfs check --repair" "df" shows 0 free space (Used
516456408 Available 0), being inconsistent with the below other btrfs
free space information.

I have tried clearing the space cache, using space_cache=3Dv2 and that
doesn't help. It also cannot balance anything anymore.

Please tell me if anyone is interested in a btrfs-image of the file syste=
m.

btrfs fi usage output:

Overall:
    Device size:                 512.00GiB
    Device allocated:            512.00GiB
    Device unallocated:            1.04MiB
    Device missing:                  0.00B
    Used:                        492.03GiB
    Free (estimated):             19.59GiB      (min: 19.59GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 326.20MiB)

Data,single: Size:507.98GiB, Used:488.39GiB
   /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b  507.98GiB

Metadata,DUP: Size:2.00GiB, Used:1.82GiB
   /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    4.00GiB

System,DUP: Size:8.00MiB, Used:80.00KiB
   /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b   16.00MiB

Unallocated:
   /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    1.04MiB

btrfs-debugs output:

block group offset 1103101952 len 1073741824 used 1029148672
chunk_objectid 256 flags 1 usage 0.96
block group offset 2176843776 len 1073741824 used 1066725376
chunk_objectid 256 flags 1 usage 0.99
block group offset 3250585600 len 1073741824 used 1070731264
chunk_objectid 256 flags 1 usage 1.00
block group offset 4324327424 len 1073741824 used 1066201088
chunk_objectid 256 flags 1 usage 0.99
block group offset 5398069248 len 1073741824 used 1072377856
chunk_objectid 256 flags 1 usage 1.00
block group offset 6471811072 len 1073741824 used 1070784512
chunk_objectid 256 flags 1 usage 1.00
block group offset 7545552896 len 1073741824 used 1069023232
chunk_objectid 256 flags 1 usage 1.00
block group offset 8619294720 len 1073741824 used 1058299904
chunk_objectid 256 flags 1 usage 0.99
block group offset 9693036544 len 1073741824 used 1069408256
chunk_objectid 256 flags 1 usage 1.00
block group offset 10766778368 len 1073741824 used 1070317568
chunk_objectid 256 flags 1 usage 1.00
block group offset 11840520192 len 1073741824 used 1068920832
chunk_objectid 256 flags 1 usage 1.00
block group offset 12914262016 len 1073741824 used 1066930176
chunk_objectid 256 flags 1 usage 0.99
block group offset 13988003840 len 1073741824 used 1072746496
chunk_objectid 256 flags 1 usage 1.00
block group offset 15061745664 len 1073741824 used 1073213440
chunk_objectid 256 flags 1 usage 1.00
block group offset 16135487488 len 1073741824 used 1068171264
chunk_objectid 256 flags 1 usage 0.99
block group offset 17209229312 len 1073741824 used 1071550464
chunk_objectid 256 flags 1 usage 1.00
block group offset 18282971136 len 1073741824 used 1073672192
chunk_objectid 256 flags 1 usage 1.00
block group offset 19356712960 len 1073741824 used 1073508352
chunk_objectid 256 flags 1 usage 1.00
block group offset 20430454784 len 1073741824 used 1073668096
chunk_objectid 256 flags 1 usage 1.00
block group offset 21504196608 len 1073741824 used 1073577984
chunk_objectid 256 flags 1 usage 1.00
block group offset 22577938432 len 1073741824 used 1073483776
chunk_objectid 256 flags 1 usage 1.00
block group offset 23651680256 len 1073741824 used 1072021504
chunk_objectid 256 flags 1 usage 1.00
block group offset 24725422080 len 1073741824 used 1073672192
chunk_objectid 256 flags 1 usage 1.00
block group offset 25799163904 len 1073741824 used 1073176576
chunk_objectid 256 flags 1 usage 1.00
block group offset 26872905728 len 1073741824 used 1073360896
chunk_objectid 256 flags 1 usage 1.00
block group offset 27946647552 len 1073741824 used 1072599040
chunk_objectid 256 flags 1 usage 1.00
block group offset 29020389376 len 1073741824 used 1073524736
chunk_objectid 256 flags 1 usage 1.00
block group offset 31167873024 len 1073741824 used 1073561600
chunk_objectid 256 flags 1 usage 1.00
block group offset 32241614848 len 1073741824 used 1072566272
chunk_objectid 256 flags 1 usage 1.00
block group offset 33315356672 len 1073741824 used 1073635328
chunk_objectid 256 flags 1 usage 1.00
block group offset 34389098496 len 1073741824 used 1073364992
chunk_objectid 256 flags 1 usage 1.00
block group offset 36536582144 len 1073741824 used 1073344512
chunk_objectid 256 flags 1 usage 1.00
block group offset 37610323968 len 1073741824 used 1073381376
chunk_objectid 256 flags 1 usage 1.00
block group offset 38684065792 len 1073741824 used 1067831296
chunk_objectid 256 flags 1 usage 0.99
block group offset 39757807616 len 1073741824 used 1073496064
chunk_objectid 256 flags 1 usage 1.00
block group offset 42979033088 len 1073741824 used 1073692672
chunk_objectid 256 flags 1 usage 1.00
block group offset 52642709504 len 1073741824 used 1071665152
chunk_objectid 256 flags 1 usage 1.00
block group offset 53716451328 len 1073741824 used 1073664000
chunk_objectid 256 flags 1 usage 1.00
block group offset 55863934976 len 1073741824 used 1065877504
chunk_objectid 256 flags 1 usage 0.99
block group offset 65527611392 len 1073741824 used 1073713152
chunk_objectid 256 flags 1 usage 1.00
block group offset 67675095040 len 1073741824 used 1069690880
chunk_objectid 256 flags 1 usage 1.00
block group offset 69822578688 len 1073741824 used 1073594368
chunk_objectid 256 flags 1 usage 1.00
block group offset 77338771456 len 1073741824 used 1073086464
chunk_objectid 256 flags 1 usage 1.00
block group offset 79486255104 len 1073741824 used 1073184768
chunk_objectid 256 flags 1 usage 1.00
block group offset 127804637184 len 1073741824 used 1073606656
chunk_objectid 256 flags 1 usage 1.00
block group offset 131025862656 len 1073741824 used 1073373184
chunk_objectid 256 flags 1 usage 1.00
block group offset 134247088128 len 1073741824 used 1073520640
chunk_objectid 256 flags 1 usage 1.00
block group offset 135320829952 len 1073741824 used 1070874624
chunk_objectid 256 flags 1 usage 1.00
block group offset 136394571776 len 1073741824 used 1073459200
chunk_objectid 256 flags 1 usage 1.00
block group offset 138542055424 len 1073741824 used 1073004544
chunk_objectid 256 flags 1 usage 1.00
block group offset 139615797248 len 1073741824 used 1068949504
chunk_objectid 256 flags 1 usage 1.00
block group offset 143910764544 len 1073741824 used 1072885760
chunk_objectid 256 flags 1 usage 1.00
block group offset 149279473664 len 1073741824 used 1069297664
chunk_objectid 256 flags 1 usage 1.00
block group offset 231957594112 len 1073741824 used 1071689728
chunk_objectid 256 flags 1 usage 1.00
block group offset 233031335936 len 1073741824 used 1073709056
chunk_objectid 256 flags 1 usage 1.00
block group offset 280275976192 len 1073741824 used 1073672192
chunk_objectid 256 flags 1 usage 1.00
block group offset 289939652608 len 1073741824 used 1073561600
chunk_objectid 256 flags 1 usage 1.00
block group offset 296382103552 len 1073741824 used 1072517120
chunk_objectid 256 flags 1 usage 1.00
block group offset 297455845376 len 1073741824 used 1073688576
chunk_objectid 256 flags 1 usage 1.00
block group offset 298529587200 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 325373132800 len 1073741824 used 1073684480
chunk_objectid 256 flags 1 usage 1.00
block group offset 329668100096 len 1073741824 used 1073545216
chunk_objectid 256 flags 1 usage 1.00
block group offset 340405518336 len 1073741824 used 1073078272
chunk_objectid 256 flags 1 usage 1.00
block group offset 359732871168 len 1073741824 used 1073602560
chunk_objectid 256 flags 1 usage 1.00
block group offset 360806612992 len 1073741824 used 1073643520
chunk_objectid 256 flags 1 usage 1.00
block group offset 361880354816 len 1073741824 used 1073471488
chunk_objectid 256 flags 1 usage 1.00
block group offset 364027838464 len 1073741824 used 1073692672
chunk_objectid 256 flags 1 usage 1.00
block group offset 365101580288 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 376912740352 len 1073741824 used 1073598464
chunk_objectid 256 flags 1 usage 1.00
block group offset 390871384064 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 391945125888 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 395166351360 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 396240093184 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 403756285952 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 404830027776 len 1073741824 used 1069752320
chunk_objectid 256 flags 1 usage 1.00
block group offset 411272478720 len 1073741824 used 1073627136
chunk_objectid 256 flags 1 usage 1.00
block group offset 412346220544 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 414493704192 len 1073741824 used 1071886336
chunk_objectid 256 flags 1 usage 1.00
block group offset 415567446016 len 1073741824 used 1072738304
chunk_objectid 256 flags 1 usage 1.00
block group offset 416641187840 len 1073741824 used 1068167168
chunk_objectid 256 flags 1 usage 0.99
block group offset 419862413312 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 420936155136 len 1073741824 used 1073553408
chunk_objectid 256 flags 1 usage 1.00
block group offset 422009896960 len 1073741824 used 1073647616
chunk_objectid 256 flags 1 usage 1.00
block group offset 423083638784 len 1073741824 used 1073721344
chunk_objectid 256 flags 1 usage 1.00
block group offset 424157380608 len 1073741824 used 1073700864
chunk_objectid 256 flags 1 usage 1.00
block group offset 426304864256 len 1073741824 used 1073614848
chunk_objectid 256 flags 1 usage 1.00
block group offset 427378606080 len 1073741824 used 1073725440
chunk_objectid 256 flags 1 usage 1.00
block group offset 434894798848 len 1073741824 used 1073721344
chunk_objectid 256 flags 1 usage 1.00
block group offset 435968540672 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 437042282496 len 1073741824 used 1073594368
chunk_objectid 256 flags 1 usage 1.00
block group offset 438116024320 len 1073741824 used 1073721344
chunk_objectid 256 flags 1 usage 1.00
block group offset 439189766144 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 441337249792 len 1073741824 used 1073651712
chunk_objectid 256 flags 1 usage 1.00
block group offset 442410991616 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 443484733440 len 1073741824 used 1073721344
chunk_objectid 256 flags 1 usage 1.00
block group offset 445632217088 len 1073741824 used 1073373184
chunk_objectid 256 flags 1 usage 1.00
block group offset 448853442560 len 1073741824 used 1073709056
chunk_objectid 256 flags 1 usage 1.00
block group offset 449927184384 len 1028653056 used 1028599808
chunk_objectid 256 flags 1 usage 1.00
block group offset 454196985856 len 1073741824 used 1073516544
chunk_objectid 256 flags 1 usage 1.00
block group offset 455270727680 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 456344469504 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 457418211328 len 1073741824 used 1073651712
chunk_objectid 256 flags 1 usage 1.00
block group offset 458491953152 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 459565694976 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 460639436800 len 1073741824 used 1073709056
chunk_objectid 256 flags 1 usage 1.00
block group offset 461713178624 len 1073741824 used 1073725440
chunk_objectid 256 flags 1 usage 1.00
block group offset 462786920448 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 463860662272 len 1073741824 used 1073704960
chunk_objectid 256 flags 1 usage 1.00
block group offset 464934404096 len 1073741824 used 1073565696
chunk_objectid 256 flags 1 usage 1.00
block group offset 466008145920 len 1073741824 used 1073479680
chunk_objectid 256 flags 1 usage 1.00
block group offset 467081887744 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 468155629568 len 1073741824 used 1073713152
chunk_objectid 256 flags 1 usage 1.00
block group offset 469229371392 len 1073741824 used 1073700864
chunk_objectid 256 flags 1 usage 1.00
block group offset 470303113216 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 471376855040 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 472450596864 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 473524338688 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 474598080512 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 475671822336 len 1073741824 used 1073491968
chunk_objectid 256 flags 1 usage 1.00
block group offset 476745564160 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 478893047808 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 479966789632 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 481040531456 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 482114273280 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 483188015104 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 484261756928 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 485335498752 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 486409240576 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 487482982400 len 1073741824 used 1073700864
chunk_objectid 256 flags 1 usage 1.00
block group offset 488556724224 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 489630466048 len 1073741824 used 1073618944
chunk_objectid 256 flags 1 usage 1.00
block group offset 490704207872 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 491777949696 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 492851691520 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 493925433344 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 494999175168 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 496072916992 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 497146658816 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 498220400640 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 499294142464 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 500367884288 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 501441626112 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 502515367936 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 503589109760 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 504662851584 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 505736593408 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 506810335232 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 507884077056 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 508957818880 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 510031560704 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 511105302528 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 512179044352 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 513252786176 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 514326528000 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 515400269824 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 516474011648 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 517547753472 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 518621495296 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 519695237120 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 520768978944 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 521842720768 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 522916462592 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 523990204416 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 525063946240 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 526137688064 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 527211429888 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 528285171712 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 529358913536 len 1073741824 used 1073479680
chunk_objectid 256 flags 1 usage 1.00
block group offset 530432655360 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 531506397184 len 1073741824 used 1073725440
chunk_objectid 256 flags 1 usage 1.00
block group offset 532580139008 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 533653880832 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 534727622656 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 535801364480 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 536875106304 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 537948848128 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 539022589952 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 540096331776 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 541170073600 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 542243815424 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 543317557248 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 544391299072 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 545465040896 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 546538782720 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 547612524544 len 1073741824 used 1073479680
chunk_objectid 256 flags 1 usage 1.00
block group offset 548686266368 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 549760008192 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 550833750016 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 551907491840 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 552981233664 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 554054975488 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 555128717312 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 556202459136 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 558349942784 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 559423684608 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 560497426432 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 561571168256 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 562644910080 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 563718651904 len 1073741824 used 1072037888
chunk_objectid 256 flags 1 usage 1.00
block group offset 564792393728 len 1073741824 used 1073479680
chunk_objectid 256 flags 1 usage 1.00
block group offset 565866135552 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 566939877376 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 568013619200 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 569087361024 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 570161102848 len 1073741824 used 1073491968
chunk_objectid 256 flags 1 usage 1.00
block group offset 571234844672 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 572308586496 len 1073741824 used 1072955392
chunk_objectid 256 flags 1 usage 1.00
block group offset 573382328320 len 1073741824 used 1073676288
chunk_objectid 256 flags 1 usage 1.00
block group offset 574456070144 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 575529811968 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 576603553792 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 577677295616 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 578751037440 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 579824779264 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 580898521088 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 581972262912 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 583046004736 len 1073741824 used 1073639424
chunk_objectid 256 flags 1 usage 1.00
block group offset 584119746560 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 585193488384 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 586267230208 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 587340972032 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 588414713856 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 589488455680 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 590562197504 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 591635939328 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 592709681152 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 593783422976 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 594857164800 len 1073741824 used 1073537024
chunk_objectid 256 flags 1 usage 1.00
block group offset 595930906624 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 597004648448 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 598078390272 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 599152132096 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 600225873920 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 601299615744 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 602373357568 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 603447099392 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 604520841216 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 605594583040 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 606668324864 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 607742066688 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 608815808512 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 609889550336 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 610963292160 len 1073741824 used 1073479680
chunk_objectid 256 flags 1 usage 1.00
block group offset 612037033984 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 613110775808 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 614184517632 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 615258259456 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 616332001280 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 617405743104 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 618479484928 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 619553226752 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 620626968576 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 621700710400 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 622774452224 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 623848194048 len 1073741824 used 1073676288
chunk_objectid 256 flags 1 usage 1.00
block group offset 624921935872 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 625995677696 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 627069419520 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 628143161344 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 629216903168 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 630290644992 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 631364386816 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 632438128640 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 633511870464 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 634585612288 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 635659354112 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 636733095936 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 637806837760 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 638880579584 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 639954321408 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 641028063232 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 642101805056 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 643175546880 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 644249288704 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 645323030528 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 646396772352 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 647470514176 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 648544256000 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 649617997824 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 650691739648 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 651765481472 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 652839223296 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 653912965120 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 654986706944 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 656060448768 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 657134190592 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 658207932416 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 659281674240 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 660355416064 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 661429157888 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 662502899712 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 663576641536 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 664650383360 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 665724125184 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 666797867008 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 667871608832 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 668945350656 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 670019092480 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 671092834304 len 1073741824 used 1071968256
chunk_objectid 256 flags 1 usage 1.00
block group offset 672166576128 len 1073741824 used 1058471936
chunk_objectid 256 flags 1 usage 0.99
block group offset 673240317952 len 1073741824 used 1065099264
chunk_objectid 256 flags 1 usage 0.99
block group offset 674314059776 len 1073741824 used 1064210432
chunk_objectid 256 flags 1 usage 0.99
block group offset 675387801600 len 1073741824 used 1058979840
chunk_objectid 256 flags 1 usage 0.99
block group offset 676461543424 len 1073741824 used 1052667904
chunk_objectid 256 flags 1 usage 0.98
block group offset 677535285248 len 1073741824 used 333135872
chunk_objectid 256 flags 1 usage 0.31
block group offset 678609027072 len 1073741824 used 218992640
chunk_objectid 256 flags 1 usage 0.20
block group offset 679682768896 len 1073741824 used 1010180096
chunk_objectid 256 flags 1 usage 0.94
block group offset 680756510720 len 1073741824 used 968945664
chunk_objectid 256 flags 1 usage 0.90
block group offset 681830252544 len 1073741824 used 523280384
chunk_objectid 256 flags 1 usage 0.49
block group offset 682903994368 len 1073741824 used 1069355008
chunk_objectid 256 flags 1 usage 1.00
block group offset 683977736192 len 1073741824 used 1073135616
chunk_objectid 256 flags 1 usage 1.00
block group offset 685051478016 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 686125219840 len 1073741824 used 169594880
chunk_objectid 256 flags 1 usage 0.16
block group offset 687198961664 len 1073741824 used 56483840
chunk_objectid 256 flags 1 usage 0.05
block group offset 688272703488 len 1073741824 used 819478528
chunk_objectid 256 flags 1 usage 0.76
block group offset 689883316224 len 1073741824 used 925794304
chunk_objectid 256 flags 1 usage 0.86
block group offset 690957058048 len 1073741824 used 1032155136
chunk_objectid 256 flags 1 usage 0.96
block group offset 692030799872 len 1073741824 used 1073713152
chunk_objectid 256 flags 1 usage 1.00
block group offset 693104541696 len 1073741824 used 1073192960
chunk_objectid 256 flags 1 usage 1.00
block group offset 694178283520 len 1073741824 used 1073217536
chunk_objectid 256 flags 1 usage 1.00
block group offset 695252025344 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 696325767168 len 1073741824 used 1069629440
chunk_objectid 256 flags 1 usage 1.00
block group offset 697399508992 len 1073741824 used 1073315840
chunk_objectid 256 flags 1 usage 1.00
block group offset 698473250816 len 1073741824 used 1073680384
chunk_objectid 256 flags 1 usage 1.00
block group offset 699546992640 len 1073741824 used 1072533504
chunk_objectid 256 flags 1 usage 1.00
block group offset 700620734464 len 1073741824 used 1073201152
chunk_objectid 256 flags 1 usage 1.00
block group offset 701694476288 len 1073741824 used 1072660480
chunk_objectid 256 flags 1 usage 1.00
block group offset 702768218112 len 1073741824 used 1052811264
chunk_objectid 256 flags 1 usage 0.98
block group offset 703841959936 len 1073741824 used 1050193920
chunk_objectid 256 flags 1 usage 0.98
block group offset 704915701760 len 1073741824 used 902115328
chunk_objectid 256 flags 1 usage 0.84
block group offset 705989443584 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 707063185408 len 1073741824 used 699277312
chunk_objectid 256 flags 1 usage 0.65
block group offset 708136927232 len 1073741824 used 619708416
chunk_objectid 256 flags 1 usage 0.58
block group offset 709210669056 len 1073741824 used 796516352
chunk_objectid 256 flags 1 usage 0.74
block group offset 710284410880 len 1073741824 used 635936768
chunk_objectid 256 flags 1 usage 0.59
block group offset 711358152704 len 1073741824 used 981127168
chunk_objectid 256 flags 1 usage 0.91
block group offset 712431894528 len 1073741824 used 1064923136
chunk_objectid 256 flags 1 usage 0.99
block group offset 713505636352 len 1073741824 used 1029201920
chunk_objectid 256 flags 1 usage 0.96
block group offset 714579378176 len 1073741824 used 1067474944
chunk_objectid 256 flags 1 usage 0.99
block group offset 715653120000 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 716726861824 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 717800603648 len 1073741824 used 1070051328
chunk_objectid 256 flags 1 usage 1.00
block group offset 718874345472 len 1073741824 used 1064763392
chunk_objectid 256 flags 1 usage 0.99
block group offset 719948087296 len 1073741824 used 1072758784
chunk_objectid 256 flags 1 usage 1.00
block group offset 721021829120 len 1073741824 used 1069105152
chunk_objectid 256 flags 1 usage 1.00
block group offset 722095570944 len 1073741824 used 1073446912
chunk_objectid 256 flags 1 usage 1.00
block group offset 723169312768 len 1073741824 used 1070690304
chunk_objectid 256 flags 1 usage 1.00
block group offset 724243054592 len 1073741824 used 1059532800
chunk_objectid 256 flags 1 usage 0.99
block group offset 725316796416 len 1073741824 used 1068711936
chunk_objectid 256 flags 1 usage 1.00
block group offset 726390538240 len 1073741824 used 1073475584
chunk_objectid 256 flags 1 usage 1.00
block group offset 727464280064 len 1073741824 used 1073205248
chunk_objectid 256 flags 1 usage 1.00
block group offset 728538021888 len 1073741824 used 1069047808
chunk_objectid 256 flags 1 usage 1.00
block group offset 729611763712 len 1073741824 used 1069502464
chunk_objectid 256 flags 1 usage 1.00
block group offset 730685505536 len 1073741824 used 1073725440
chunk_objectid 256 flags 1 usage 1.00
block group offset 731759247360 len 1073741824 used 1070542848
chunk_objectid 256 flags 1 usage 1.00
block group offset 732832989184 len 1073741824 used 1070587904
chunk_objectid 256 flags 1 usage 1.00
block group offset 733906731008 len 1073741824 used 986300416
chunk_objectid 256 flags 1 usage 0.92
block group offset 734980472832 len 1073741824 used 1068572672
chunk_objectid 256 flags 1 usage 1.00
block group offset 736054214656 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 737127956480 len 1073741824 used 1073721344
chunk_objectid 256 flags 1 usage 1.00
block group offset 738201698304 len 1073741824 used 1073565696
chunk_objectid 256 flags 1 usage 1.00
block group offset 739275440128 len 1073741824 used 1072578560
chunk_objectid 256 flags 1 usage 1.00
block group offset 740349181952 len 1073741824 used 1072590848
chunk_objectid 256 flags 1 usage 1.00
block group offset 741422923776 len 1073741824 used 1073725440
chunk_objectid 256 flags 1 usage 1.00
block group offset 742496665600 len 1073741824 used 1073647616
chunk_objectid 256 flags 1 usage 1.00
block group offset 743570407424 len 1073741824 used 1073709056
chunk_objectid 256 flags 1 usage 1.00
block group offset 744644149248 len 1073741824 used 1073528832
chunk_objectid 256 flags 1 usage 1.00
block group offset 745717891072 len 1073741824 used 1073553408
chunk_objectid 256 flags 1 usage 1.00
block group offset 746791632896 len 1073741824 used 1073672192
chunk_objectid 256 flags 1 usage 1.00
block group offset 747865374720 len 1073741824 used 1073623040
chunk_objectid 256 flags 1 usage 1.00
block group offset 748939116544 len 1073741824 used 1073029120
chunk_objectid 256 flags 1 usage 1.00
block group offset 750012858368 len 1073741824 used 1073704960
chunk_objectid 256 flags 1 usage 1.00
block group offset 751086600192 len 1073741824 used 1073393664
chunk_objectid 256 flags 1 usage 1.00
block group offset 752160342016 len 1073741824 used 1073565696
chunk_objectid 256 flags 1 usage 1.00
block group offset 753234083840 len 1073741824 used 1073700864
chunk_objectid 256 flags 1 usage 1.00
block group offset 754307825664 len 1073741824 used 1073623040
chunk_objectid 256 flags 1 usage 1.00
block group offset 755381567488 len 1073741824 used 1073577984
chunk_objectid 256 flags 1 usage 1.00
block group offset 756455309312 len 1073741824 used 1073430528
chunk_objectid 256 flags 1 usage 1.00
block group offset 757529051136 len 1073741824 used 1073680384
chunk_objectid 256 flags 1 usage 1.00
block group offset 758602792960 len 1073741824 used 1073528832
chunk_objectid 256 flags 1 usage 1.00
block group offset 759676534784 len 1073741824 used 1073397760
chunk_objectid 256 flags 1 usage 1.00
block group offset 760750276608 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 761824018432 len 1073741824 used 1073590272
chunk_objectid 256 flags 1 usage 1.00
block group offset 762897760256 len 1073741824 used 1073561600
chunk_objectid 256 flags 1 usage 1.00
block group offset 763971502080 len 1073741824 used 1073684480
chunk_objectid 256 flags 1 usage 1.00
block group offset 765045243904 len 1073741824 used 1073647616
chunk_objectid 256 flags 1 usage 1.00
block group offset 766118985728 len 1073741824 used 1073299456
chunk_objectid 256 flags 1 usage 1.00
block group offset 767192727552 len 1073741824 used 1073573888
chunk_objectid 256 flags 1 usage 1.00
block group offset 768266469376 len 1073741824 used 1073639424
chunk_objectid 256 flags 1 usage 1.00
block group offset 769340211200 len 1073741824 used 1073426432
chunk_objectid 256 flags 1 usage 1.00
block group offset 770413953024 len 1073741824 used 1072795648
chunk_objectid 256 flags 1 usage 1.00
block group offset 771487694848 len 1073741824 used 1073041408
chunk_objectid 256 flags 1 usage 1.00
block group offset 772561436672 len 1073741824 used 1073250304
chunk_objectid 256 flags 1 usage 1.00
block group offset 773635178496 len 1073741824 used 1073692672
chunk_objectid 256 flags 1 usage 1.00
block group offset 774708920320 len 1073741824 used 1073483776
chunk_objectid 256 flags 1 usage 1.00
block group offset 775782662144 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 776856403968 len 1073741824 used 1073635328
chunk_objectid 256 flags 1 usage 1.00
block group offset 777930145792 len 1073741824 used 1073704960
chunk_objectid 256 flags 1 usage 1.00
block group offset 779003887616 len 1073741824 used 1073295360
chunk_objectid 256 flags 1 usage 1.00
block group offset 780077629440 len 1073741824 used 1073569792
chunk_objectid 256 flags 1 usage 1.00
block group offset 781151371264 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 782225113088 len 1073741824 used 1073631232
chunk_objectid 256 flags 1 usage 1.00
block group offset 783298854912 len 1073741824 used 1072775168
chunk_objectid 256 flags 1 usage 1.00
block group offset 784372596736 len 1073741824 used 1073582080
chunk_objectid 256 flags 1 usage 1.00
block group offset 785446338560 len 1073741824 used 1073537024
chunk_objectid 256 flags 1 usage 1.00
block group offset 786520080384 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 787593822208 len 1073741824 used 1073709056
chunk_objectid 256 flags 1 usage 1.00
block group offset 788667564032 len 1073741824 used 1071042560
chunk_objectid 256 flags 1 usage 1.00
block group offset 789741305856 len 1073741824 used 1073061888
chunk_objectid 256 flags 1 usage 1.00
block group offset 790815047680 len 1073741824 used 1073442816
chunk_objectid 256 flags 1 usage 1.00
block group offset 791888789504 len 1073741824 used 1073369088
chunk_objectid 256 flags 1 usage 1.00
block group offset 792962531328 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 794036273152 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 795110014976 len 1073741824 used 1073696768
chunk_objectid 256 flags 1 usage 1.00
block group offset 796183756800 len 1073741824 used 1073672192
chunk_objectid 256 flags 1 usage 1.00
block group offset 797257498624 len 1073741824 used 1073713152
chunk_objectid 256 flags 1 usage 1.00
block group offset 798331240448 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 799404982272 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 800478724096 len 1073741824 used 1073401856
chunk_objectid 256 flags 1 usage 1.00
block group offset 801552465920 len 1073741824 used 1073655808
chunk_objectid 256 flags 1 usage 1.00
block group offset 802626207744 len 1073741824 used 1073057792
chunk_objectid 256 flags 1 usage 1.00
block group offset 803699949568 len 1073741824 used 1072742400
chunk_objectid 256 flags 1 usage 1.00
block group offset 804773691392 len 1073741824 used 1073713152
chunk_objectid 256 flags 1 usage 1.00
block group offset 805847433216 len 1073741824 used 1073700864
chunk_objectid 256 flags 1 usage 1.00
block group offset 806921175040 len 1073741824 used 1065246720
chunk_objectid 256 flags 1 usage 0.99
block group offset 807994916864 len 1073741824 used 1052016640
chunk_objectid 256 flags 1 usage 0.98
block group offset 809068658688 len 1073741824 used 1072533504
chunk_objectid 256 flags 1 usage 1.00
block group offset 810142400512 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 811216142336 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 812289884160 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 813363625984 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 814437367808 len 1073741824 used 1062035456
chunk_objectid 256 flags 1 usage 0.99
block group offset 815511109632 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 816584851456 len 1073741824 used 1054617600
chunk_objectid 256 flags 1 usage 0.98
block group offset 817658593280 len 1073741824 used 1073467392
chunk_objectid 256 flags 1 usage 1.00
block group offset 818732335104 len 1073741824 used 1055498240
chunk_objectid 256 flags 1 usage 0.98
block group offset 819806076928 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 820879818752 len 1073741824 used 1065500672
chunk_objectid 256 flags 1 usage 0.99
block group offset 821953560576 len 1073741824 used 1072975872
chunk_objectid 256 flags 1 usage 1.00
block group offset 823027302400 len 1073741824 used 1052024832
chunk_objectid 256 flags 1 usage 0.98
block group offset 824101044224 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 825174786048 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 826248527872 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 827322269696 len 1073741824 used 1072889856
chunk_objectid 256 flags 1 usage 1.00
block group offset 828396011520 len 1073741824 used 1060712448
chunk_objectid 256 flags 1 usage 0.99
block group offset 829469753344 len 1073741824 used 1042903040
chunk_objectid 256 flags 1 usage 0.97
block group offset 830543495168 len 1073741824 used 65138688
chunk_objectid 256 flags 1 usage 0.06
block group offset 831617236992 len 1073741824 used 171720704
chunk_objectid 256 flags 1 usage 0.16
block group offset 832690978816 len 1073741824 used 45895680
chunk_objectid 256 flags 1 usage 0.04
block group offset 833764720640 len 1073741824 used 494104576
chunk_objectid 256 flags 1 usage 0.46
block group offset 834838462464 len 1073741824 used 1073442816
chunk_objectid 256 flags 1 usage 1.00
block group offset 835912204288 len 1073741824 used 1073586176
chunk_objectid 256 flags 1 usage 1.00
block group offset 836985946112 len 1073741824 used 90529792
chunk_objectid 256 flags 1 usage 0.08
block group offset 838059687936 len 1073741824 used 4194304
chunk_objectid 256 flags 1 usage 0.00
block group offset 839133429760 len 1073741824 used 4194304
chunk_objectid 256 flags 1 usage 0.00
block group offset 840207171584 len 1073741824 used 4194304
chunk_objectid 256 flags 1 usage 0.00
block group offset 841280913408 len 1073741824 used 882728960
chunk_objectid 256 flags 1 usage 0.82
block group offset 842354655232 len 1073741824 used 1072635904
chunk_objectid 256 flags 1 usage 1.00
block group offset 843428397056 len 1073741824 used 1073553408
chunk_objectid 256 flags 1 usage 1.00
block group offset 844502138880 len 1073741824 used 1066938368
chunk_objectid 256 flags 1 usage 0.99
block group offset 845575880704 len 1073741824 used 1031524352
chunk_objectid 256 flags 1 usage 0.96
block group offset 846649622528 len 1073741824 used 1073717248
chunk_objectid 256 flags 1 usage 1.00
block group offset 847723364352 len 1073741824 used 1049436160
chunk_objectid 256 flags 1 usage 0.98
block group offset 848797106176 len 1073741824 used 1073410048
chunk_objectid 256 flags 1 usage 1.00
block group offset 849870848000 len 1073741824 used 1068904448
chunk_objectid 256 flags 1 usage 1.00
block group offset 850944589824 len 1073741824 used 976367616
chunk_objectid 256 flags 1 usage 0.91
block group offset 852018331648 len 1073741824 used 1036746752
chunk_objectid 256 flags 1 usage 0.97
block group offset 853092073472 len 1073741824 used 1010917376
chunk_objectid 256 flags 1 usage 0.94
block group offset 854165815296 len 1073741824 used 1073385472
chunk_objectid 256 flags 1 usage 1.00
block group offset 855239557120 len 1073741824 used 696066048
chunk_objectid 256 flags 1 usage 0.65
block group offset 856313298944 len 1073741824 used 42090496
chunk_objectid 256 flags 1 usage 0.04
block group offset 857387040768 len 1073741824 used 412647424
chunk_objectid 256 flags 1 usage 0.38
block group offset 858460782592 len 1073741824 used 773308416
chunk_objectid 256 flags 1 usage 0.72
block group offset 859534524416 len 1073741824 used 954793984
chunk_objectid 256 flags 1 usage 0.89
block group offset 860608266240 len 1073741824 used 1072414720
chunk_objectid 256 flags 1 usage 1.00
block group offset 861682008064 len 1073741824 used 809218048
chunk_objectid 256 flags 1 usage 0.75
block group offset 862755749888 len 1073741824 used 1019576320
chunk_objectid 256 flags 1 usage 0.95
block group offset 863829491712 len 1073741824 used 899477504
chunk_objectid 256 flags 1 usage 0.84
block group offset 864903233536 len 1073741824 used 903045120
chunk_objectid 256 flags 1 usage 0.84
block group offset 865976975360 len 1073741824 used 994271232
chunk_objectid 256 flags 1 usage 0.93
block group offset 867050717184 len 1073741824 used 1024073728
chunk_objectid 256 flags 1 usage 0.95
block group offset 868124459008 len 1073741824 used 969252864
chunk_objectid 256 flags 1 usage 0.90
block group offset 869198200832 len 1073741824 used 1010638848
chunk_objectid 256 flags 1 usage 0.94
block group offset 870271942656 len 1073741824 used 1022263296
chunk_objectid 256 flags 1 usage 0.95
block group offset 871345684480 len 1073741824 used 784011264
chunk_objectid 256 flags 1 usage 0.73
block group offset 872419426304 len 1073741824 used 179294208
chunk_objectid 256 flags 1 usage 0.17
block group offset 873493168128 len 1073741824 used 991223808
chunk_objectid 256 flags 1 usage 0.92
block group offset 874566909952 len 1073741824 used 997720064
chunk_objectid 256 flags 1 usage 0.93
block group offset 875640651776 len 1073741824 used 951746560
chunk_objectid 256 flags 1 usage 0.89
block group offset 876714393600 len 1073741824 used 1060855808
chunk_objectid 256 flags 1 usage 0.99
block group offset 877788135424 len 1073741824 used 847339520
chunk_objectid 256 flags 1 usage 0.79
block group offset 878861877248 len 1073741824 used 1057038336
chunk_objectid 256 flags 1 usage 0.98
block group offset 879935619072 len 1073741824 used 999571456
chunk_objectid 256 flags 1 usage 0.93
block group offset 881009360896 len 1073741824 used 727867392
chunk_objectid 256 flags 1 usage 0.68
block group offset 882083102720 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 883693715456 len 1073741824 used 1052876800
chunk_objectid 256 flags 1 usage 0.98
block group offset 884767457280 len 1073741824 used 1073475584
chunk_objectid 256 flags 1 usage 1.00
block group offset 885841199104 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 886914940928 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 887988682752 len 1073741824 used 1071341568
chunk_objectid 256 flags 1 usage 1.00
block group offset 889062424576 len 1073741824 used 1073553408
chunk_objectid 256 flags 1 usage 1.00
block group offset 890136166400 len 1073741824 used 1073508352
chunk_objectid 256 flags 1 usage 1.00

block group offset 891209908224 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 892283650048 len 1073741824 used 1073737728
chunk_objectid 256 flags 1 usage 1.00
block group offset 893357391872 len 1073741824 used 1073733632
chunk_objectid 256 flags 1 usage 1.00
block group offset 894431133696 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 895504875520 len 1073741824 used 1073741824
chunk_objectid 256 flags 1 usage 1.00
block group offset 896578617344 len 1073741824 used 1073729536
chunk_objectid 256 flags 1 usage 1.00
block group offset 897652359168 len 19922944 used 19922944
chunk_objectid 256 flags 1 usage 1.00
block group offset 897672282112 len 4128768 used 4128768 chunk_objectid
256 flags 1 usage 1.00
total_free 21030674432 min_used 4128768 free_of_min_used 0
block_group_of_min_used 897672282112
balance block group (897672282112) can reduce the number of data block gr=
oup

Regards,
Martin Raiber



--------------ms030902000904030707010707
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuQwggT6MIID4qADAgECAhBuZlYKQ9u25a8FBnl/zd+MMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwOTE5MTMxNzAyWhcNMTcwOTE5MTMxNzAyWjBCMRwwGgYDVQQDDBNtYXJ0
aW5AdXJiYWNrdXAub3JnMSIwIAYJKoZIhvcNAQkBFhNtYXJ0aW5AdXJiYWNrdXAub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/FqcYQTj3z2wO8ASP8j0Jvb4AbMNgB9
iv2PLMtAMzYmuW7w2VfUcXwWgM4Fkg6Nm33VhOK+Vryd2bj+jGNhm+DmbMZCfki/NrhdcHKH
AT7i1NL1lps8X3xJ7N0eJpghht9Wx5OAUfGv18HDD3yBUzqW4x7OaGoKqM0DwyUm9O/rUU6D
ugxVONmgprREB1JyJBAV8lgYbY0EEUFS1JECuxNcJQEY+G8EpUNCsZxc8nvROyRD72Aztuy2
qQj4Rs+FzQNCplzmvXot7W0T2KAH9gKb25Q5Lv0sFQEux1stcJc6KKNea21UufblNMLApQ2Z
cSNWwDF5R+YpUFW8HiBOmwIDAQABo4IBtzCCAbMwDgYDVR0PAQH/BAQDAgSwMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBTKwa9D/4YV1XsZ
6affm7Wv4ykzdTAfBgNVHSMEGDAWgBQkgWw5Yb5JD4+3G0YrySi1J0htaDBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcw
AoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDEuY3J0MDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQxLmNybDAe
BgNVHREEFzAVgRNtYXJ0aW5AdXJiYWNrdXAub3JnMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEW
H2h0dHBzOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBADMT
EdZtz2a7sT3FDGszfzlAfmwVamtLbG5+O6NC5xc1n9AtWa7LdRPsQzgIROT/e84D+uTPAo1c
F6rEJ7oSqhgxJcAWgGN1G0KyEzSaFs+nLvfFN1LeaYQjElnmw87z6LGLvjOnfu01M0Atj+DR
DB3NyRoAn2/5yXHJKP7/mlUSXV/fiplcvP+TJbYJwrL7QDETySua89BU0oH3vtidOm8rlWzl
cZ4ug+kXzMMwjcwSIFb/P6LDZm3FMCNbg8sBt59+V5+Duk8y6aOcQ0GdGrIXMNs+oIKL5iQW
sP9+c55K9mJVl4+3J4sTcyT/L2EOXxEZY+zEhnJAds9dQJXkKfswggXiMIIDyqADAgECAhBr
p4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0x
NTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyU
GwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J
6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
CslYYWgXOMt2xlsSslxLce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j
8BWWHpChNNeTrFuhVfrOAyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4A
PXGzAgMBAAGjggFkMIIBYDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDov
L2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1o
MB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAs
MCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcN
AQELBQADggIBAIvj94fsAYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI
/+wq37fUuaMbz4g7VarKQTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuF
oTa7DmNeFe8tiK1BrL3rbA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1
JELyszXqOzjIYo4sWlC8iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quW
p9j9ou4T/OY0CXMuY+B8wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2
aNNsK5cWOojBar5c7HplX9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVD
o/ebn9c6PaM/XtDYCCaM/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk
3EV2B2NLatidKE/m7G+rB9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHN
L8F4GGp6jbAV+WL+LDeGfVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y
6S9p0xE/Ga0peVLadVHhqf9nXqKaxnr358VgfrxzUIrvOaOjMYIDzDCCA8gCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENs
aWVudCBDQQIQbmZWCkPbtuWvBQZ5f83fjDANBglghkgBZQMEAgEFAKCCAhMwGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMTIyMTQxNjM5WjAvBgkqhkiG
9w0BCQQxIgQgm4H2qCeQqcROo5TgziyK1A374kL2uzrwYxIZoe+Dd1MwbAYJKoZIhvcNAQkP
MV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmgYJKwYBBAGC
NxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRD
b20gQ2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwgZwGCyqGSIb3DQEJEAIL
MYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwDQYJKoZIhvcNAQEBBQAEggEA
qUgwvDnPxMdlDqBbh5uYNPouvnWW/Ol/4kQPuncMWTM5v2SspfEBGbf2o/CJGrydZ1Z7+3bi
utFlUzWClknXl2GJ8jVReyYkVmVRCMIy+FEucsA97c4xe9LuSy6ZNUjLQh0+cBHRadPKc4PP
GLBzHFs9UC2IOxjSkQKmEJOgzXY7zBjKUJoHQn6l31ib6QfLX2q54Onfe6P0yBJcz9mHgTwK
U4QQaE6Jj4eriLFOOcd4IcL1GxijIx7fmtSj592a+/FZV+sI6tbvXnspc96cVXbZHvdHKtjg
IeW/Yzl6hxaE1kzvuJiW7zFqKDRVfVeMve0cGkM/vi21kYo8qxK/MAAAAAAAAA==
--------------ms030902000904030707010707--
