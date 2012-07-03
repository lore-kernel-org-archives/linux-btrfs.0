Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55015 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2GCQIR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 12:08:17 -0400
Date: Tue, 3 Jul 2012 12:08:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: Alexander Block <ablock84@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: update subvol_getflags/setflags to know new
 args from user
Message-ID: <20120703160814.GF6185@localhost.localdomain>
References: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1340963995-32549-2-git-send-email-liubo2009@cn.fujitsu.com>
 <CAB9VWqBnEETwZmdLV7S=m=mikpmw5JUw677aCaGFioUHkSGcsw@mail.gmail.com>
 <4FF2DFD6.2020504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FF2DFD6.2020504@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2012 at 06:04:38AM -0600, Liu Bo wrote:
> On 07/03/2012 07:27 PM, Alexander Block wrote:
> 
> > On Fri, Jun 29, 2012 at 11:59 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> >> I've modified 'btrfs subvolume list' to show a subvolume's attributes,
> >> such as readonly and default, and adopted a new structure for args for
> >> subvol_getflags/setflags.
> >>
> >> So here is the kernel side update.
> >>
> >> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/ioctl.c |  100 ++++++++++++++++++++++++++++++++++++++++-------------
> >>  fs/btrfs/ioctl.h |    5 +++
> >>  2 files changed, 80 insertions(+), 25 deletions(-)
> >>
> 
> 
> [...]
> 
> 
> >> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> >> index 3186d2d..1fa0ce2 100644
> >> --- a/fs/btrfs/ioctl.h
> >> +++ b/fs/btrfs/ioctl.h
> >> @@ -45,6 +45,11 @@ struct btrfs_ioctl_vol_args_v2 {
> >>         char name[BTRFS_SUBVOL_NAME_MAX + 1];
> >>  };
> >>
> >> +struct btrfs_ioctl_get_set_flags_args {
> >> +       __u64 objectid;
> >> +       __u64 flags;
> >> +};
> >> +
> > Shouldn't BTRFS_IOC_SUBVOL_GETFLAGS/BTRFS_IOC_SUBVOL_SETFLAGS also be
> > updated? Both still have __u64 as arguments. Also, my patches for the
> > new btrfs prop command group won't work anymore due to the change in
> > the ioctl. I'm in the middle of preparing btrfs send/receive to be
> > sent to the list...I also use the ioctls there and we should agree on
> > what to do with the ioctls before I send the patches out.
> 
> 
> Just drop this patch, I've discussed with Ilya about it (and also CCed you).
> 
> If we've more properties pending to set/get, 'btrfs property' will be better.
> 
> So please go on your work, I'll try to rebase my patch on yours.
> 

I've dropped the entire series from btrfs-next because without this patch the
other one fails to build without __btrfs_subvol_get_root.  Resend if you want
the other patches included.  Thanks,

Josef
