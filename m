Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbbEOLTY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 07:19:24 -0400
Date: Fri, 15 May 2015 13:19:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Luke Dashjr <luke@dashjr.org>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20150515111922.GB23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201505131715.27483.luke@dashjr.org>
 <20150514140617.GY23255@twin.jikos.cz>
 <201505141627.56205.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201505141627.56205.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 04:27:54PM +0000, Luke Dashjr wrote:
> On Thursday, May 14, 2015 2:06:17 PM David Sterba wrote:
> > On Wed, May 13, 2015 at 05:15:26PM +0000, Luke Dashjr wrote:
> > > 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They
> > > can be handled in btrfs using the same code. Without this, 32-bit
> > > {ch,ls}attr fail.
> > 
> > Yes, but this has to be implemented in another way. See eg.
> > https://git.kernel.org/linus/e9750824114ff
> 
> I don't see what is different with that implementation. All f2fs_compat_ioctl 
> does is change cmd to the plain-IOC equivalent and call f2fs_ioctl with the 
> same arg (compat_ptr merely causes a cast to void* and back, which AFAIK is a 
> noop on 64-bit?). Am I missing something?

No, that's the idea. Add new calback for compat_ioctl, put it under
#ifdef CONFIG_COMPAT and do the same number switch.

> I could try to just imitate it, but 
> I'd rather know what is significant/going on to ensure I don't waste your time 
> with code I don't even properly understand myself.
> 
> Perhaps by coincidence, the patch does at least in practice work (although at 
> least `btrfs send` appears to be broken still, and I'm at a loss for how to 
> approach fixing that).

The 'receive' 32bit/64bit was broken due to size difference in the ioctl
structure that led to different ioctl. This is transparently fixed, see
BTRFS_IOC_SET_RECEIVED_SUBVOL_32 at the top of ioctl.c.

In what way is SEND broken? There are only u64/s64 members in
btrfs_ioctl_send_args, I don't see how this could break on 32/64
userspace/kernel.
