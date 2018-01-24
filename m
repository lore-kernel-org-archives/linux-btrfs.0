Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:43112 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933688AbeAXOsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 09:48:15 -0500
Received: by mail-wm0-f47.google.com with SMTP id g1so8936521wmg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 06:48:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com> <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Wed, 24 Jan 2018 14:47:53 +0000
Message-ID: <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My bad, forgot to check out the correct branch. Recloned, compiled and
fixed. Then rechecking:

-----------------------------------------------------------
# btrfs check --mode=lowmem /dev/sdb3
Checking filesystem on /dev/sdb3
UUID: de1723e2-150c-4448-bb36-be14d7d96093
checking extents
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
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
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
...
-----------------------------------------------------------


Trying again to repair:

-----------------------------------------------------------
# btrfs check -p --repair /dev/sdb3
enabling repair mode
Checking filesystem on /dev/sdb3
UUID: de1723e2-150c-4448-bb36-be14d7d96093
ref mismatch on [1799688192 57344] extent item 0, found 1
Backref 1799688192 root 1385 owner 47301992 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1799688192 root 1385 owner 47301992
offset 0 found 1 wanted 0 back 0x93a27f8
backpointer mismatch on [1799688192 57344]
repair deleting extent record: key 1799688192 168 57344
adding new data backref on 1799688192 root 1385 owner 47301992 offset 0 found 1
Repaired extent references for 1799688192
ref mismatch on [1817378816 151552] extent item 0, found 1
Backref 1817378816 root 1385 owner 47301982 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1817378816 root 1385 owner 47301982
offset 0 found 1 wanted 0 back 0x94643f0
backpointer mismatch on [1817378816 151552]
repair deleting extent record: key 1817378816 168 151552
adding new data backref on 1817378816 root 1385 owner 47301982 offset 0 found 1
Repaired extent references for 1817378816
ref mismatch on [1830277120 258048] extent item 0, found 1
Backref 1830277120 root 1385 owner 47302002 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1830277120 root 1385 owner 47302002
offset 0 found 1 wanted 0 back 0xc7bd1b8
backpointer mismatch on [1830277120 258048]
repair deleting extent record: key 1830277120 168 258048
adding new data backref on 1830277120 root 1385 owner 47302002 offset 0 found 1
Repaired extent references for 1830277120
ref mismatch on [1862352896 425984] extent item 0, found 1
Backref 1862352896 root 1385 owner 47301952 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1862352896 root 1385 owner 47301952
offset 0 found 1 wanted 0 back 0xef22790
backpointer mismatch on [1862352896 425984]
repair deleting extent record: key 1862352896 168 425984
adding new data backref on 1862352896 root 1385 owner 47301952 offset 0 found 1
Repaired extent references for 1862352896
ref mismatch on [1886453760 479232] extent item 0, found 1
Backref 1886453760 root 1385 owner 47301962 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1886453760 root 1385 owner 47301962
offset 0 found 1 wanted 0 back 0x93a1058
backpointer mismatch on [1886453760 479232]
repair deleting extent record: key 1886453760 168 479232
adding new data backref on 1886453760 root 1385 owner 47301962 offset 0 found 1
Repaired extent references for 1886453760
ref mismatch on [1902219264 524288] extent item 0, found 1
Backref 1902219264 root 1385 owner 47301972 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 1902219264 root 1385 owner 47301972
offset 0 found 1 wanted 0 back 0x93883a8
backpointer mismatch on [1902219264 524288]
repair deleting extent record: key 1902219264 168 524288
adding new data backref on 1902219264 root 1385 owner 47301972 offset 0 found 1
Repaired extent references for 1902219264
ref mismatch on [2558107648 1368064] extent item 0, found 1
Backref 2558107648 root 1385 owner 47302009 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2558107648 root 1385 owner 47302009
offset 0 found 1 wanted 0 back 0xf734160
backpointer mismatch on [2558107648 1368064]
repair deleting extent record: key 2558107648 168 1368064
adding new data backref on 2558107648 root 1385 owner 47302009 offset 0 found 1
Repaired extent references for 2558107648
checking extents [O]
Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
invalid location in dir item 0
invalid location in dir item 125
Trying to rebuild inode:18446744073709551361
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
checkingunresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
invalid location in dir item 0
invalid location in dir item 125
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
invalid location in dir item 0
invalid location in dir item 125
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
invalid location in dir item 0
invalid location in dir item 125
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
Failed to reset nlink for inode 18446744073709551361: No such file or directory
    unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
errors 6, no dir index, no inode ref
    unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
errors 6, no dir index, no inode ref
...
-----------------------------------------------------------

Still looping on the same failed item :-(
I guess we need another debug round...
