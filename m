Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbbJ2Ok7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 10:40:59 -0400
Date: Thu, 29 Oct 2015 15:39:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Luke Dashjr <luke@dashjr.org>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20151029143932.GZ13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201505131715.27483.luke@dashjr.org>
 <201505141627.56205.luke@dashjr.org>
 <20150515111922.GB23255@twin.jikos.cz>
 <201510290822.35540.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201510290822.35540.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 08:22:34AM +0000, Luke Dashjr wrote:
> > > I don't see what is different with that implementation. All
> > > f2fs_compat_ioctl does is change cmd to the plain-IOC equivalent and
> > > call f2fs_ioctl with the same arg (compat_ptr merely causes a cast to
> > > void* and back, which AFAIK is a noop on 64-bit?). Am I missing
> > > something?
> > 
> > No, that's the idea. Add new calback for compat_ioctl, put it under
> > #ifdef CONFIG_COMPAT and do the same number switch.
> 
> Ok, someone else explained this to me. Please let me know if PATCHv2 (sent 
> separately) does not address the needed changes.

Patch is ok, thanks.

> > > I could try to just imitate it, but
> > > I'd rather know what is significant/going on to ensure I don't waste your
> > > time with code I don't even properly understand myself.
> > > 
> > > Perhaps by coincidence, the patch does at least in practice work
> > > (although at least `btrfs send` appears to be broken still, and I'm at a
> > > loss for how to approach fixing that).
> > 
> > The 'receive' 32bit/64bit was broken due to size difference in the ioctl
> > structure that led to different ioctl. This is transparently fixed, see
> > BTRFS_IOC_SET_RECEIVED_SUBVOL_32 at the top of ioctl.c.
> > 
> > In what way is SEND broken? There are only u64/s64 members in
> > btrfs_ioctl_send_args, I don't see how this could break on 32/64
> > userspace/kernel.
> 
> I've investigated this now, and it seems to be the pointer-type clone_sources 
> member of struct btrfs_ioctl_send_args. I can't think of a perfect way to fix 
> this, but it might not be *too* ugly to:
> - replace the current clone_sources with a u64 that must always be (u64)-1;
>   this causes older kernels to error cleanly if called with a new ioctl data
> - use the top 1 or 2 bits of flags to indicate sizeof(void*) as it appears to
>   userspace OR just use up reserved[0] for pointer size:
>       io_send.ptr_size = sizeof(void*);
> - replace one of the reserved fields with the new clone_sources

All the change seem too intrusive or not so easy to use.

I suggest to add an anonymous union and add a u64 member that would
force the type width:

struct btrfs_ioctl_send_args {
        __s64 send_fd;                  /* in */
        __u64 clone_sources_count;      /* in */
	union {
		__u64 __user *clone_sources;    /* in */
		u64 __pointer_alignment;
	};
        __u64 parent_root;              /* in */
        __u64 flags;                    /* in */
        __u64 reserved[4];              /* in */
};

> The way it was done for receive seems like it might not work for non-x86 
> compat interfaces (eg, MIPS n32) - but I could be wrong.

Possible, but I don't see right now how it would not work on eg. mips32.
unless sizeof(long) is 8 bytes there and CONFIG_64BIT is not defined.
