Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:45863 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965049AbeAXTBV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 14:01:21 -0500
Received: by mail-wm0-f51.google.com with SMTP id i186so10315766wmi.4
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 11:01:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com> <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com> <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
From: "^m'e" <marcoep@gmail.com>
Date: Wed, 24 Jan 2018 19:00:59 +0000
Message-ID: <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The complete check:

Checking filesystem on /dev/sdb3
UUID: de1723e2-150c-4448-bb36-be14d7d96093
ERROR: extent[64368619520, 524288] referencer count mismatch (root:
257, owner: 7804556, offset: 212992) wanted: 1, have: 0
ERROR: data extent[1862352896 425984] backref lost
ERROR: data extent[1886453760 479232] backref lost
ERROR: data extent[1902219264 524288] backref lost
ERROR: data extent[1817378816 151552] backref lost
ERROR: data extent[1799688192 57344] backref lost
ERROR: data extent[1830277120 258048] backref lost
ERROR: data extent[2558107648 1368064] backref lost
ERROR: errors found in extent allocation tree or chunk allocation
cache and super generation don't match, space cache will be invalidated
ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
INODE_ITEM[0] namelen 0 filename  filetype 0
ERROR: root 257 DIR_ITEM[30039322 4007295565] data_len shouldn't be 32907
ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
INODE_ITEM[0] namelen 3 filename  filetype 0
ERROR: root 258 EXTENT_DATA[1119172 1966080] prealloc shouldn't have datasum
ERROR: root 1327 EXTENT_DATA[60710 18219008] prealloc shouldn't have datasum
ERROR: root 1331 EXTENT_DATA[60710 18219008] prealloc shouldn't have datasum
ERROR: root 1333 EXTENT_DATA[60710 18219008] prealloc shouldn't have datasum
ERROR: root 1362 EXTENT_DATA[1119172 1966080] prealloc shouldn't have datasum
ERROR: root 1366 EXTENT_DATA[1119172 1966080] prealloc shouldn't have datasum
ERROR: root 1382 EXTENT_DATA[1119172 1966080] prealloc shouldn't have datasum
ERROR: root 1385 DIR_ITEM[30039322 2438219243] couldn't find relative
INODE_ITEM[0] namelen 12 filename metadata.xml filetype 1
ERROR: root 1385 DIR INODE [30039322] size(152) not equal to 136
ERROR: root 1385 INODE REF[30039324 30039322] and DIR_ITEM[30039322
2438219243] mismatch namelen 12 filename metadata.xml filetype 1
found 104348008448 bytes used err is -5
total csum bytes: 99534904
total tree bytes: 3204612096
total fs tree bytes: 2984034304
total extent tree bytes: 87818240
btree space waste bytes: 778261104
file data blocks allocated: 242964852736
 referenced 198454632448
