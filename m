Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35385 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbcHYR0Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 13:26:24 -0400
Received: by mail-it0-f67.google.com with SMTP id f6so6645719ith.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 10:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSwPNAY7fXjVa=Hyeb1yVMtVmpPhUvMVbZt6Qq9P+a0LCA@mail.gmail.com>
References: <CAOE4rSwPNAY7fXjVa=Hyeb1yVMtVmpPhUvMVbZt6Qq9P+a0LCA@mail.gmail.com>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Thu, 25 Aug 2016 20:26:22 +0300
Message-ID: <CAOE4rSxn756hHWJB9T32__dbRNeF0aQOCvCe1738G_HHqy3+Xw@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-08-31 9:28 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
> I'm getting kernel crash and complete system lockup when trying to access
> journal on two disk btrfs filesystem with data/metadata as RAID1.


I kept those drives untouched and now I tried again with Linux 4.7.1
and accessing that file it didn't crashed but shows Input/output error

$ btrfs check --repair --check-data-csum  /dev/vda
enabling repair mode
Checking filesystem on /dev/vda
UUID: 247e6249-6de1-45cb-9dd0-fa8a654234bf
checking extents
Incorrect local backref count on 99753574400 root 261 owner 523015
offset 4063232 found 2 wanted 4 back 0xf1bd3c0
Incorrect global backref count on 99753574400 found 2 wanted 4
backpointer mismatch on [99753574400 8192]
repair deleting extent record: key 99753574400 168 8192
adding new data backref on 99753574400 root 261 owner 523015 offset
4063232 found 2
Incorrect local backref count on 99781627904 root 261 owner 164282
offset 41943040 found 2 wanted 3 back 0xfd4ffb0
Incorrect global backref count on 99781627904 found 2 wanted 3
backpointer mismatch on [99781627904 8388608]
repair deleting extent record: key 99781627904 168 8388608
adding new data backref on 99781627904 root 261 owner 164282 offset
41943040 found 2
Incorrect local backref count on 100102516736 root 261 owner 14518
offset 0 found 2 wanted 5 back 0x108af290
Incorrect global backref count on 100102516736 found 2 wanted 5
backpointer mismatch on [100102516736 12288]
repair deleting extent record: key 100102516736 168 12288
adding new data backref on 100102516736 root 261 owner 14518 offset 0 found 2
Incorrect local backref count on 100105658368 root 261 owner 14518
offset 131072 found 2 wanted 5 back 0x16cefb10
Incorrect global backref count on 100105658368 found 2 wanted 5
backpointer mismatch on [100105658368 12288]
repair deleting extent record: key 100105658368 168 12288
adding new data backref on 100105658368 root 261 owner 14518 offset
131072 found 2
Incorrect local backref count on 100107464704 root 261 owner 14518
offset 393216 found 2 wanted 3 back 0x1546b4a0
Incorrect global backref count on 100107464704 found 2 wanted 3
backpointer mismatch on [100107464704 12288]
repair deleting extent record: key 100107464704 168 12288
adding new data backref on 100107464704 root 261 owner 14518 offset
393216 found 2
Incorrect local backref count on 101671235584 root 261 owner 14518
offset 524288 found 2 wanted 3 back 0xfd77910
Incorrect global backref count on 101671235584 found 2 wanted 3
backpointer mismatch on [101671235584 12288]
repair deleting extent record: key 101671235584 168 12288
adding new data backref on 101671235584 root 261 owner 14518 offset
524288 found 2
Incorrect local backref count on 101671481344 root 261 owner 14518
offset 786432 found 2 wanted 3 back 0xfd79a50
Incorrect global backref count on 101671481344 found 2 wanted 3
backpointer mismatch on [101671481344 12288]
repair deleting extent record: key 101671481344 168 12288
adding new data backref on 101671481344 root 261 owner 14518 offset
786432 found 2
Incorrect local backref count on 101672292352 root 261 owner 14518
offset 917504 found 2 wanted 3 back 0xfd7fbb0
Incorrect global backref count on 101672292352 found 2 wanted 3
backpointer mismatch on [101672292352 12288]
repair deleting extent record: key 101672292352 168 12288
adding new data backref on 101672292352 root 261 owner 14518 offset
917504 found 2
Incorrect local backref count on 101676888064 root 261 owner 14518
offset 1310720 found 2 wanted 5 back 0x163d3f10
Incorrect global backref count on 101676888064 found 2 wanted 5
backpointer mismatch on [101676888064 12288]
repair deleting extent record: key 101676888064 168 12288
adding new data backref on 101676888064 root 261 owner 14518 offset
1310720 found 2
Incorrect local backref count on 101676920832 root 261 owner 14518
offset 1441792 found 2 wanted 3 back 0x163d4500
Incorrect global backref count on 101676920832 found 2 wanted 3
backpointer mismatch on [101676920832 12288]
repair deleting extent record: key 101676920832 168 12288
adding new data backref on 101676920832 root 261 owner 14518 offset
1441792 found 2
Incorrect local backref count on 101677518848 root 261 owner 14518
offset 1572864 found 2 wanted 3 back 0x163d8b10
Incorrect global backref count on 101677518848 found 2 wanted 3
backpointer mismatch on [101677518848 12288]
repair deleting extent record: key 101677518848 168 12288
adding new data backref on 101677518848 root 261 owner 14518 offset
1572864 found 2
Incorrect local backref count on 101677531136 root 261 owner 14518
offset 1703936 found 2 wanted 6 back 0x163d8c40
Incorrect global backref count on 101677531136 found 2 wanted 6
backpointer mismatch on [101677531136 12288]
repair deleting extent record: key 101677531136 168 12288
adding new data backref on 101677531136 root 261 owner 14518 offset
1703936 found 2
Incorrect local backref count on 101677596672 root 261 owner 14518
offset 1835008 found 2 wanted 3 back 0x163d9820
Incorrect global backref count on 101677596672 found 2 wanted 3
backpointer mismatch on [101677596672 12288]
repair deleting extent record: key 101677596672 168 12288
adding new data backref on 101677596672 root 261 owner 14518 offset
1835008 found 2
Incorrect local backref count on 101677928448 root 261 owner 14518
offset 2097152 found 2 wanted 4 back 0x163db310
Incorrect global backref count on 101677928448 found 2 wanted 4
backpointer mismatch on [101677928448 12288]
repair deleting extent record: key 101677928448 168 12288
adding new data backref on 101677928448 root 261 owner 14518 offset
2097152 found 2
Incorrect local backref count on 101677953024 root 261 owner 14518
offset 2359296 found 2 wanted 4 back 0x163db570
Incorrect global backref count on 101677953024 found 2 wanted 4
backpointer mismatch on [101677953024 12288]
repair deleting extent record: key 101677953024 168 12288
adding new data backref on 101677953024 root 261 owner 14518 offset
2359296 found 2
Incorrect local backref count on 101681164288 root 261 owner 14518
offset 2621440 found 2 wanted 4 back 0x163eb200
Incorrect global backref count on 101681164288 found 2 wanted 4
backpointer mismatch on [101681164288 12288]
repair deleting extent record: key 101681164288 168 12288
adding new data backref on 101681164288 root 261 owner 14518 offset
2621440 found 2
Incorrect local backref count on 101682548736 root 261 owner 14518
offset 3276800 found 2 wanted 3 back 0x163f0fd0
Incorrect global backref count on 101682548736 found 2 wanted 3
backpointer mismatch on [101682548736 12288]
repair deleting extent record: key 101682548736 168 12288
adding new data backref on 101682548736 root 261 owner 14518 offset
3276800 found 2
Incorrect local backref count on 101682655232 root 261 owner 14518
offset 3407872 found 2 wanted 4 back 0x163f1f40
Incorrect global backref count on 101682655232 found 2 wanted 4
backpointer mismatch on [101682655232 12288]
repair deleting extent record: key 101682655232 168 12288
adding new data backref on 101682655232 root 261 owner 14518 offset
3407872 found 2
Incorrect local backref count on 101682667520 root 261 owner 14518
offset 3538944 found 2 wanted 4 back 0x163f2070
Incorrect global backref count on 101682667520 found 2 wanted 4
backpointer mismatch on [101682667520 12288]
repair deleting extent record: key 101682667520 168 12288
adding new data backref on 101682667520 root 261 owner 14518 offset
3538944 found 2
Incorrect local backref count on 101683253248 root 261 owner 14518
offset 3670016 found 2 wanted 6 back 0x163f68e0
Incorrect global backref count on 101683253248 found 2 wanted 6
backpointer mismatch on [101683253248 32768]
repair deleting extent record: key 101683253248 168 32768
adding new data backref on 101683253248 root 261 owner 14518 offset
3670016 found 2
Incorrect local backref count on 101759348736 root 261 owner 14518
offset 13893632 found 2 wanted 3 back 0x16965c80
Incorrect global backref count on 101759348736 found 2 wanted 3
backpointer mismatch on [101759348736 28672]
repair deleting extent record: key 101759348736 168 28672
adding new data backref on 101759348736 root 261 owner 14518 offset
13893632 found 2
Incorrect local backref count on 102060027904 root 261 owner 571175
offset 262144 found 2 wanted 8 back 0x15cc8c70
Incorrect global backref count on 102060027904 found 2 wanted 8
backpointer mismatch on [102060027904 16384]
repair deleting extent record: key 102060027904 168 16384
adding new data backref on 102060027904 root 261 owner 571175 offset
262144 found 2
Incorrect local backref count on 102242910208 root 261 owner 571175
offset 393216 found 2 wanted 6 back 0x15d95500
Incorrect global backref count on 102242910208 found 2 wanted 6
backpointer mismatch on [102242910208 16384]
repair deleting extent record: key 102242910208 168 16384
adding new data backref on 102242910208 root 261 owner 571175 offset
393216 found 2
Incorrect local backref count on 105077051392 root 261 owner 571175
offset 1179648 found 2 wanted 5 back 0xf1d5680
Incorrect global backref count on 105077051392 found 2 wanted 5
backpointer mismatch on [105077051392 16384]
repair deleting extent record: key 105077051392 168 16384
adding new data backref on 105077051392 root 261 owner 571175 offset
1179648 found 2
Incorrect local backref count on 105079566336 root 261 owner 571175
offset 1310720 found 2 wanted 5 back 0xf1de700
Incorrect global backref count on 105079566336 found 2 wanted 5
backpointer mismatch on [105079566336 16384]
repair deleting extent record: key 105079566336 168 16384
adding new data backref on 105079566336 root 261 owner 571175 offset
1310720 found 2
Incorrect local backref count on 105129340928 root 261 owner 571175
offset 2752512 found 2 wanted 7 back 0xf64f090
Incorrect global backref count on 105129340928 found 2 wanted 7
backpointer mismatch on [105129340928 16384]
repair deleting extent record: key 105129340928 168 16384
adding new data backref on 105129340928 root 261 owner 571175 offset
2752512 found 2
Incorrect local backref count on 105617584128 root 261 owner 164282
offset 50331648 found 2 wanted 4 back 0xf032020
Incorrect global backref count on 105617584128 found 2 wanted 4
backpointer mismatch on [105617584128 8388608]
repair deleting extent record: key 105617584128 168 8388608
adding new data backref on 105617584128 root 261 owner 164282 offset
50331648 found 2
Incorrect local backref count on 105650286592 root 261 owner 571175
offset 11665408 found 2 wanted 3 back 0xf21f3c0
Incorrect global backref count on 105650286592 found 2 wanted 3
backpointer mismatch on [105650286592 45056]
repair deleting extent record: key 105650286592 168 45056
adding new data backref on 105650286592 root 261 owner 571175 offset
11665408 found 2
Incorrect local backref count on 105709547520 root 261 owner 571175
offset 21102592 found 2 wanted 4 back 0xf40d6f0
Incorrect global backref count on 105709547520 found 2 wanted 4
backpointer mismatch on [105709547520 36864]
repair deleting extent record: key 105709547520 168 36864
adding new data backref on 105709547520 root 261 owner 571175 offset
21102592 found 2
Incorrect local backref count on 105730441216 root 261 owner 571175
offset 19005440 found 2 wanted 5 back 0xe709940
Incorrect global backref count on 105730441216 found 2 wanted 5
backpointer mismatch on [105730441216 45056]
repair deleting extent record: key 105730441216 168 45056
adding new data backref on 105730441216 root 261 owner 571175 offset
19005440 found 2
Incorrect local backref count on 106138812416 root 261 owner 571175
offset 19136512 found 2 wanted 4 back 0xd8fa8e0
Incorrect global backref count on 106138812416 found 2 wanted 4
backpointer mismatch on [106138812416 49152]
repair deleting extent record: key 106138812416 168 49152
adding new data backref on 106138812416 root 261 owner 571175 offset
19136512 found 2
Incorrect local backref count on 106179354624 root 261 owner 571175
offset 4063232 found 2 wanted 3 back 0xd8d7010
Incorrect global backref count on 106179354624 found 2 wanted 3
backpointer mismatch on [106179354624 49152]
repair deleting extent record: key 106179354624 168 49152
adding new data backref on 106179354624 root 261 owner 571175 offset
4063232 found 2
Incorrect local backref count on 106212712448 root 261 owner 164282
offset 100663296 found 2 wanted 5 back 0x1009a8b0
Incorrect global backref count on 106212712448 found 2 wanted 5
backpointer mismatch on [106212712448 8388608]
repair deleting extent record: key 106212712448 168 8388608
adding new data backref on 106212712448 root 261 owner 164282 offset
100663296 found 2
Incorrect local backref count on 106577088512 root 261 owner 571175
offset 17301504 found 2 wanted 3 back 0x100bcb60
Incorrect global backref count on 106577088512 found 2 wanted 3
backpointer mismatch on [106577088512 40960]
repair deleting extent record: key 106577088512 168 40960
adding new data backref on 106577088512 root 261 owner 571175 offset
17301504 found 2
Incorrect local backref count on 106639605760 root 261 owner 571175
offset 12451840 found 2 wanted 3 back 0xfab5e50
Incorrect global backref count on 106639605760 found 2 wanted 3
backpointer mismatch on [106639605760 45056]
repair deleting extent record: key 106639605760 168 45056
adding new data backref on 106639605760 root 261 owner 571175 offset
12451840 found 2
Incorrect local backref count on 106806984704 root 261 owner 164282
offset 58720256 found 2 wanted 4 back 0xebb3330
Incorrect global backref count on 106806984704 found 2 wanted 4
backpointer mismatch on [106806984704 8388608]
repair deleting extent record: key 106806984704 168 8388608
adding new data backref on 106806984704 root 261 owner 164282 offset
58720256 found 2
Incorrect local backref count on 107528482816 root 267 owner 9519
offset 0 found 2 wanted 8 back 0xe0f06d0
Incorrect global backref count on 107528482816 found 2 wanted 8
backpointer mismatch on [107528482816 36864]
repair deleting extent record: key 107528482816 168 36864
adding new data backref on 107528482816 root 267 owner 9519 offset 0 found 2
Incorrect local backref count on 107892748288 root 261 owner 23905
offset 4096 found 2 wanted 3 back 0x14723490
Incorrect global backref count on 107892748288 found 2 wanted 3
backpointer mismatch on [107892748288 8384512]
repair deleting extent record: key 107892748288 168 8384512
adding new data backref on 107892748288 root 261 owner 23905 offset 4096 found 2
Incorrect local backref count on 108217237504 root 261 owner 23416
offset 4096 found 2 wanted 3 back 0x16b51ab0
Incorrect global backref count on 108217237504 found 2 wanted 3
backpointer mismatch on [108217237504 8384512]
repair deleting extent record: key 108217237504 168 8384512
adding new data backref on 108217237504 root 261 owner 23416 offset 4096 found 2
Incorrect local backref count on 109818101760 root 261 owner 70632
offset 58720256 found 2 wanted 8 back 0x14fc9ea0
Incorrect global backref count on 109818101760 found 2 wanted 8
backpointer mismatch on [109818101760 8388608]
repair deleting extent record: key 109818101760 168 8388608
adding new data backref on 109818101760 root 261 owner 70632 offset
58720256 found 2
Incorrect local backref count on 109830193152 root 261 owner 70632
offset 67108864 found 2 wanted 4 back 0x14fced00
Incorrect global backref count on 109830193152 found 2 wanted 4
backpointer mismatch on [109830193152 8388608]
repair deleting extent record: key 109830193152 168 8388608
adding new data backref on 109830193152 root 261 owner 70632 offset
67108864 found 2
Incorrect local backref count on 114876686336 root 261 owner 571175
offset 5636096 found 2 wanted 5 back 0x2667c70
Incorrect global backref count on 114876686336 found 2 wanted 5
backpointer mismatch on [114876686336 53248]
repair deleting extent record: key 114876686336 168 53248
adding new data backref on 114876686336 root 261 owner 571175 offset
5636096 found 2
Incorrect local backref count on 115684376576 root 261 owner 571175
offset 6160384 found 2 wanted 3 back 0x1463ca80
Incorrect global backref count on 115684376576 found 2 wanted 3
backpointer mismatch on [115684376576 49152]
repair deleting extent record: key 115684376576 168 49152
adding new data backref on 115684376576 root 261 owner 571175 offset
6160384 found 2
Incorrect local backref count on 115886948352 root 261 owner 571175
offset 9830400 found 2 wanted 3 back 0xcf81970
Incorrect global backref count on 115886948352 found 2 wanted 3
backpointer mismatch on [115886948352 53248]
repair deleting extent record: key 115886948352 168 53248
adding new data backref on 115886948352 root 261 owner 571175 offset
9830400 found 2
Incorrect local backref count on 116005281792 root 261 owner 103261
offset 8388608 found 2 wanted 6 back 0x14f7b700
Incorrect global backref count on 116005281792 found 2 wanted 6
backpointer mismatch on [116005281792 8388608]
repair deleting extent record: key 116005281792 168 8388608
adding new data backref on 116005281792 root 261 owner 103261 offset
8388608 found 2
Incorrect local backref count on 116106932224 root 261 owner 99219
offset 8388608 found 2 wanted 3 back 0x14650d80
Incorrect global backref count on 116106932224 found 2 wanted 3
backpointer mismatch on [116106932224 8388608]
repair deleting extent record: key 116106932224 168 8388608
adding new data backref on 116106932224 root 261 owner 99219 offset
8388608 found 2
Incorrect local backref count on 118884319232 root 261 owner 50375
offset 4096 found 2 wanted 3 back 0x1490e320
Incorrect global backref count on 118884319232 found 2 wanted 3
backpointer mismatch on [118884319232 8384512]
repair deleting extent record: key 118884319232 168 8384512
adding new data backref on 118884319232 root 261 owner 50375 offset 4096 found 2
Incorrect local backref count on 118915481600 root 261 owner 50456
offset 8388608 found 2 wanted 9 back 0x151fbc90
Incorrect global backref count on 118915481600 found 2 wanted 9
backpointer mismatch on [118915481600 8388608]
repair deleting extent record: key 118915481600 168 8388608
adding new data backref on 118915481600 root 261 owner 50456 offset
8388608 found 2
Incorrect local backref count on 118952853504 root 261 owner 50562
offset 16777216 found 2 wanted 6 back 0x151ff330
Incorrect global backref count on 118952853504 found 2 wanted 6
backpointer mismatch on [118952853504 8388608]
repair deleting extent record: key 118952853504 168 8388608
adding new data backref on 118952853504 root 261 owner 50562 offset
16777216 found 2
Incorrect local backref count on 118961242112 root 261 owner 50691
offset 4096 found 2 wanted 3 back 0x151ff460
Incorrect global backref count on 118961242112 found 2 wanted 3
backpointer mismatch on [118961242112 8384512]
repair deleting extent record: key 118961242112 168 8384512
adding new data backref on 118961242112 root 261 owner 50691 offset 4096 found 2
Incorrect local backref count on 119117934592 root 261 owner 50755
offset 16777216 found 2 wanted 12 back 0x15218430
Incorrect global backref count on 119117934592 found 2 wanted 12
backpointer mismatch on [119117934592 8388608]
repair deleting extent record: key 119117934592 168 8388608
adding new data backref on 119117934592 root 261 owner 50755 offset
16777216 found 2
Incorrect local backref count on 119136927744 root 261 owner 50755
offset 25165824 found 2 wanted 6 back 0x1521aa30
Incorrect global backref count on 119136927744 found 2 wanted 6
backpointer mismatch on [119136927744 8388608]
repair deleting extent record: key 119136927744 168 8388608
adding new data backref on 119136927744 root 261 owner 50755 offset
25165824 found 2
Incorrect local backref count on 119153704960 root 261 owner 50755
offset 33554432 found 2 wanted 4 back 0x1521ac90
Incorrect global backref count on 119153704960 found 2 wanted 4
backpointer mismatch on [119153704960 8388608]
repair deleting extent record: key 119153704960 168 8388608
adding new data backref on 119153704960 root 261 owner 50755 offset
33554432 found 2
Incorrect local backref count on 119175401472 root 261 owner 29151
offset 75497472 found 2 wanted 8 back 0xf84d2b0
Incorrect global backref count on 119175401472 found 2 wanted 8
backpointer mismatch on [119175401472 8388608]
repair deleting extent record: key 119175401472 168 8388608
adding new data backref on 119175401472 root 261 owner 29151 offset
75497472 found 2
Incorrect local backref count on 119183790080 root 261 owner 29151
offset 83886080 found 2 wanted 7 back 0xf84d3e0
Incorrect global backref count on 119183790080 found 2 wanted 7
backpointer mismatch on [119183790080 8388608]
repair deleting extent record: key 119183790080 168 8388608
adding new data backref on 119183790080 root 261 owner 29151 offset
83886080 found 2
Incorrect local backref count on 119192178688 root 261 owner 29151
offset 92274688 found 2 wanted 4 back 0xf84d510
Incorrect global backref count on 119192178688 found 2 wanted 4
backpointer mismatch on [119192178688 8388608]
repair deleting extent record: key 119192178688 168 8388608
adding new data backref on 119192178688 root 261 owner 29151 offset
92274688 found 2
Incorrect local backref count on 121346105344 root 261 owner 103265
offset 25165824 found 2 wanted 4 back 0x14970aa0
Incorrect global backref count on 121346105344 found 2 wanted 4
backpointer mismatch on [121346105344 8388608]
repair deleting extent record: key 121346105344 168 8388608
adding new data backref on 121346105344 root 261 owner 103265 offset
25165824 found 2
Incorrect local backref count on 121400180736 root 266 owner 121703
offset 2101248 found 2 wanted 3 back 0x15243040
Incorrect global backref count on 121400180736 found 2 wanted 3
backpointer mismatch on [121400180736 737280]
repair deleting extent record: key 121400180736 168 737280
adding new data backref on 121400180736 root 266 owner 121703 offset
2101248 found 2
Incorrect local backref count on 121405538304 root 266 owner 121703
offset 8732672 found 2 wanted 4 back 0x152439c0
Incorrect global backref count on 121405538304 found 2 wanted 4
backpointer mismatch on [121405538304 2871296]
repair deleting extent record: key 121405538304 168 2871296
adding new data backref on 121405538304 root 266 owner 121703 offset
8732672 found 2
Incorrect local backref count on 121453096960 root 266 owner 121703
offset 10125312 found 2 wanted 3 back 0x143ece30
Incorrect global backref count on 121453096960 found 2 wanted 3
backpointer mismatch on [121453096960 1478656]
repair deleting extent record: key 121453096960 168 1478656
adding new data backref on 121453096960 root 266 owner 121703 offset
10125312 found 2
Incorrect local backref count on 121457029120 root 266 owner 121703
offset 3899392 found 2 wanted 7 back 0x1524e330
Incorrect global backref count on 121457029120 found 2 wanted 7
backpointer mismatch on [121457029120 2297856]
repair deleting extent record: key 121457029120 168 2297856
adding new data backref on 121457029120 root 266 owner 121703 offset
3899392 found 2
Incorrect local backref count on 121471447040 root 266 owner 121703
offset 2101248 found 2 wanted 4 back 0x152578d0
Incorrect global backref count on 121471447040 found 2 wanted 4
backpointer mismatch on [121471447040 9420800]
repair deleting extent record: key 121471447040 168 9420800
adding new data backref on 121471447040 root 266 owner 121703 offset
2101248 found 2
Incorrect local backref count on 121496403968 root 266 owner 121669
offset 2101248 found 2 wanted 8 back 0x15ab3b00
Incorrect global backref count on 121496403968 found 2 wanted 8
backpointer mismatch on [121496403968 13680640]
repair deleting extent record: key 121496403968 168 13680640
adding new data backref on 121496403968 root 266 owner 121669 offset
2101248 found 2
Incorrect local backref count on 121511731200 root 266 owner 121669
offset 4063232 found 2 wanted 4 back 0x15ab3e90
Incorrect global backref count on 121511731200 found 2 wanted 4
backpointer mismatch on [121511731200 2297856]
repair deleting extent record: key 121511731200 168 2297856
adding new data backref on 121511731200 root 266 owner 121669 offset
4063232 found 2
Incorrect local backref count on 121515352064 root 266 owner 121669
offset 8077312 found 2 wanted 5 back 0x15ab4350
Incorrect global backref count on 121515352064 found 2 wanted 5
backpointer mismatch on [121515352064 1478656]
repair deleting extent record: key 121515352064 168 1478656
adding new data backref on 121515352064 root 266 owner 121669 offset
8077312 found 2
Incorrect local backref count on 121517080576 root 266 owner 121669
offset 9961472 found 2 wanted 3 back 0x15ab45b0
Incorrect global backref count on 121517080576 found 2 wanted 3
backpointer mismatch on [121517080576 741376]
repair deleting extent record: key 121517080576 168 741376
adding new data backref on 121517080576 root 266 owner 121669 offset
9961472 found 2
Incorrect local backref count on 121517907968 root 266 owner 121669
offset 10944512 found 2 wanted 3 back 0x15ab4810
Incorrect global backref count on 121517907968 found 2 wanted 3
backpointer mismatch on [121517907968 495616]
repair deleting extent record: key 121517907968 168 495616
adding new data backref on 121517907968 root 266 owner 121669 offset
10944512 found 2
Incorrect local backref count on 121519890432 root 266 owner 121669
offset 13402112 found 2 wanted 4 back 0x15ab4f30
Incorrect global backref count on 121519890432 found 2 wanted 4
backpointer mismatch on [121519890432 1970176]
repair deleting extent record: key 121519890432 168 1970176
adding new data backref on 121519890432 root 266 owner 121669 offset
13402112 found 2
Incorrect local backref count on 121570537472 root 266 owner 109253
offset 1212416 found 2 wanted 5 back 0xf730a00
Incorrect global backref count on 121570537472 found 2 wanted 5
backpointer mismatch on [121570537472 5537792]
repair deleting extent record: key 121570537472 168 5537792
adding new data backref on 121570537472 root 266 owner 109253 offset
1212416 found 2
Incorrect local backref count on 121578438656 root 266 owner 109250
offset 0 found 2 wanted 6 back 0xf7329b0
Incorrect global backref count on 121578438656 found 2 wanted 6
backpointer mismatch on [121578438656 9797632]
repair deleting extent record: key 121578438656 168 9797632
adding new data backref on 121578438656 root 266 owner 109250 offset 0 found 2
Incorrect local backref count on 122374881280 root 261 owner 164282
offset 92274688 found 2 wanted 7 back 0xda989a0
Incorrect global backref count on 122374881280 found 2 wanted 7
backpointer mismatch on [122374881280 8388608]
repair deleting extent record: key 122374881280 168 8388608
adding new data backref on 122374881280 root 261 owner 164282 offset
92274688 found 2
Incorrect local backref count on 122422677504 root 261 owner 379351
offset 4096 found 2 wanted 4 back 0xed172d0
Incorrect global backref count on 122422677504 found 2 wanted 4
backpointer mismatch on [122422677504 8384512]
repair deleting extent record: key 122422677504 168 8384512
adding new data backref on 122422677504 root 261 owner 379351 offset
4096 found 2
Incorrect local backref count on 122431062016 root 261 owner 379502
offset 4096 found 2 wanted 3 back 0xed17400
Incorrect global backref count on 122431062016 found 2 wanted 3
backpointer mismatch on [122431062016 8384512]
repair deleting extent record: key 122431062016 168 8384512
adding new data backref on 122431062016 root 261 owner 379502 offset
4096 found 2
Incorrect local backref count on 122445803520 root 261 owner 379569
offset 4096 found 2 wanted 3 back 0xed1f640
Incorrect global backref count on 122445803520 found 2 wanted 3
backpointer mismatch on [122445803520 8384512]
repair deleting extent record: key 122445803520 168 8384512
adding new data backref on 122445803520 root 261 owner 379569 offset
4096 found 2
Incorrect local backref count on 122454188032 root 261 owner 379642
offset 4096 found 2 wanted 3 back 0xed1f770
Incorrect global backref count on 122454188032 found 2 wanted 3
backpointer mismatch on [122454188032 8384512]
repair deleting extent record: key 122454188032 168 8384512
adding new data backref on 122454188032 root 261 owner 379642 offset
4096 found 2
Incorrect local backref count on 122690605056 root 261 owner 164282
offset 109051904 found 2 wanted 7 back 0x11b8b950
Incorrect global backref count on 122690605056 found 2 wanted 7
backpointer mismatch on [122690605056 8388608]
repair deleting extent record: key 122690605056 168 8388608
adding new data backref on 122690605056 root 261 owner 164282 offset
109051904 found 2
Incorrect local backref count on 123219030016 root 266 owner 105119
offset 0 found 2 wanted 4 back 0x128f75b0
Incorrect global backref count on 123219030016 found 2 wanted 4
backpointer mismatch on [123219030016 5595136]
repair deleting extent record: key 123219030016 168 5595136
adding new data backref on 123219030016 root 266 owner 105119 offset 0 found 2
Incorrect local backref count on 123312148480 root 266 owner 109250
offset 589824 found 2 wanted 3 back 0x12342740
Incorrect global backref count on 123312148480 found 2 wanted 3
backpointer mismatch on [123312148480 1900544]
repair deleting extent record: key 123312148480 168 1900544
adding new data backref on 123312148480 root 266 owner 109250 offset
589824 found 2
Incorrect local backref count on 123355807744 root 266 owner 109253
offset 15859712 found 2 wanted 4 back 0x12550ed0
Incorrect global backref count on 123355807744 found 2 wanted 4
backpointer mismatch on [123355807744 1835008]
repair deleting extent record: key 123355807744 168 1835008
adding new data backref on 123355807744 root 266 owner 109253 offset
15859712 found 2
Incorrect local backref count on 124800430080 root 261 owner 164282
offset 83886080 found 2 wanted 8 back 0xed5a070
Incorrect global backref count on 124800430080 found 2 wanted 8
backpointer mismatch on [124800430080 8388608]
repair deleting extent record: key 124800430080 168 8388608
adding new data backref on 124800430080 root 261 owner 164282 offset
83886080 found 2
Incorrect local backref count on 125447946240 root 261 owner 443492
offset 4096 found 2 wanted 3 back 0xd4a2240
Incorrect global backref count on 125447946240 found 2 wanted 3
backpointer mismatch on [125447946240 8384512]
repair deleting extent record: key 125447946240 168 8384512
adding new data backref on 125447946240 root 261 owner 443492 offset
4096 found 2
Incorrect local backref count on 299742502912 root 261 owner 103265
offset 8388608 found 2 wanted 4 back 0x109889c0
Incorrect global backref count on 299742502912 found 2 wanted 4
backpointer mismatch on [299742502912 8388608]
repair deleting extent record: key 299742502912 168 8388608
adding new data backref on 299742502912 root 261 owner 103265 offset
8388608 found 2
Incorrect local backref count on 358968762368 root 261 owner 164282
offset 33554432 found 2 wanted 5 back 0xfb62250
Incorrect global backref count on 358968762368 found 2 wanted 5
backpointer mismatch on [358968762368 8388608]
repair deleting extent record: key 358968762368 168 8388608
adding new data backref on 358968762368 root 261 owner 164282 offset
33554432 found 2
Incorrect local backref count on 383473442816 root 261 owner 164282
offset 67108864 found 2 wanted 3 back 0xab44eb0
Incorrect global backref count on 383473442816 found 2 wanted 3
backpointer mismatch on [383473442816 8388608]
repair deleting extent record: key 383473442816 168 8388608
adding new data backref on 383473442816 root 261 owner 164282 offset
67108864 found 2
Incorrect local backref count on 384264065024 root 261 owner 475981
offset 8388608 found 2 wanted 3 back 0x9391900
Incorrect global backref count on 384264065024 found 2 wanted 3
backpointer mismatch on [384264065024 8388608]
repair deleting extent record: key 384264065024 168 8388608
adding new data backref on 384264065024 root 261 owner 475981 offset
8388608 found 2
Incorrect local backref count on 384724803584 root 261 owner 443649
offset 4096 found 2 wanted 3 back 0x96f3d50
Incorrect global backref count on 384724803584 found 2 wanted 3
backpointer mismatch on [384724803584 8384512]
repair deleting extent record: key 384724803584 168 8384512
adding new data backref on 384724803584 root 261 owner 443649 offset
4096 found 2
Incorrect local backref count on 387144613888 root 261 owner 443727
offset 8388608 found 2 wanted 5 back 0x7277040
Incorrect global backref count on 387144613888 found 2 wanted 5
backpointer mismatch on [387144613888 8388608]
repair deleting extent record: key 387144613888 168 8388608
adding new data backref on 387144613888 root 261 owner 443727 offset
8388608 found 2
Incorrect local backref count on 387177525248 root 267 owner 83843
offset 32768 found 2 wanted 4 back 0x180e8fb0
Incorrect global backref count on 387177525248 found 2 wanted 4
backpointer mismatch on [387177525248 10452992]
repair deleting extent record: key 387177525248 168 10452992
adding new data backref on 387177525248 root 267 owner 83843 offset
32768 found 2
Incorrect local backref count on 533698461696 root 261 owner 103265
offset 16777216 found 2 wanted 4 back 0x1430a450
Incorrect global backref count on 533698461696 found 2 wanted 4
backpointer mismatch on [533698461696 8388608]
repair deleting extent record: key 533698461696 168 8388608
adding new data backref on 533698461696 root 261 owner 103265 offset
16777216 found 2
Incorrect local backref count on 617282523136 root 261 owner 523013
offset 25165824 found 2 wanted 7 back 0xa6ef9d0
Incorrect global backref count on 617282523136 found 2 wanted 7
backpointer mismatch on [617282523136 8388608]
repair deleting extent record: key 617282523136 168 8388608
adding new data backref on 617282523136 root 261 owner 523013 offset
25165824 found 2
Incorrect local backref count on 617662447616 root 261 owner 476064
offset 117440512 found 2 wanted 3 back 0x9508d40
Incorrect global backref count on 617662447616 found 2 wanted 3
backpointer mismatch on [617662447616 8388608]
repair deleting extent record: key 617662447616 168 8388608
adding new data backref on 617662447616 root 261 owner 476064 offset
117440512 found 2
Incorrect local backref count on 619055620096 root 261 owner 523013
offset 33554432 found 2 wanted 8 back 0x9367b40
Incorrect global backref count on 619055620096 found 2 wanted 8
backpointer mismatch on [619055620096 8388608]
repair deleting extent record: key 619055620096 168 8388608
adding new data backref on 619055620096 root 261 owner 523013 offset
33554432 found 2
Incorrect local backref count on 620135100416 root 267 owner 42446
offset 37355520 found 2 wanted 3 back 0x94bbb70
Incorrect global backref count on 620135100416 found 2 wanted 3
backpointer mismatch on [620135100416 2490368]
repair deleting extent record: key 620135100416 168 2490368
adding new data backref on 620135100416 root 267 owner 42446 offset
37355520 found 2
Incorrect local backref count on 620301402112 root 261 owner 476064
offset 92274688 found 2 wanted 5 back 0x27a0320
Incorrect global backref count on 620301402112 found 2 wanted 5
backpointer mismatch on [620301402112 8388608]
repair deleting extent record: key 620301402112 168 8388608
adding new data backref on 620301402112 root 261 owner 476064 offset
92274688 found 2
Incorrect local backref count on 620319731712 root 261 owner 476064
offset 125829120 found 2 wanted 9 back 0x27a1c10
Incorrect global backref count on 620319731712 found 2 wanted 9
backpointer mismatch on [620319731712 8388608]
repair deleting extent record: key 620319731712 168 8388608
adding new data backref on 620319731712 root 261 owner 476064 offset
125829120 found 2
Incorrect local backref count on 620339421184 root 261 owner 476064
offset 83886080 found 2 wanted 6 back 0x27a3760
Incorrect global backref count on 620339421184 found 2 wanted 6
backpointer mismatch on [620339421184 8388608]
repair deleting extent record: key 620339421184 168 8388608
adding new data backref on 620339421184 root 261 owner 476064 offset
83886080 found 2
Incorrect local backref count on 620405080064 root 261 owner 476064
offset 75497472 found 2 wanted 5 back 0x27b45d0
Incorrect global backref count on 620405080064 found 2 wanted 5
backpointer mismatch on [620405080064 8388608]
repair deleting extent record: key 620405080064 168 8388608
adding new data backref on 620405080064 root 261 owner 476064 offset
75497472 found 2
Incorrect local backref count on 620441411584 root 261 owner 476064
offset 109051904 found 2 wanted 4 back 0x27aa900
Incorrect global backref count on 620441411584 found 2 wanted 4
backpointer mismatch on [620441411584 8388608]
repair deleting extent record: key 620441411584 168 8388608
adding new data backref on 620441411584 root 261 owner 476064 offset
109051904 found 2
Incorrect local backref count on 620484030464 root 261 owner 523013
offset 41943040 found 2 wanted 4 back 0x27abd30
Incorrect global backref count on 620484030464 found 2 wanted 4
backpointer mismatch on [620484030464 8388608]
repair deleting extent record: key 620484030464 168 8388608
adding new data backref on 620484030464 root 261 owner 523013 offset
41943040 found 2
Incorrect local backref count on 620492419072 root 261 owner 523013
offset 50331648 found 2 wanted 6 back 0x27abe60
Incorrect global backref count on 620492419072 found 2 wanted 6
backpointer mismatch on [620492419072 8388608]
repair deleting extent record: key 620492419072 168 8388608
adding new data backref on 620492419072 root 261 owner 523013 offset
50331648 found 2
Incorrect local backref count on 620523372544 root 261 owner 476064
offset 100663296 found 2 wanted 3 back 0x27afdc0
Incorrect global backref count on 620523372544 found 2 wanted 3
backpointer mismatch on [620523372544 8388608]
repair deleting extent record: key 620523372544 168 8388608
adding new data backref on 620523372544 root 261 owner 476064 offset
100663296 found 2
Incorrect local backref count on 620629340160 root 261 owner 523013
offset 58720256 found 2 wanted 3 back 0x929cc40
Incorrect global backref count on 620629340160 found 2 wanted 3
backpointer mismatch on [620629340160 8388608]
repair deleting extent record: key 620629340160 168 8388608
adding new data backref on 620629340160 root 261 owner 523013 offset
58720256 found 2
Incorrect local backref count on 621086306304 root 267 owner 42446
offset 17563648 found 2 wanted 4 back 0x94a4ee0
Incorrect global backref count on 621086306304 found 2 wanted 4
backpointer mismatch on [621086306304 2621440]
repair deleting extent record: key 621086306304 168 2621440
adding new data backref on 621086306304 root 267 owner 42446 offset
17563648 found 2
Incorrect local backref count on 621287456768 root 267 owner 42445
offset 0 found 2 wanted 5 back 0x174b0940
Incorrect global backref count on 621287456768 found 2 wanted 5
backpointer mismatch on [621287456768 4456448]
repair deleting extent record: key 621287456768 168 4456448
adding new data backref on 621287456768 root 267 owner 42445 offset 0 found 2
Incorrect local backref count on 626338304000 root 261 owner 504481
offset 109051904 found 2 wanted 3 back 0x9b51410
Incorrect global backref count on 626338304000 found 2 wanted 3
backpointer mismatch on [626338304000 8388608]
repair deleting extent record: key 626338304000 168 8388608
adding new data backref on 626338304000 root 261 owner 504481 offset
109051904 found 2
Incorrect local backref count on 626346692608 root 261 owner 504481
offset 83886080 found 2 wanted 6 back 0x9b51540
Incorrect global backref count on 626346692608 found 2 wanted 6
backpointer mismatch on [626346692608 8388608]
repair deleting extent record: key 626346692608 168 8388608
adding new data backref on 626346692608 root 261 owner 504481 offset
83886080 found 2
Incorrect local backref count on 626769547264 root 261 owner 504481
offset 117440512 found 2 wanted 5 back 0x176bcbc0
Incorrect global backref count on 626769547264 found 2 wanted 5
backpointer mismatch on [626769547264 8388608]
repair deleting extent record: key 626769547264 168 8388608
adding new data backref on 626769547264 root 261 owner 504481 offset
117440512 found 2
Incorrect local backref count on 627077701632 root 261 owner 504481
offset 75497472 found 2 wanted 4 back 0x97dacb0
Incorrect global backref count on 627077701632 found 2 wanted 4
backpointer mismatch on [627077701632 8388608]
repair deleting extent record: key 627077701632 168 8388608
adding new data backref on 627077701632 root 261 owner 504481 offset
75497472 found 2
Incorrect local backref count on 651636572160 root 261 owner 571245
offset 8388608 found 2 wanted 4 back 0xc8d9bd0
Incorrect global backref count on 651636572160 found 2 wanted 4
backpointer mismatch on [651636572160 8388608]
repair deleting extent record: key 651636572160 168 8388608
adding new data backref on 651636572160 root 261 owner 571245 offset
8388608 found 2
Incorrect local backref count on 651727511552 root 261 owner 588700
offset 33554432 found 2 wanted 7 back 0xadfaa60
Incorrect global backref count on 651727511552 found 2 wanted 7
backpointer mismatch on [651727511552 8388608]
repair deleting extent record: key 651727511552 168 8388608
adding new data backref on 651727511552 root 261 owner 588700 offset
33554432 found 2
Incorrect local backref count on 651764072448 root 261 owner 588700
offset 16777216 found 2 wanted 3 back 0x27c7310
Incorrect global backref count on 651764072448 found 2 wanted 3
backpointer mismatch on [651764072448 8388608]
repair deleting extent record: key 651764072448 168 8388608
adding new data backref on 651764072448 root 261 owner 588700 offset
16777216 found 2
Incorrect local backref count on 651772723200 root 261 owner 588700
offset 25165824 found 2 wanted 9 back 0x27c7570
Incorrect global backref count on 651772723200 found 2 wanted 9
backpointer mismatch on [651772723200 8388608]
repair deleting extent record: key 651772723200 168 8388608
adding new data backref on 651772723200 root 261 owner 588700 offset
25165824 found 2
Incorrect local backref count on 651782610944 root 261 owner 523013
offset 67108864 found 2 wanted 7 back 0x27c7900
Incorrect global backref count on 651782610944 found 2 wanted 7
backpointer mismatch on [651782610944 8388608]
repair deleting extent record: key 651782610944 168 8388608
adding new data backref on 651782610944 root 261 owner 523013 offset
67108864 found 2
Incorrect local backref count on 651849945088 root 261 owner 523013
offset 75497472 found 2 wanted 4 back 0x27be620
Incorrect global backref count on 651849945088 found 2 wanted 4
backpointer mismatch on [651849945088 8388608]
repair deleting extent record: key 651849945088 168 8388608
adding new data backref on 651849945088 root 261 owner 523013 offset
75497472 found 2
Incorrect local backref count on 651903942656 root 268 owner 133149
offset 51486720 found 2 wanted 3 back 0x27c48b0
Incorrect global backref count on 651903942656 found 2 wanted 3
backpointer mismatch on [651903942656 1204224]
repair deleting extent record: key 651903942656 168 1204224
adding new data backref on 651903942656 root 268 owner 133149 offset
51486720 found 2
Incorrect local backref count on 651924652032 root 261 owner 588700
offset 4096 found 2 wanted 3 back 0xc7ef6d0
Incorrect global backref count on 651924652032 found 2 wanted 3
backpointer mismatch on [651924652032 8384512]
repair deleting extent record: key 651924652032 168 8384512
adding new data backref on 651924652032 root 261 owner 588700 offset
4096 found 2
Incorrect local backref count on 652023672832 root 261 owner 588700
offset 8388608 found 2 wanted 14 back 0xaa00a80
Incorrect global backref count on 652023672832 found 2 wanted 14
backpointer mismatch on [652023672832 8388608]
repair deleting extent record: key 652023672832 168 8388608
adding new data backref on 652023672832 root 261 owner 588700 offset
8388608 found 2
Incorrect local backref count on 652135686144 root 261 owner 588700
offset 41943040 found 2 wanted 23 back 0xad0bef0
Incorrect global backref count on 652135686144 found 2 wanted 23
backpointer mismatch on [652135686144 8388608]
repair deleting extent record: key 652135686144 168 8388608
adding new data backref on 652135686144 root 261 owner 588700 offset
41943040 found 2
Incorrect local backref count on 652147728384 root 261 owner 588700
offset 58720256 found 2 wanted 25 back 0xad0c280
Incorrect global backref count on 652147728384 found 2 wanted 25
backpointer mismatch on [652147728384 8388608]
repair deleting extent record: key 652147728384 168 8388608
adding new data backref on 652147728384 root 261 owner 588700 offset
58720256 found 2
Incorrect local backref count on 652163137536 root 261 owner 588700
offset 50331648 found 2 wanted 29 back 0xad0d320
Incorrect global backref count on 652163137536 found 2 wanted 29
backpointer mismatch on [652163137536 8388608]
repair deleting extent record: key 652163137536 168 8388608
adding new data backref on 652163137536 root 261 owner 588700 offset
50331648 found 2
Incorrect local backref count on 652171526144 root 268 owner 133149
offset 59981824 found 2 wanted 6 back 0xad0d450
Incorrect global backref count on 652171526144 found 2 wanted 6
backpointer mismatch on [652171526144 5685248]
repair deleting extent record: key 652171526144 168 5685248
adding new data backref on 652171526144 root 268 owner 133149 offset
59981824 found 2
Incorrect local backref count on 652182392832 root 261 owner 588700
offset 67108864 found 2 wanted 35 back 0xad0d6b0
Incorrect global backref count on 652182392832 found 2 wanted 35
backpointer mismatch on [652182392832 8388608]
repair deleting extent record: key 652182392832 168 8388608
adding new data backref on 652182392832 root 261 owner 588700 offset
67108864 found 2
Incorrect local backref count on 652218540032 root 261 owner 588700
offset 100663296 found 2 wanted 10 back 0xad10890
Incorrect global backref count on 652218540032 found 2 wanted 10
backpointer mismatch on [652218540032 8388608]
repair deleting extent record: key 652218540032 168 8388608
adding new data backref on 652218540032 root 261 owner 588700 offset
100663296 found 2
Incorrect local backref count on 655772450816 root 261 owner 588700
offset 83886080 found 2 wanted 12 back 0xc7fdd30
Incorrect global backref count on 655772450816 found 2 wanted 12
backpointer mismatch on [655772450816 8388608]
repair deleting extent record: key 655772450816 168 8388608
adding new data backref on 655772450816 root 261 owner 588700 offset
83886080 found 2
Incorrect local backref count on 655894376448 root 268 owner 94568
offset 15204352 found 2 wanted 5 back 0x12d3d20
Incorrect global backref count on 655894376448 found 2 wanted 5
backpointer mismatch on [655894376448 2883584]
repair deleting extent record: key 655894376448 168 2883584
adding new data backref on 655894376448 root 268 owner 94568 offset
15204352 found 2
Incorrect local backref count on 655926697984 root 261 owner 588700
offset 75497472 found 2 wanted 20 back 0x12d4dc0
Incorrect global backref count on 655926697984 found 2 wanted 20
backpointer mismatch on [655926697984 8388608]
repair deleting extent record: key 655926697984 168 8388608
adding new data backref on 655926697984 root 261 owner 588700 offset
75497472 found 2
Incorrect local backref count on 655981510656 root 261 owner 588700
offset 92274688 found 2 wanted 17 back 0x132dbc0
Incorrect global backref count on 655981510656 found 2 wanted 17
backpointer mismatch on [655981510656 8388608]
repair deleting extent record: key 655981510656 168 8388608
adding new data backref on 655981510656 root 261 owner 588700 offset
92274688 found 2
Incorrect local backref count on 656023379968 root 261 owner 571175
offset 16777216 found 2 wanted 5 back 0x132ec60
Incorrect global backref count on 656023379968 found 2 wanted 5
backpointer mismatch on [656023379968 8388608]
repair deleting extent record: key 656023379968 168 8388608
adding new data backref on 656023379968 root 261 owner 571175 offset
16777216 found 2
Incorrect local backref count on 656056569856 root 268 owner 94568
offset 16646144 found 2 wanted 3 back 0x132eec0
Incorrect global backref count on 656056569856 found 2 wanted 3
backpointer mismatch on [656056569856 14155776]
repair deleting extent record: key 656056569856 168 14155776
adding new data backref on 656056569856 root 268 owner 94568 offset
16646144 found 2
repaired damaged extent references
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
reset nbytes for ino 229313 root 266
checking csums
checking root refs
found 386840608768 bytes used err is 0
total csum bytes: 373853376
total tree bytes: 1761443840
total fs tree bytes: 1181761536
total extent tree bytes: 122601472
btree space waste bytes: 288802816
file data blocks allocated: 389546860544
 referenced 408575717376

also seems this didn't repaired it because running check again it shows same
errors.

Interestingly btrfs scrub completed sucesfully without any errors but then when
I tried balance, kernel crashed and now every time I try to mount this volume I
get kernel crash.

kernel: BTRFS info (device vda): disk space caching is enabled
kernel: BTRFS info (device vda): has skinny extents
kernel: BTRFS info (device vda): checking UUID tree
kernel: BTRFS info (device vda): continuing balance
kernel: BTRFS info (device vda): relocating block group 657025138688 flags 17
kernel: BTRFS info (device vda): relocating block group 655951396864 flags 17
kernel: BTRFS info (device vda): found 105 extents
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:1872!

there isn't any other output after this.
