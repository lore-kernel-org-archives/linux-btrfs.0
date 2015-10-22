Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbbJVRJh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 13:09:37 -0400
Date: Thu, 22 Oct 2015 19:08:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix btrfs-convert rollback to check
 ROOT_BACKREF
Message-ID: <20151022170815.GK13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445147081-13511-1-git-send-email-bo.li.liu@oracle.com>
 <56238567.7060201@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56238567.7060201@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 18, 2015 at 07:41:27PM +0800, Qu Wenruo wrote:
> 在 2015年10月18日 13:44, Liu Bo 写道:
> > Btrfs has changed to delete subvolume/snapshot asynchronously, which means that
> > after umount itself, if we've already deleted 'ext2_saved', rollback can still
> > be completed.
> >
> > So this adds a check for ROOT_BACKREF before checking ROOT_ITEM since
> > ROOT_BACKREF is immediately not in the btree after ioctl(BTRFS_IOC_SNAP_DESTROY)
> > returns.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Looks good to me.
> 
> Although the error message for ret > 0 case can be improved a little, like:
> "unable to find convert image subvolume, maybe it's already deleted?\n".

I've adjusted the error messages.

> BTW, would you please submit a test case for fstests? It won't be a hard 
> one though.

Test added.
