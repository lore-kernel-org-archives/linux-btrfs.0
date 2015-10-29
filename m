Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:35103 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbJ2IcO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 04:32:14 -0400
From: Luke Dashjr <luke@dashjr.org>
To: dsterba@suse.cz
Subject: Re: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Thu, 29 Oct 2015 08:22:34 +0000
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201505131715.27483.luke@dashjr.org> <201505141627.56205.luke@dashjr.org> <20150515111922.GB23255@twin.jikos.cz>
In-Reply-To: <20150515111922.GB23255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510290822.35540.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, May 15, 2015 11:19:22 AM David Sterba wrote:
> On Thu, May 14, 2015 at 04:27:54PM +0000, Luke Dashjr wrote:
> > On Thursday, May 14, 2015 2:06:17 PM David Sterba wrote:
> > > On Wed, May 13, 2015 at 05:15:26PM +0000, Luke Dashjr wrote:
> > > > 32-bit ioctl uses these rather than the regular FS_IOC_* versions.
> > > > They can be handled in btrfs using the same code. Without this,
> > > > 32-bit {ch,ls}attr fail.
> > > 
> > > Yes, but this has to be implemented in another way. See eg.
> > > https://git.kernel.org/linus/e9750824114ff
> > 
> > I don't see what is different with that implementation. All
> > f2fs_compat_ioctl does is change cmd to the plain-IOC equivalent and
> > call f2fs_ioctl with the same arg (compat_ptr merely causes a cast to
> > void* and back, which AFAIK is a noop on 64-bit?). Am I missing
> > something?
> 
> No, that's the idea. Add new calback for compat_ioctl, put it under
> #ifdef CONFIG_COMPAT and do the same number switch.

Ok, someone else explained this to me. Please let me know if PATCHv2 (sent 
separately) does not address the needed changes.

> > I could try to just imitate it, but
> > I'd rather know what is significant/going on to ensure I don't waste your
> > time with code I don't even properly understand myself.
> > 
> > Perhaps by coincidence, the patch does at least in practice work
> > (although at least `btrfs send` appears to be broken still, and I'm at a
> > loss for how to approach fixing that).
> 
> The 'receive' 32bit/64bit was broken due to size difference in the ioctl
> structure that led to different ioctl. This is transparently fixed, see
> BTRFS_IOC_SET_RECEIVED_SUBVOL_32 at the top of ioctl.c.
> 
> In what way is SEND broken? There are only u64/s64 members in
> btrfs_ioctl_send_args, I don't see how this could break on 32/64
> userspace/kernel.

I've investigated this now, and it seems to be the pointer-type clone_sources 
member of struct btrfs_ioctl_send_args. I can't think of a perfect way to fix 
this, but it might not be *too* ugly to:
- replace the current clone_sources with a u64 that must always be (u64)-1;
  this causes older kernels to error cleanly if called with a new ioctl data
- use the top 1 or 2 bits of flags to indicate sizeof(void*) as it appears to
  userspace OR just use up reserved[0] for pointer size:
      io_send.ptr_size = sizeof(void*);
- replace one of the reserved fields with the new clone_sources

The way it was done for receive seems like it might not work for non-x86 
compat interfaces (eg, MIPS n32) - but I could be wrong.

Thoughts?

Luke
