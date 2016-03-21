Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbcCUTXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 15:23:50 -0400
Date: Mon, 21 Mar 2016 19:44:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
Message-ID: <20160321184444.GE8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
 <20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
 <20160321175808.GD8095@twin.jikos.cz>
 <20160321180800.lq7q7pqul7uyfww7@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160321180800.lq7q7pqul7uyfww7@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 02:08:00PM -0400, Chris Mason wrote:
> On Mon, Mar 21, 2016 at 06:58:08PM +0100, David Sterba wrote:
> > On Mon, Mar 21, 2016 at 01:51:07PM -0400, Chris Mason wrote:
> > > On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > > 
> > > > If the lower or upper directory of an overlayfs mount belong to a btrfs
> > > > file system and we fsync the file through the overlayfs' merged directory
> > > > we ended up accessing an inode that didn't belong to btrfs as if it were
> > > > a btrfs inode at btrfs_sync_file() resulting in a crash like the following:
> > > 
> > > Thanks Filipe, I'll put this in a second pull this week, even if its the
> > > only patch in it ;)
> > 
> > I can send you more that I consider relevant for 4.6, low-risk subset of
> > what's in the misc-4.6 branch.
> 
> You had sent the list last week, I was going to start with that and look
> on the list for anything else urgent.  If you have them in a git branch
> already I won't say no ;)

Meanwhile I had a chance to review and let them through tests so I think
it's time for a pull request.
