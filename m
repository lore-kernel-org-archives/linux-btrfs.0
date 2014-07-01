Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaGAPcm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 11:32:42 -0400
Date: Tue, 1 Jul 2014 17:32:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, harald@redhat.com
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
Message-ID: <20140701153240.GL1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(adding Harald to CC)

On Tue, Jul 01, 2014 at 05:30:01PM +0800, Qu Wenruo wrote:
> This reverts commit 0723a0473fb48a1c93b113a28665b64ce5faf35a.
> This commit has the following problem:
> 1) Break the ro mount rule.
> When users mount the whole btrfs ro, it is still possible to mount
> subvol rw and change the contents. Which make the whole fs ro mount
> non-sense.

The proposed usecase was to allow mounting subvolumes with different
ro/rw flags, and this makes sense to me (provided that the whole
filesystem is mounted rw).

Anything else seems to lead to all the internal problems you point
below. I'm not even sure if mounting the first subvolume 'ro' should
imply that the whole filesystem is ro or not.

> 2) Cause whole btrfs ro/rw mount change fails.
> When mount a subvol ro first, when you can't mount the whole fs mounted
> rw. This is due to the check in btrfs_mount() which returns -EBUSY,
> which is OK for single fs to prevent mount fs ro in one mount point and
> mount the same fs rw in other mount point.
> Step to reproduce:
> mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
> mount -o rw /dev/sda6 /mnt/btrfs	<-this will fail

Yeah, so first ro means whole filesystem is ro.

> 3) Kernel warn in vfs.
> When mount the whole fs ro, and mount a subvol ro, kernel warning will
> show in fs/sync.c complaining s_umount rwsem is not locked.
> Since this remount is not called by VFS, so s_mounts rwsem is not
> correctly locked.

That's serious.

> 4) Lacks ro/rw conflicint check.
> The commit uses a trick to 'cheat' vfs about ro/rw flags to allow
> different ro/rw mount options, however this breaks the original ro/rw
> conflicting rule: one fs(even subvolume) can't be mounted rw in one place
> and mounted ro in someplace else.
> This can be triggered quite easily:
> mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
> mount -o subvol=subv,rw /dev/sda6 /mnt/other

Hm, and that's actually what the bind mount is for, and this was
mentioned in the patch changelog as a workaround.

> Also the check logical about checking the ro/rw needed to be investigated
> further. e.g. When the subvolume is mounted ro, the whole btrfs fs is mounted
> rw, so one can change the ro mounted subvolume from the mounted whole btrfs.

I agree, the semantics is not clear and the code does not cover all
cases.

> Due to the above reasons, the per-subvolume ro/rw mount options should be
> investigated further to ensure the correctness and better reverting it
> before correct implement
> (It may takes a lone time to find the right logic about ro/rw option in
> subvolume)

The different ro/rw feature is convenient, but unless the implementation
covers all the points above, I'm afraid that the revert is the best
option right now.

Ack for the revert. (Yeah I was pushing the patch upstream but ...)
