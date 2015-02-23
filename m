Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40646 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbbBWWIQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 17:08:16 -0500
Received: by qcwb13 with SMTP id b13so13678384qcw.7
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Feb 2015 14:08:16 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Feb 2015 23:08:16 +0100
Message-ID: <CAH4oapeomcGHbAuEX_AhmYH+a_pHgcirPJtJG6-kPfRd9g9RoA@mail.gmail.com>
Subject: unable to finish init-extent-tree
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi all,

I am having trouble finishing a init-extent-tree rebuild on a raid1
btrfs that became corrupted,
I was unable to finish a scrub on the system although the disks don't
have any bad blocks.
So I tried to repair the system, but that didn't help it either.

btrfs check --repair /dev/sda1
enabling repair mode
Checking filesystem on /dev/sda1
UUID: 76bf605a-936b-4fce-8a74-1eb2c750f51c
checking extents
Errors found in extent allocation tree or chunk allocation
Error: could not find extent items for root 258

uname -r
3.19.0-gentoo

x86_64 AMD Phenom(tm) II X4 965 Processor AuthenticAMD GNU/Linux

Btrfs v3.18.2

if I try to --repair with --init-extent-tree I get this:
# btrfs check --repair --init-extent-tree /dev/sda1
                                              enabling repair mode
Checking filesystem on /dev/sda1
UUID: 76bf605a-936b-4fce-8a74-1eb2c750f51c
Creating a new extent tree

Failed to find [4849148100608, 168, 4096]
btrfs unable to find ref byte nr 4849148100608 parent 0 root 1  owner 2 offset 0
Failed to find [4849148141568, 168, 4096]
btrfs unable to find ref byte nr 4849148141568 parent 0 root 1  owner 1 offset 1
Failed to find [4849148145664, 168, 4096]
btrfs unable to find ref byte nr 4849148145664 parent 0 root 1  owner 0 offset 1
Failed to find [4849148104704, 168, 4096]
btrfs unable to find ref byte nr 4849148104704 parent 0 root 1  owner 1 offset 1
Failed to find [4849148108800, 168, 4096]
btrfs unable to find ref byte nr 4849148108800 parent 0 root 1  owner 0 offset 1
checking extents
parent transid verify failed on 4849148104704 wanted 219108 found 219724
parent transid verify failed on 4849148104704 wanted 219108 found 219724
parent transid verify failed on 4849148104704 wanted 219108 found 219724
parent transid verify failed on 4849148104704 wanted 219108 found 219724
Ignoring transid failure
bad block 4849148104704
parent transid verify failed on 4849148116992 wanted 219108 found 219723
parent transid verify failed on 4849148116992 wanted 219108 found 219723
parent transid verify failed on 4849148116992 wanted 219108 found 219723
parent transid verify failed on 4849148116992 wanted 219108 found 219723
Ignoring transid failure
bad block 4849148116992
parent transid verify failed on 4849148121088 wanted 219108 found 219723
parent transid verify failed on 4849148121088 wanted 219108 found 219723
parent transid verify failed on 4849148121088 wanted 219108 found 219723
parent transid verify failed on 4849148121088 wanted 219108 found 219723
Ignoring transid failure
leaf parent key incorrect 4849148121088
bad block 4849148121088
parent transid verify failed on 2078793535488 wanted 118799 found 219724
parent transid verify failed on 2078793535488 wanted 118799 found 219724
parent transid verify failed on 2078793535488 wanted 118799 found 219724
parent transid verify failed on 2078793535488 wanted 118799 found 219724
Ignoring transid failure
bad block 2078793535488
parent transid verify failed on 2078793539584 wanted 118799 found 219724
parent transid verify failed on 2078793539584 wanted 118799 found 219724
parent transid verify failed on 2078793539584 wanted 118799 found 219724
parent transid verify failed on 2078793539584 wanted 118799 found 219724
Ignoring transid failure
leaf parent key incorrect 2078793539584
bad block 2078793539584
parent transid verify failed on 2078793543680 wanted 118799 found 219724
parent transid verify failed on 2078793543680 wanted 118799 found 219724
parent transid verify failed on 2078793543680 wanted 118799 found 219724
parent transid verify failed on 2078793543680 wanted 118799 found 219724
Ignoring transid failure
leaf parent key incorrect 2078793543680
bad block 2078793543680
parent transid verify failed on 2078793547776 wanted 118799 found 219722
parent transid verify failed on 2078793547776 wanted 118799 found 219722
parent transid verify failed on 2078793547776 wanted 118799 found 219722
parent transid verify failed on 2078793547776 wanted 118799 found 219722
Ignoring transid failure
leaf parent key incorrect 2078793547776
bad block 2078793547776
parent transid verify failed on 2078793560064 wanted 118799 found 219723
parent transid verify failed on 2078793560064 wanted 118799 found 219723
parent transid verify failed on 2078793560064 wanted 118799 found 219723
parent transid verify failed on 2078793560064 wanted 118799 found 219723
Ignoring transid failure
leaf parent key incorrect 2078793560064
bad block 2078793560064
parent transid verify failed on 2078793564160 wanted 118799 found 219723
parent transid verify failed on 2078793564160 wanted 118799 found 219723
parent transid verify failed on 2078793564160 wanted 118799 found 219723
parent transid verify failed on 2078793564160 wanted 118799 found 219723
Ignoring transid failure
leaf parent key incorrect 2078793564160
bad block 2078793564160
parent transid verify failed on 4849148137472 wanted 219108 found 219716
parent transid verify failed on 4849148137472 wanted 219108 found 219716
parent transid verify failed on 4849148137472 wanted 219108 found 219716
parent transid verify failed on 4849148137472 wanted 219108 found 219716
Ignoring transid failure
leaf parent key incorrect 4849148137472
bad block 4849148137472
ref mismatch on [2019737731072 20480] extent item 0, found 1
adding new data backref on 2019737731072 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737731072 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737731072 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x340609d0
backpointer mismatch on [2019737731072 20480]
ref mismatch on [2019737751552 53248] extent item 0, found 2
adding new data backref on 2019737751552 root 270 owner 104589 offset 0 found 1
adding new data backref on 2019737751552 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737751552 root 270 owner 104589 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737751552 root 270 owner 104589
offset 0 found 1 wanted 0 back 0xf205980
Backref 2019737751552 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737751552 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060840
backpointer mismatch on [2019737751552 53248]
ref mismatch on [2019737804800 8192] extent item 0, found 2
adding new data backref on 2019737804800 root 270 owner 104592 offset 0 found 1
adding new data backref on 2019737804800 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737804800 root 270 owner 104592 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737804800 root 270 owner 104592
offset 0 found 1 wanted 0 back 0xf205be0
Backref 2019737804800 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737804800 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060a30
backpointer mismatch on [2019737804800 8192]
ref mismatch on [2019737812992 8192] extent item 0, found 2
adding new data backref on 2019737812992 root 270 owner 104594 offset 0 found 1
adding new data backref on 2019737812992 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737812992 root 270 owner 104594 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737812992 root 270 owner 104594
offset 0 found 1 wanted 0 back 0xf205e40
Backref 2019737812992 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737812992 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060af0
backpointer mismatch on [2019737812992 8192]
ref mismatch on [2019737821184 4096] extent item 0, found 1
adding new data backref on 2019737821184 root 4087 owner 271 offset 0 found 1
Backref 2019737821184 root 4087 owner 271 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737821184 root 4087 owner 271
offset 0 found 1 wanted 0 back 0x1b59940
backpointer mismatch on [2019737821184 4096]
ref mismatch on [2019737825280 4096] extent item 0, found 8
adding new data backref on 2019737825280 root 271 owner 650 offset 0 found 1
adding new data backref on 2019737825280 parent 2935566401536 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 2079599202304 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 2078987530240 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 2542074707968 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 3289313243136 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 4850896384000 owner 0
offset 0 found 1
adding new data backref on 2019737825280 parent 2935561736192 owner 0
offset 0 found 1
Backref 2019737825280 root 271 owner 650 offset 0 num_refs 0 not found
in extent tree
Incorrect local backref count on 2019737825280 root 271 owner 650
offset 0 found 1 wanted 0 back 0x10968c70
Backref 2019737825280 parent 2935566401536 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 2935566401536
owner 0 offset 0 found 1 wanted 0 back 0x3610bf00
Backref 2019737825280 parent 2079599202304 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 2079599202304
owner 0 offset 0
found 1 wanted 0 back 0x413746d0
Backref 2019737825280 parent 2078987530240 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 2078987530240
owner 0 offset 0 found 1 wanted 0 back 0x417ea1d0
Backref 2019737825280 parent 2542074707968 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 2542074707968
owner 0 offset 0 found 1 wanted 0 back 0x4fa4a040
Backref 2019737825280 parent 3289313243136 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 3289313243136
owner 0 offset 0 found 1 wanted 0 back 0x5112e170
Backref 2019737825280 parent 4850896384000 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 4850896384000
owner 0 offset 0 found 1 wanted 0 back 0x5767c340
Backref 2019737825280 parent 2935561736192 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737825280 parent 2935561736192
owner 0 offset 0 found 1 wanted 0 back 0x61e03ef0
backpointer mismatch on [2019737825280 4096]
ref mismatch on [2019737829376 8192] extent item 0, found 2
adding new data backref on 2019737829376 root 270 owner 104599 offset 0 found 1
adding new data backref on 2019737829376 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737829376 root 270 owner 104599 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737829376 root 270 owner 104599
offset 0 found 1 wanted 0 back 0xf205f70
Backref 2019737829376 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737829376 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060b50
backpointer mismatch on [2019737829376 8192]
ref mismatch on [2019737837568 40960] extent item 0, found 2
adding new data backref on 2019737837568 root 270 owner 104593 offset 0 found 1
adding new data backref on 2019737837568 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737837568 root 270 owner 104593 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737837568 root 270 owner 104593
offset 0 found 1 wanted 0 back 0xf205d10
Backref 2019737837568 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737837568 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060a90
backpointer mismatch on [2019737837568 40960]
ref mismatch on [2019737878528 16384] extent item 0, found 2
adding new data backref on 2019737878528 root 270 owner 104600 offset 0 found 1
adding new data backref on 2019737878528 parent 2079198044160 owner 0
offset 0 found 1
Backref 2019737878528 root 270 owner 104600 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737878528 root 270 owner 104600
offset 0 found 1 wanted 0 back 0xf2060a0
Backref 2019737878528 parent 2079198044160 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737878528 parent 2079198044160
owner 0 offset 0 found 1 wanted 0 back 0x34060bb0
backpointer mismatch on [2019737878528 16384]
ref mismatch on [2019737894912 16384] extent item 0, found 2
adding new data backref on 2019737894912 root 270 owner 104602 offset 0 found 1
adding new data backref on 2019737894912 parent 2079198048256 owner 0
offset 0 found 1
Backref 2019737894912 root 270 owner 104602 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737894912 root 270 owner 104602
offset 0 found 1 wanted 0 back 0xf2061d0
Backref 2019737894912 parent 2079198048256 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737894912 parent 2079198048256
owner 0 offset 0 found 1 wanted 0 back 0x34060c10
backpointer mismatch on [2019737894912 16384]
ref mismatch on [2019737911296 20480] extent item 0, found 2
adding new data backref on 2019737911296 root 270 owner 104603 offset 0 found 1
adding new data backref on 2019737911296 parent 2079198048256 owner 0
offset 0 found 1
Backref 2019737911296 root 270 owner 104603 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737911296 root 270 owner 104603
offset 0 found 1 wanted 0 back 0xf206300
Backref 2019737911296 parent 2079198048256 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737911296 parent 2079198048256
owner 0 offset 0 found 1 wanted 0 back 0x34060c70
backpointer mismatch on [2019737911296 20480]
ref mismatch on [2019737931776 12288] extent item 0, found 2
adding new data backref on 2019737931776 root 270 owner 104604 offset 0 found 1
adding new data backref on 2019737931776 parent 2079198048256 owner 0
offset 0 found 1
Backref 2019737931776 root 270 owner 104604 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 2019737931776 root 270 owner 104604
offset 0 found 1 wanted 0 back 0xf206430
Backref 2019737931776 parent 2079198048256 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737931776 parent 2079198048256
owner 0 offset 0 found 1 wanted 0 back 0x34060cd0
backpointer mismatch on [2019737931776 12288]
ref mismatch on [2019737944064 4096] extent item 0, found 5
adding new data backref on 2019737944064 root 271 owner 612 offset 0 found 1
adding new data backref on 2019737944064 parent 2935248711680 owner 0
offset 0 found 1
adding new data backref on 2019737944064 parent 3289312481280 owner 0
offset 0 found 1
adding new data backref on 2019737944064 parent 3289021186048 owner 0
offset 0 found 1
adding new data backref on 2019737944064 parent 2541793873920 owner 0
offset 0 found 1
Backref 2019737944064 root 271 owner 612 offset 0 num_refs 0 not found
in extent tree
Incorrect local backref count on 2019737944064 root 271 owner 612
offset 0 found 1 wanted 0 back 0x1095a9a0
Backref 2019737944064 parent 2935248711680 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737944064 parent 2935248711680
owner 0 offset 0 found 1 wanted 0 back 0x361020c0
Backref 2019737944064 parent 3289312481280 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737944064 parent 3289312481280
owner 0 offset 0 found 1 wanted 0 back 0x51129c10
Backref 2019737944064 parent 3289021186048 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737944064 parent 3289021186048
owner 0 offset 0 found 1 wanted 0 back 0x57629d80
Backref 2019737944064 parent 2541793873920 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737944064 parent 2541793873920
owner 0 offset 0 found 1 wanted 0 back 0x61da8ab0
backpointer mismatch on [2019737944064 4096]
ref mismatch on [2019737948160 4096] extent item 0, found 5
adding new data backref on 2019737948160 root 271 owner 613 offset 0 found 1
adding new data backref on 2019737948160 parent 2935248711680 owner 0
offset 0 found 1
adding new data backref on 2019737948160 parent 3289312481280 owner 0
offset 0 found 1
adding new data backref on 2019737948160 parent 3289021186048 owner 0
offset 0 found 1
adding new data backref on 2019737948160 parent 2541793873920 owner 0
offset 0 found 1
Backref 2019737948160 root 271 owner 613 offset 0 num_refs 0 not found
in extent tree
Incorrect local backref count on 2019737948160 root 271 owner 613
offset 0 found 1 wanted 0 back 0x1095aad0
Backref 2019737948160 parent 2935248711680 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737948160 parent 2935248711680
owner 0 offset 0 found 1 wanted 0 back 0x36102120
Backref 2019737948160 parent 3289312481280 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737948160 parent 3289312481280
owner 0 offset 0 found 1 wanted 0 back 0x51129c70
Backref 2019737948160 parent 3289021186048 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737948160 parent 3289021186048
owner 0 offset 0 found 1 wanted 0 back 0x57629de0
Backref 2019737948160 parent 2541793873920 owner 0 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 2019737948160 parent 2541793873920
owner 0 offset 0 found 1 wanted 0 back 0x61da8b10
backpointer mismatch on [2019737948160 4096]
ref mismatch on [2019737952256 4096] extent item 0, found 5
adding new data backref on 2019737952256 root 271 owner 615 offset 0 found 1
adding new data backref on 2019737952256 parent 2935248711680 owner 0
offset 0 found 1
adding new data backref on 2019737952256 parent 3289312481280 owner 0
offset 0 found 1
ctree.c:1595: leaf_space_used: Assertion `data_len < 0` failed.
btrfs[0x42c74d]
btrfs[0x42cd0c]
btrfs[0x42e464]
btrfs[0x42e565]
btrfs[0x42e932]
btrfs[0x43053d]
btrfs[0x431b4a]
btrfs[0x4381e9]
btrfs[0x4383b7]
btrfs[0x439751]
btrfs[0x405291]
btrfs[0x40c63f]
btrfs[0x41fffd]
btrfs[0x40cda2]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f84dd301a65]
btrfs[0x40cea3]

Thank you
Pavol
