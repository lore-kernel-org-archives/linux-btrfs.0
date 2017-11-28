Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55315 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752646AbdK1TYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:24:34 -0500
Date: Tue, 28 Nov 2017 20:22:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] retry write on error
Message-ID: <20171128192236.GE3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 05:35:51PM -0700, Liu Bo wrote:
> If the underlying protocal doesn't support retry and there are some
> transient errors happening somewhere in our IO stack, we'd like to
> give an extra chance for IO.  Or sometimes you see btrfs reporting
> 'wrr 1 flush 0 read 0 blabla' but the disk drive is 100% good, this
> retry may help a bit.

A limited number of retries may make sense, though I saw some long
stalls after retries on bad disks. Tracking the retries would be a good
addition to the dev stats, ie. a soft error but still worth reporting.

> In btrfs, read retry is handled in bio_readpage_error() with the retry
> unit being page size, for write retry however, we're going to do it in
> a different way, as a write may consist of several writes onto
> different stripes, retry write needs to be done right after the IO on
> each stripe completes and arrives at endio.
> 
> Patch 1-3 are the implementation of retry write on error for
> non-raid56 profile.  Patch 4-6 are for raid56 profile.  Both raid56
> and non-raid56 shares one retry function helper.
> 
> Patch 3 does retry sector by sector, but since this patch set doesn't
> included badblocks support, patch 7 changes it back to retry the whole
> bio.  (I didn't fold patch 7 to patch 3 in the hope of just reverting
> patch 7 once badblocks support is done, but I'm open to it.)

What does 'badblocks' refer to? I know about the badblocks utility that
find and reportts bad blocks, possibly ext2 understands that and avoids
allocating them. Btrfs does not have such support.
