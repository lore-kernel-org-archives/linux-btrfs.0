Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3JWChK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 22:37:10 -0400
Date: Wed, 23 Oct 2013 10:36:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH v7 00/13] Online(inband) data deduplication
Message-ID: <20131023023643.GC22893@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
 <20131022185524.GA30512@ohm.rr44.fr>
 <20131023022616.GB22893@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131023022616.GB22893@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Cced: David)

On Wed, Oct 23, 2013 at 10:26:17AM +0800, Liu Bo wrote:
> On Tue, Oct 22, 2013 at 08:55:24PM +0200, Aurelien Jarno wrote:
> > Hi,
> > 
> > On Mon, Oct 14, 2013 at 12:59:42PM +0800, Liu Bo wrote:
> > > Data deduplication is a specialized data compression technique for eliminating
> > > duplicate copies of repeating data.[1]
> > > 
> > > This patch set is also related to "Content based storage" in project ideas[2].
> > > 
> > > PATCH 1 is a hang fix with deduplication on, but it's also useful without
> > > dedup in practice use.
> > > 
> > > PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
> > > uncovered by the dedup feature.
> > > 
> > > PATCH 4 is a speed-up improvement, which is about dedup and quota.
> > > 
> > > PATCH 5-8 is the preparation for dedup implementation.
> > > 
> > > PATCH 9 shows how we implement dedup feature.
> > > 
> > > PATCH 10 fixes a backref walking bug with dedup.
> > > 
> > > PATCH 11 fixes a free space bug of dedup extents on error handling.
> > > 
> > > PATCH 12 fixes a race bug on dedup writes.
> > > 
> > > PATCH 13 adds the ioctl to control dedup feature.
> > > 
> > > And there is also a btrfs-progs patch(PATCH 14) which involves all details of
> > > how to control dedup feature.
> > > 
> > > I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
> > > mount and scratch_mount.
> > > 
> > > TODO:
> > > * a bit-to-bit comparison callback.
> > > 
> > > All comments are welcome!
> > > 
> > 
> > Thanks for this new patchset. I have tested it on top of kernel 3.12-rc6
> > and it worked correctly, although I haven't used it on production
> > servers given the bit-to-bit comparison callback isn't implemented yet.
> 
> Many thanks for testing this!
> 
> It's not yet proper for production server use until we solve the
> metadata reservation problems(I'm working on it right now).
> 
> > 
> > I have a few comments on the ioctl to control the dedup feature.
> > Basically it is used to enable the deduplication, to switch it on or off
> > and to select the blocksize. Couldn't it be implemented as a mount
> > option instead like for the other btrfs features? The dedup tree would
> > be created the first time the mount option is activated, and the on/off
> > would be controlled by the presence of the dedup mount flag. The
> > blocksize could be specified with the value appended to the dedup
> > option, for example dedup=8192.
> 
> In the previous version patch set, actually I chose to use mount options
> to provide a flexible control of dedup, but as thread[1] shows, David
> thinked that mount options is too heavy to use as it cannot be removed
> once it's merged.
> 
> [1]: http://www.spinics.net/lists/linux-btrfs/msg27294.html
> 
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-liubo
