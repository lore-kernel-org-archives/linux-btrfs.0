Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaBNQP1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 11:15:27 -0500
Date: Fri, 14 Feb 2014 17:15:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Possible to wait for snapshot deletion?
Message-ID: <20140214161526.GU16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 08:02:43PM +0100, Kai Krakow wrote:
> Is it technically possible to wait for a snapshot completely purged from 
> disk? I imagine an option like "--wait" for btrfs delete subvolume.

I have the patch WIP, will look at it again.

> This would fit some purposes I'm planning to implement:
> 
> * In a backup scenario have a subprocess which deletes snapshots one by one,
>   starting with the oldest. If free space raises above a certain threshold,
>   pause the subprocess. If number of kept snapshots falls below a certain
>   threshold, exit the subprocess. When the backup job finished, it joins the
>   subprocess to wait for a pending subvolume deletion if any, then syncs the
>   filesystem and waits some grace time for uncommitted writes, then shuts
>   the system down or hibernates it.
> 
> * Wait for pending background subvolume deletion before putting the system
>   to sleep.
> 
> * Get better control of cron jobs working with subvolumes so jobs either do
>   not overlap or do not put too much parallel work on the file system.

These usecases should be covered by the 'wait' command.

> If btrfs is shut down improperly, already deleted 
> subvolume entries may reappear in their directories. The deletion is not 
> gracefully resumed. Since deletion of subvolumes/snapshots can take hours, 
> this is a problem for systems that are not guaranteed to be up all the time 
> or suffer from disconnected power, especially if multiple snapshots are 
> being deleted at once. With an option to wait, a script managing snapshot 
> deletion could more gracefully resume its job.

As mentioned down the thread, next progs release will be able to force a
transaction commit when the subvoulme is deleted.
