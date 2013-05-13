Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3EMQKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 12:10:37 -0400
Date: Mon, 13 May 2013 18:10:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add ioctl to wait for qgroup rescan completion
Message-ID: <20130513161034.GQ16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1367867657-4630-2-git-send-email-list.btrfs@jan-o-sch.net>
 <20130506212039.GD16456@twin.jikos.cz>
 <51889C68.2080806@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51889C68.2080806@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 07, 2013 at 08:17:12AM +0200, Jan Schmidt wrote:
> On Mon, May 06, 2013 at 23:20 (+0200), David Sterba wrote:
> > On Mon, May 06, 2013 at 09:14:17PM +0200, Jan Schmidt wrote:
> >> --- a/include/uapi/linux/btrfs.h
> >> +++ b/include/uapi/linux/btrfs.h
> >> @@ -530,6 +530,7 @@ struct btrfs_ioctl_send_args {
> >>  			       struct btrfs_ioctl_quota_rescan_args)
> >>  #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
> >>  			       struct btrfs_ioctl_quota_rescan_args)
> >> +#define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
> > 
> > Why do you need an ioctl when the same can be achieved by polling the
> > RESCAN_STATUS value ? The code does not anything special that has to be
> > done within kernel.
> 
> It's because I don't like polling :-) A rescan can take hours to complete, and
> you wouldn't like to see one ioctl per second for such a period either, I guess.
> (Plus: Everybody would lose like .9 seconds for each run of the xfstest I'm
> writing - accumulates to ages at least!)

> If you're worried about ioctl numbers, we could turn it into flags for
> BTRFS_IOC_QUOTA_RESCAN, but I don't see we're short on ioctl numbers yet.

Nah, not yet :)

A long operation? Then you can poll it every minute, with a configurable
polling interval of course. I don't see what's wrong with polling here,
the key information is provided and accessible.

Also, I don't like to see adding extra 32 bytes (struct completion) to
btrfs_fs_info when the rescan operation is going to be used very rarely.
(The long-term plan is to reduce size of this oversized structure.)

> The reason why I chose a separate ioctl is that it is more like an
> attach operation to support both, specifying it when starting a fresh
> scan and waiting for a scan that's already running. I find it more
> intuitive to have it separate.

I agree it's separate, from the user's side. But not necessarily from
the implementation side.

david
