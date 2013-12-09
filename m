Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab3LIXcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 18:32:47 -0500
Date: Tue, 10 Dec 2013 00:32:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
Message-ID: <20131209233245.GF10658@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
 <20131129013638.01ede78a@natsu>
 <5297F633.8090100@cn.fujitsu.com>
 <20131129173744.GP25312@suse.cz>
 <529C4CB9.8020403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <529C4CB9.8020403@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 02, 2013 at 05:02:49PM +0800, Wang Shilong wrote:
> >So an enahced interface could look like this:
> >
> >subvol delete:
> >--commit-each - run the ioc sync/wait ioctl after each delete ioctl
> >--commit-after - dtto but sync/wait after all are deleted
> >--wait-for-cleanup - wait until all given subvols are cleaned
> >
> >'filesystem sync' exteded to wait for subvol cleanup has following
> >cases:
> >- wait for a specific subvolume to be cleaned
> >- wait for all currently deleted, do not care if more subvols are
> >   deleted in the meantime
> >- wait until there are no subvolumes left to clean
> I think it is unnecessary to add such options for 'filesystem sync'.
> we may wait a long time until all subvolume deletion are finished as
> async subvolume deletion is implemented in cleaner thread.:-)

I mean that 'filesystem sync' will stay as it is now, but will be
enhanced with a few options to further specify what else should be
synced.

The difference is that the wait/sync is not tied to the 'subvol delete'
operation. I start to think that a new 'filesystem' subcommand would be
suitable for that, instead of 'fi sync'.

> Miao also pointed out that only if we are running out of space, waiting
> subvolume deletion finished will make sense, our opinion is not to disturb
> 'filesystem sync' .
> 
> What do you think ? :-)

I agree with that.
