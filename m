Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbcD1KFP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 06:05:15 -0400
Date: Thu, 28 Apr 2016 12:05:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not return EBUSY on concurrent subvolume mounts
Message-ID: <20160428100501.GU29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1461770076-13000-1-git-send-email-dsterba@suse.com>
 <20160427232217.GL15822@localhost.localdomain>
 <20160428091220.GT29353@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160428091220.GT29353@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:12:20AM +0200, David Sterba wrote:
> On Wed, Apr 27, 2016 at 04:22:17PM -0700, Liu Bo wrote:
> > On Wed, Apr 27, 2016 at 05:14:36PM +0200, David Sterba wrote:
> > > A user reported mount failures with EBUSY during boot, there's root
> > > partition and many subvolumes, mounted via /etc/fstab.
> > > 
> > > The failure depends on timing, when multiple subvolumes reach the code
> > > between superblock creation in RO mode, while the subvolumes are RW.
> > > This discrepancy leads to EBUSY and the code has been there since ages.
> > > 
> > > If the subvolumes are mounted after a short delay, there's no EBUSY.
> > > There's no missing locking, the supreblock creation is atomic and the
> > > error code seems to be just artificial. We support different RO/RW
> > > mounts in mount_subvol and do the relevant adjustments if the flags do
> > > not match.
> > 
> > Looks good to me.
> > 
> > Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > But What I'm worrying about is that mount_subvol() will help subvolume
> > mounting get correct mount flags by calling btrfs_remount(), and
> > btrfs_remount() can remove sb->s_flags's MS_RDONLY.  In all syscall cases
> > it's ok as we have mnt->mnt_flags, but for btrfs's add_dev ioctl, we
> > don't check mnt_want_write_file() while btrfs's rm_dev ioctl does the
> > check, should we add that for add_dev ioctl?
> 
> That's right, I have patches to fix that and will send them.

So, after a bit of refreshing, the patches are not finished, as add
device must respect read only mount and seeding devices, that can turn
RO to RW. And I got stuck in the device replace case, where we have to
do the drop_mnt_write some time later. Not sure when I'll get to it,
pushed to my git repos, branch fix/ioctl-want-write-local .
