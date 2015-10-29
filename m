Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:39709 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbbJ2UGy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 16:06:54 -0400
From: Luke Dashjr <luke@dashjr.org>
To: Thomas Rohwer <tr@ohwer.de>
Subject: Re: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Thu, 29 Oct 2015 20:04:58 +0000
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201505131715.27483.luke@dashjr.org> <20151029143932.GZ13624@twin.jikos.cz> <56327543.5070308@gmail.com>
In-Reply-To: <56327543.5070308@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201510292005.00597.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, October 29, 2015 7:36:35 PM Thomas Rohwer wrote:
> > I suggest to add an anonymous union and add a u64 member that would
> > force the type width:
> > 
> > struct btrfs_ioctl_send_args {
> > 
> >          __s64 send_fd;                  /* in */
> >          __u64 clone_sources_count;      /* in */
> > 	
> > 	union {
> > 	
> > 		__u64 __user *clone_sources;    /* in */
> > 		u64 __pointer_alignment;
> > 	
> > 	};
> > 	
> >          __u64 parent_root;              /* in */
> >          __u64 flags;                    /* in */
> >          __u64 reserved[4];              /* in */
> > 
> > };
> 
> I am no expert, but would this change alone modify the user space ABI of a
> 32-bit Linux kernel? I.e. people in the (presumably currently working)
> btrfs-send situation (32-bit) user space/32-bit kernel would have to
> upgrade user space tools and kernel at the same time. Otherwise, they will
> encounter a non-working setup.

Yes, it would, but this appears to already be the case for btrfs-progs in 
general.

> I think, my suggested patch does not change any working ABI, and no change
> to the user space tools are necessary.

Don't the user space tools need to call a different ioctl?

Luke
