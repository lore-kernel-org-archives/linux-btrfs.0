Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33787 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbbCUM0b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 08:26:31 -0400
Received: by qcbjx9 with SMTP id jx9so74752201qcb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2015 05:26:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 21 Mar 2015 13:26:30 +0100
Message-ID: <CAH4oapfmnuN=NwE5yuC68oqojak2uHesgJQtuHritYx4HiOvOw@mail.gmail.com>
Subject: Error: btrfs check --repair --init-csum-tree --init-extent-tree
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running btrfs check on a RAID1 system using btrfs-progs v3.19-rc2
and running the 4.0.0-rc4 linux kernel. I get this:

btrfs check --repair --init-csum-tree --init-extent-tree /dev/sda1
...
...
Incorrect local backref count on 2019737948160 parent 2541793873920
owner 0 offset 0 found 1 wanted 0 back 0x624dece0
backpointer mismatch on [2019737948160 4096]
ref mismatch on [2019737952256 4096] extent item 0, found 5
adding new data backref on 2019737952256 root 271 owner 615 offset 0 found 1
adding new data backref on 2019737952256 parent 2935248711680 owner 0
offset 0 found 1
adding new data backref on 2019737952256 parent 3289312481280 owner 0
offset 0 found 1
ctree.c:1595: leaf_space_used: Assertion `data_len < 0` failed.
btrfs[0x43324d]
btrfs[0x43380c]
btrfs(btrfs_leaf_free_space+0x24)[0x434f64]
btrfs(btrfs_check_leaf+0xa5)[0x435065]
btrfs[0x435432]
btrfs(btrfs_search_slot+0x305)[0x437025]
btrfs(btrfs_insert_empty_items+0x8a)[0x4384aa]
btrfs[0x43ebe9]
btrfs[0x43edb7]
btrfs(btrfs_inc_extent_ref+0xf1)[0x440151]
btrfs[0x40b512]
btrfs[0x412fe5]
btrfs(cmd_check+0x77d)[0x426afd]
btrfs(main+0x82)[0x413742]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f9078031a65]
btrfs[0x413843]

is someone from the devs interested on debuging this?

Let me know
Pavol
