Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35072 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbD2SYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 14:24:11 -0400
Received: by pabtp1 with SMTP id tp1so34967606pab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 11:24:11 -0700 (PDT)
Date: Wed, 29 Apr 2015 11:24:09 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH] Revert "btrfs: delete chunk allocation attemp when
 setting block group ro"
Message-ID: <20150429182409.GA23155@mew.dhcp4.washington.edu>
References: <c99a895bc0facef23387ef7b44c98c0df41216fa.1429431096.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <c99a895bc0facef23387ef7b44c98c0df41216fa.1429431096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 19, 2015 at 01:17:05AM -0700, Omar Sandoval wrote:
> This reverts commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e.
> 
> This tried to fix the following test case:
> 
> 	mkfs.ext4 -F /dev/sda
> 	btrfs-convert /dev/sda
> 	mount /dev/sda /mnt
> 	btrfs device add -f /dev/sdb /mnt
> 	btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
> 
> Before the reverted commit, this test case failed with ENOSPC because
> all chunks on the freshly converted filesystem were allocated, although
> many were empty. The reverted commit removed an allocation attempt in
> btrfs_set_block_group_ro(), but that fix wasn't right. After the
> reverted commit, the balance succeeds, but the data/metadata profiles
> aren't actually updated:
> 
> 	# btrfs fi df /mnt
> 	Data, single: total=208.00MiB, used=49.48MiB
> 	System, single: total=32.00MiB, used=4.00KiB
> 	Metadata, single: total=208.00MiB, used=48.00KiB
> 	GlobalReserve, single: total=4.00MiB, used=0.00B
> 
> Indeed, several users reported that this commit caused a regression and
> that converting the data and metadata profiles no longer works. This is
> because the chunk allocation in question was where we actually allocated
> the chunk with the new profile. Not seeing a more obvious fix, let's
> just revert this. We can work around the ENOSPC in the original test
> case by just issuing a balance to free up the unused block groups before
> the conversion, anyways:
> 
> 	mkfs.ext4 -F /dev/sda
> 	btrfs-convert /dev/sda
> 	mount /dev/sda /mnt
> 	btrfs balance start -v /mnt
> 	btrfs device add -f /dev/sdb /mnt
> 	btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
> 
> Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
> Cc: Shaohua Li <shli@fb.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Holger reported this awhile ago and I haven't seen a proper fix make it
> to the ML. I messed around with it for awhile and came up empty, but I
> figured I might as well send this in. Applies to v4.0.
> 
>  fs/btrfs/extent-tree.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 

Has another fix for this shown up yet? Currently 4.0 and up can't
convert between data/metadata profiles, which seems like a pretty major
regression.

Thanks,
-- 
Omar
