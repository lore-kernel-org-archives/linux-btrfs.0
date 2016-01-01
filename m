Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38507 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbcAABWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 20:22:11 -0500
Received: by mail-ig0-f173.google.com with SMTP id mw1so71405019igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 17:22:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
References: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
Date: Thu, 31 Dec 2015 18:22:09 -0700
Message-ID: <CAJCQCtSDpGnXpFpHxO9eyb7pLWKQis6+yOBznFkJO85e0NLyyw@mail.gmail.com>
Subject: Re: Unrecoverable fs corruption?
From: Chris Murphy <lists@colorremedies.com>
To: Alexander Duscheleit <alexander.duscheleit@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 4:36 PM, Alexander Duscheleit
<alexander.duscheleit@gmail.com> wrote:
> Hello,
>
> I had a power fail today at my home server and after the reboot the btrfs
> RAID1 won't come back up.
>
> When trying to mount one of the 2 disks of the array I get the following
> error:
> [ 4126.316396] BTRFS info (device sdb2): disk space caching is enabled
> [ 4126.316402] BTRFS: has skinny extents
> [ 4126.337324] BTRFS: failed to read chunk tree on sdb2
> [ 4126.353027] BTRFS: open_ctree failed


Why are you trying to mount only one? What mount options did you use
when you did this?


>
> a btrfs check segfaults after a few seconds with the following message:
> (0:29)[root@hera]~  # ❯❯❯ btrfs check /dev/sdb2
> warning devid 1 not found already
> bad key ordering 68 69
> Checking filesystem on /dev/sdb2
> UUID: d55fa866-3baa-4e73-bf3e-5fda29672df3
> checking extents
> bad key ordering 68 69
> bad block 6513625202688
> Errors found in extent allocation tree or chunk allocation
> [1]    11164 segmentation fault  btrfs check /dev/sdb2
>
> I have 2 btrfs-images (one with -w, one without) but they are 6.1G and 1.1G
> repectively, I don't know
> if I can upload them at all and also not where to store such large files.
>
> I did try a btrfs check --repair on one of the disks which gave the
> following result:
> enabling repair mode
> warning devid 1 not found already
> bad key ordering 68 69
> repair mode will force to clear out log tree, Are you sure? [y/N]: y
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.
> btrfs[0x44161e]
> btrfs(btrfs_reserve_extent+0xa7b)[0x4463db]
> btrfs(btrfs_alloc_free_block+0x5f)[0x44649f]
> btrfs(__btrfs_cow_block+0xc4)[0x437d64]
> btrfs(btrfs_cow_block+0x35)[0x438365]
> btrfs[0x43d3d6]
> btrfs(btrfs_commit_transaction+0x95)[0x43f125]
> btrfs(cmd_check+0x5ec)[0x429cdc]
> btrfs(main+0x82)[0x40ef32]
> /usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f881f983610]
> btrfs(_start+0x29)[0x40f039]
>
>
> That's all I tried so far.
> btrfs restore -viD seems to find most of the files accessible but since I
> don't have a spare hdd of
> sufficient size I would have to break the array and reformat and use one of
> the disk as restore
> target. I'm not prepared to do this before I know there is no other way to
> fix the drives since I'm
> essentially destroying one more chance at saving the data.
>
> Is there anything I can do to get the fs out of this mess?

I'm skeptical about the logic of using --repair, which modifies the
filesystem, on just one device of a two device rai1, while saying
you're reluctant to "break the array." It doesn't make sense to me to
expect such modification on one of the drives, keeps it at all
consistent with the other. I hope a dev can say whether --repair with
a missing device is a bad idea, because if so maybe degraded repairs
need a --force flag to help users from making things worse.

Anyway, in the meantime, my advice is do not mount either device rw
(together or separately). The less changes you make right now the
better.

What kernel and btrfs-progs version are you using?

Did you try to mount with -o recovery, or -o ro,recovery before trying
'btrfs check --repair' ? If so, post all relevant kernel messages.
Don't try -o recovery now if you haven't previously tried it; it's
probably safe to try -o ro,recovery if you haven't tried that yet. I
would try -o ro,recovery three ways: both devs, and each dev
separately (for which you'll use -o ro,recovery,degraded).

If that doesn't work, it sounds like it might be a task for 'btrfs
rescue chunk-recover' which will take a long time. But I suggest
waiting as long as possible for a reply, and in the meantime I suggest
looking at getting another drive to use as spare so you can keep both
of these drives.


-- 
Chris Murphy
