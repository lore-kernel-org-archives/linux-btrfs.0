Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13646 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283AbcCUSIO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 14:08:14 -0400
Date: Mon, 21 Mar 2016 14:08:00 -0400
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <miklos@szeredi.hu>
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
Message-ID: <20160321180800.lq7q7pqul7uyfww7@floor.thefacebook.com>
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
 <20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
 <20160321175808.GD8095@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160321175808.GD8095@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 06:58:08PM +0100, David Sterba wrote:
> On Mon, Mar 21, 2016 at 01:51:07PM -0400, Chris Mason wrote:
> > On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > > 
> > > If the lower or upper directory of an overlayfs mount belong to a btrfs
> > > file system and we fsync the file through the overlayfs' merged directory
> > > we ended up accessing an inode that didn't belong to btrfs as if it were
> > > a btrfs inode at btrfs_sync_file() resulting in a crash like the following:
> > 
> > Thanks Filipe, I'll put this in a second pull this week, even if its the
> > only patch in it ;)
> 
> I can send you more that I consider relevant for 4.6, low-risk subset of
> what's in the misc-4.6 branch.

You had sent the list last week, I was going to start with that and look
on the list for anything else urgent.  If you have them in a git branch
already I won't say no ;)

-chris

