Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:57710 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFOKyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 06:54:24 -0400
Received: by mail-yk0-f180.google.com with SMTP id 131so3318103ykp.25
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 03:54:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMdWP3HZPWTwAO+A9r+cX6rORphFVCt5WDrXk9KKmJ6w+NPiQw@mail.gmail.com>
References: <CAMdWP3HZPWTwAO+A9r+cX6rORphFVCt5WDrXk9KKmJ6w+NPiQw@mail.gmail.com>
Date: Sun, 15 Jun 2014 12:54:23 +0200
Message-ID: <CAMdWP3HA6sBo0bw_bVXsHF+CxjY5phHTco6OLytBXh6Ya8um5g@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:2417
From: Tobias Hunger <tobias.hunger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some more information:

[root@ron ~]# uname -a
Linux ron 3.14.3-2-ARCH #1 SMP PREEMPT Mon May 12 20:52:20 CEST 2014
x86_64 GNU/Linux


[root@ron ~]# btrfsck /dev/mapper/raid0d0
Checking filesystem on /dev/mapper/raid0d0
UUID: 18d8b702-5519-40dc-ab14-c425xxxxxxxx
checking extents
read block failed check_tree_block
corrupt extent record: key 4310691840 168 524288
corrupt extent record: key 4351066112 168 524288
ref mismatch on [0 16384] extent item 0, found 1
Backref 0 parent 7 root 7 not found in extent tree
backpointer mismatch on [0 16384]
owner ref check failed [0 16384]
ref mismatch on [93011968 16384] extent item 1, found 0
Backref 93011968 root 7 not referenced back 0x28fbff0
Incorrect global backref count on 93011968 found 1 wanted 0
backpointer mismatch on [93011968 16384]
owner ref check failed [93011968 16384]
Backref 4310691840 root 261 owner 14381 offset 11534336 num_refs 0 not
found in extent tree
Incorrect local backref count on 4310691840 root 261 owner 14381
offset 11534336 found 1 wanted 0 back 0x3e29120
backpointer mismatch on [4310691840 524288]
ref mismatch on [4321177600 524288] extent item 0, found 1
Backref 4321177600 root 261 owner 14381 offset 22020096 num_refs 0 not
found in extent tree
Incorrect local backref count on 4321177600 root 261 owner 14381
offset 22020096 found 1 wanted 0 back 0x2eca0e0
backpointer mismatch on [4321177600 524288]
Backref 4351066112 root 261 owner 14381 offset 51904512 num_refs 0 not
found in extent tree
Incorrect local backref count on 4351066112 root 261 owner 14381
offset 51904512 found 1 wanted 0 back 0x2eca140
backpointer mismatch on [4351066112 524288]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
root 260 root dir 256 error
read block failed check_tree_block
btrfsck: cmds-check.c:1104: count_csum_range: Assertion `!(ret < 0)' failed.
Aborted (core dumped)
