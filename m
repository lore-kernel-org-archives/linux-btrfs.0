Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23884 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935470Ab3DPDL1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 23:11:27 -0400
Date: Tue, 16 Apr 2013 11:11:42 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ochi <ochi@arcor.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Activating space_cache after read-only snapshots without
 space_cache have been taken
Message-ID: <20130416031141.GB22531@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <516C9B43.7040605@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516C9B43.7040605@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 02:28:51AM +0200, Ochi wrote:
> Hello everyone,
> 
> I've ran into problems with _very_ slow unmounting of my
> btrfs-formatted "backup" volume. I have a suspicion what might be
> the cause but maybe someone with more experience with the btrfs code
> could enlighten me whether it is actually correct.
> 
> The situation is the following: I have created a backup-volume to
> which I regularly rsync a backup of my system into a subvolume.
> After rsync'ing, I take a _read-only_ snapshot of that subvolume
> with a timestamp added to its name.
> 
> Now at the time I started using this backup volume, I was _not_
> using the space_cache mount option and two read-only snapshots were
> taken during this time. Then I started using the space_cache option
> and continued doing snapshots.
> 
> A bit later, I started having very long lags when unmounting the
> backup volume (both during shutdown and when unmounting manually). I
> scrubbed and fsck'd the volume but this didn't show any errors.
> Defragmenting the root and subvolumes took a long time but didn't
> improve the situation much.

So are you using '-o nospace_cache' when creating two RO snapshots?

> 
> Now I started having the suspicion that maybe the space cache
> possibly couldn't be written to disk for the readonly
> subvolumes/snapshots that were created during the time when I wasn't
> using the space_cache option, forcing the cache to be rebuilt every
> time.
> 
> Clearing the cache didn't help. But when I deleted the two snapshots
> that I think were taken during the time without the mount option,
> the unmounting time seems to have improved considerably.

I don't know why this happens, but maybe you can observe the umount process's
very slow behaviour by using 'cat /proc/{umount-pid}/stack' or 'perf top'.

thanks,
liubo

> 
> I will have to observe whether unmounting stays quick now but my
> question is whether it is possible that the read-only snapshots
> taken during the time when I wasn't using space_cache might actually
> have been the culprits.
> 
> Best,
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
