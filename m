Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63925 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3A1OHe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 09:07:34 -0500
Received: by mail-ob0-f174.google.com with SMTP id 16so2761222obc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 06:07:33 -0800 (PST)
MIME-Version: 1.0
From: polack christian <baobab874@gmail.com>
Date: Mon, 28 Jan 2013 15:07:13 +0100
Message-ID: <CAC6BJd=gbiV+14yk=ghyUozp99Q6QCE6ip_FAp2WoPZTNYNVvw@mail.gmail.com>
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
