Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965574Ab2JYUDt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:03:49 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2257420pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 13:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025195805.GA24111@merlins.org>
References: <20121025195805.GA24111@merlins.org>
Date: Thu, 25 Oct 2012 14:03:49 -0600
Message-ID: <CAE5mzvi=y6Auyr9cGMOm=tUSSj7sSQ78W0Bnzk+dJOqkW6z6jA@mail.gmail.com>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707
From: cwillu <cwillu@cwillu.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 1:58 PM, Marc MERLIN <marc@merlins.org> wrote:
> Howdy,
>
> I can wait a day or maybe 2 before I have to wipe and restore from backup.
> Please let me know if you have a patch against 3.6.3 you'd like me to try
> to mount/recover this filesystem, or whether you'd like me to try btrfsck.
>
>
> My laptop had a problem with its boot drive which prevented linux
> from writing to it, and in turn caused btrfs to have incomplete writes
> to it.
> After reboot, the boot drive was fine, but the btrfs filesystem has
> a corruption that prevents it from being mounted.
>
> Unfortunately the mount crash prevents writing of crash data to even another
> drive since linux stops before the crash data can be written to syslog.
>
> Picture #1 shows a dump when my laptop crashed (before reboot).
> btrfs no csum found for inode X start Y
> http://marc.merlins.org/tmp/crash.jpg
>
> Mounting with 3.5.0 and 3.6.3 gives the same error:
>
> gandalfthegreat:~# mount -o recovery,skip_balance,ro /dev/mapper/bootdsk
>
> shows
> btrfs: bdev /dev/mapper/bootdsk errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> btrfs: bdev /dev/mapper/bootdsk errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> (there are 2 lines, not sure why)
>
> kernel BUG at fs/btrfs/volumes.c:3707
> int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
> {
>         struct extent_map *em;
>         struct map_lookup *map;
>         struct extent_map_tree *em_tree = &map_tree->map_tree;
>         int ret;
>
>         read_lock(&em_tree->lock);
>         em = lookup_extent_mapping(em_tree, logical, len);
>         read_unlock(&em_tree->lock);
>         BUG_ON(!em);  <---
>
> If the snapshot helps (sorry, hard to read, but usable):
> http://marc.merlins.org/tmp/btrfs_bug.jpg
>
> Questions:
> 1) Any better way to get a proper dump without serial console?
> (I hate to give you pictures)
>
> 2) Should I try btrfsck now, or are there other mount options than
> mount -o recovery,skip_balance,ro /dev/mapper/bootdsk
> I should try?
>
> 3) Want me to try btrfsck although it may make it impossible for me to
> reproduce the bug and test a fix, as well as potentially break the filesystem
> more (last time I tried btrfsck, it outputted thousands of lines and never converged
> to a state it was happy with)

This looks like something btrfs-zero-log would work around (although
-o recovery should do mostly the same things).  That would destroy the
evidence though, and may just make things (slightly) worse, so I'd
wait to see if anyone suggests something better before trying it.  If
you're ultimately ending up restoring from backup though, it may save
you that effort at least.
