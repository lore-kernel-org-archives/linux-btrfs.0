Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60305 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3A2Kr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:47:27 -0500
Received: by mail-oa0-f46.google.com with SMTP id k1so262063oag.5
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 02:47:27 -0800 (PST)
MIME-Version: 1.0
From: polack christian <baobab874@gmail.com>
Date: Tue, 29 Jan 2013 11:47:06 +0100
Message-ID: <CAC6BJdkN6XJJVD5ONLnk=n9yeag0rLbkvRS3tNMX4L-jwmQUjA@mail.gmail.com>
Subject: btrfsck and ctree version
To: mailing list linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello

i am using fedora 18 with the last kernel  3.7.2-204.fc18.x86_64

I was trying to recover an old crashed btrfs filesystem one last time.

recover tool is not helping much

 ./btrfs-find-root /dev/sdb1
Super think's the tree root is at 799547392, chunk root 21299200
Well block 4194304 seems great, but generation doesn't match, have=3,
want=1635037
Well block 4206592 seems great, but generation doesn't match, have=4,
want=1635037
Well block 4292608 seems good, but the csum doesn't match
Found tree root at 799547392

i did use btrfsck to recover it
i got the tool from

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

and i got this error message:
...
Check tree block failed, want=294555648, have=0
Check tree block failed, want=294559744, have=0
Check tree block failed, want=294559744, have=0
btrfsck: ctree.c:1690: leaf_space_used: Assertion `!(data_len < 0)' failed.
Aborted (core dumped)

looking at

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

this error in ctree.c have been corrected by this commit

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=41be1f3b40b87de33cd2e7463dce88596dbdccc4

is there a more up-to-date version of btrfs-prog including this correction
which is available ?


thanks

olivier
