Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34675 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbcEYLp0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:45:26 -0400
Received: by mail-io0-f196.google.com with SMTP id d197so4789986ioe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 04:45:26 -0700 (PDT)
Subject: Re: Copy on write of unmodified data
To: "H. Peter Anvin" <hpa@zytor.com>, linux-btrfs@vger.kernel.org
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f5b65a85-7d52-1aae-f976-f46179426b0a@gmail.com>
Date: Wed, 25 May 2016 07:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 04:58, H. Peter Anvin wrote:
> Hi,
>
> I'm looking at using a btrfs with snapshots to implement a generational
> backup capacity.  However, doing it the naïve way would have the side
> effect that for a file that has been partially modified, after
> snapshotting the file would be written with *mostly* the same data.  How
> does btrfs' COW algorithm deal with that?  If necessary I might want to
> write some smarter user space utilities for this.
>
I might be completely incorrect about this, but here's what I believe 
happens in this case:
1. If the file is small enough that it gets stored in-line in the 
metadata, you can't avoid COW for the whole file.
2. If the file is less than the block size (16k is the current default 
in mkfs.btrfs for reasonably sized filesystems), then you also can't 
avoid COW for the whole file.
3. If the file is larger than the block size, COW will only happen 
per-block, and extents will get split at block boundaries to minimize 
the amount of duplication.

This of course requires that the updates are done by partial re-writes 
instead of a replace-by-rename semantic which is particularly popular 
among various software tools.

FWIW, while I don't use BTRFS like this (I just use snapshots to get a 
consistent state to copy out for backups, usually doing the actual 
backup using SquashFS), one of my friends uses rsync together with BTRFS 
to do incremental backups of his personal systems.  He runs rsync with 
--in-place on the system being backed up to copy things out to a 
dedicated subvolume on his backup device, and then snapshots the 
subvolume after each backup (and uses a snapshot thinning system similar 
to that used by snapper).  While it's not quite as efficient as it could 
be, it's still works well.

Alternatively, if you're backing up a BTRFS filesystem to another one, 
you can keep around the previous backup snapshot and do an incremental 
send against that, which will result in proper sharing of blocks.  I 
used to use this before I decided that I wanted better space efficiency 
for backups than BTRFS can currently offer.
