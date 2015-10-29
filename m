Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:59102 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbbJ2TC0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 15:02:26 -0400
From: Luke Dashjr <luke@dashjr.org>
To: dsterba@suse.cz
Subject: Re: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Thu, 29 Oct 2015 19:01:50 +0000
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201505131715.27483.luke@dashjr.org> <201510290822.35540.luke@dashjr.org> <20151029143932.GZ13624@twin.jikos.cz>
In-Reply-To: <20151029143932.GZ13624@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510291901.52565.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, October 29, 2015 2:39:32 PM David Sterba wrote:
> On Thu, Oct 29, 2015 at 08:22:34AM +0000, Luke Dashjr wrote:
> > > In what way is SEND broken? There are only u64/s64 members in
> > > btrfs_ioctl_send_args, I don't see how this could break on 32/64
> > > userspace/kernel.
> > 
> > I've investigated this now, and it seems to be the pointer-type
> > clone_sources member of struct btrfs_ioctl_send_args. I can't think of a
> > perfect way to fix this, but it might not be *too* ugly to:
> > - replace the current clone_sources with a u64 that must always be
> > (u64)-1;
> > 
> >   this causes older kernels to error cleanly if called with a new ioctl
> >   data
> > 
> > - use the top 1 or 2 bits of flags to indicate sizeof(void*) as it
> > appears to
> > 
> >   userspace OR just use up reserved[0] for pointer size:
> >       io_send.ptr_size = sizeof(void*);
> > 
> > - replace one of the reserved fields with the new clone_sources
> 
> All the change seem too intrusive or not so easy to use.
> 
> I suggest to add an anonymous union and add a u64 member that would
> force the type width:
> 
> struct btrfs_ioctl_send_args {
>         __s64 send_fd;                  /* in */
>         __u64 clone_sources_count;      /* in */
> 	union {
> 		__u64 __user *clone_sources;    /* in */
> 		u64 __pointer_alignment;
> 	};
>         __u64 parent_root;              /* in */
>         __u64 flags;                    /* in */
>         __u64 reserved[4];              /* in */
> };

What guarantees the union to position clone_sources in the LSB of 
__pointer_alignment (rather than the MSB side)?

> > The way it was done for receive seems like it might not work for non-x86
> > compat interfaces (eg, MIPS n32) - but I could be wrong.
> 
> Possible, but I don't see right now how it would not work on eg. mips32.
> unless sizeof(long) is 8 bytes there and CONFIG_64BIT is not defined.

n32 is a MIPS64 ABI, like the new x32 ABI for x86_64 machines, so I would 
expect sizeof(long) to be 8 bytes, and am uncertain of if this implies any 
particular alignment. (But I don't have any MIPS systems, so this isn't 
something I'm too concerned with myself.)

Luke
