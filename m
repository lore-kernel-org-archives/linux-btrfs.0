Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35801 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcDOP2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 11:28:50 -0400
Received: by mail-io0-f175.google.com with SMTP id g185so138042004ioa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 08:28:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Apr 2016 09:28:49 -0600
Message-ID: <CAJCQCtSKDunrKyU8+wmh8qLp9zEgP06Ej58Xj4_24PUk8v5Yqg@mail.gmail.com>
Subject: BUG at fs/btrfs/inode.c:1828! RIP: btrfs_merge_bio_hook+0x8b/0xa0 [btrfs]
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Note this is a testing VM, no user data is at risk

https://bugzilla.kernel.org/show_bug.cgi?id=116331

Gist is this is a new Btrfs file system, and while -o recovery,ro
permits mount, it can't be repaired, and btrfs-image fails also. A
normal mount results in a call trace, which is what the subject is set
to, and the bug contains the complete dmesg for that.

File system starts as:
openSUSE-Tumbleweed-GNOME-Live-x86_64-Snapshot20160307-Media.iso
Creation time btrfs-progs 4.4.1, kernel 4.4.3.

Very light usage for several weeks, but includes scrubs and balance
with no errors. Today, while using YaST2 to remove packages, there was
a complete system hang. After 30 minutes I force quit the VM.
Subsequent boots fail.

I then moved to booting Fedora 24 (prerelease) for troubleshooting, to
use kernel 4.5.0 and progs 4.5.1.

mount fails/crashes, with trace
mount -o recovery fails/crashes, with trace
mount -o recovery,ro works (!) and I can dig up the journals from the
YaST2 hang which includes some Btrfs csum errors, I think during the
hang.

btrfs-image fails
btrfs-debug-tree mostly works, the bug report contains a URL for that file

btrfs check --repair finds but doesn't fix the problem,
--init-extent-tree crashes

So it's pretty messy fixing wise. But so far -o recovery,ro is letting
me extract important things like the journal.

-- 
Chris Murphy
