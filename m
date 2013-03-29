Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab3C2RXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 13:23:20 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A6581A4C0E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 18:23:19 +0100 (CET)
Date: Fri, 29 Mar 2013 18:23:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Dilger <mike@mikedilger.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs "stuck" on
Message-ID: <20130329172309.GI29125@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130327190349.3b79c13f@hero.mikedilger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130327190349.3b79c13f@hero.mikedilger.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 07:03:49PM +1300, Mike Dilger wrote:
> I have been using it to make backups using rsync like this:
> 1) snapshot the previous backup subvolume
> 2) rsync into the new snapshot
> 3) If we are overwriting a previous backup "level", drop that previous subvolume and rename this one into it's place.
> I keep 8 levels in tower-of-hanoi strategy.  It's the same backup
> script I've used for the last 5 years, except I removed the rsync
> --link-dest and added in the btrfs snapshotting, just because dropping
> a subvolume is so damn quick compared to deleting all the files.

It is very quick to mark the snapshot deleted (compare it to adding an
item to todo vs actually doing it).

> After about 400 GB of backups taken all in the same day, but having
> already dropped probably 12 or 13 subvolumes after snapshotting, I get
> the behavior.

This implies lots of data to process during the cleaning phase.

> The behavior is:
> *) After mounting, things are usually ok for 20 seconds or so, then it starts

Unless cleaner was active, it kicks at most after 30 seconds when the
the regular transaction commit kicks in.

> *) The disk activity lite burns constantly
> *) btrfs-cleaner is fairly high up in 'top'
> *) Read/writes to the device are painfully slow

Cleaner doing its work.

> *) I cannot unmount the device, nor cleanly shutdown.

Known problem, the umount should be a bit more responsive with
https://patchwork.kernel.org/patch/2256801/

> *) Once the system froze hard, no mouse cursor movement, not even the reset button worked.

It could be the BUG_ON in btrfs_clean_old_snapshots that could happen
when there a transaction abort occurs and the filesystem turns RO --
also fixed by the patch above.

david
