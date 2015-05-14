Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:47420 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775AbbENQ17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 12:27:59 -0400
From: Luke Dashjr <luke@dashjr.org>
To: dsterba@suse.cz
Subject: Re: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Thu, 14 May 2015 16:27:54 +0000
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, trivial@kernel.org
References: <201505131715.27483.luke@dashjr.org> <20150514140617.GY23255@twin.jikos.cz>
In-Reply-To: <20150514140617.GY23255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201505141627.56205.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, May 14, 2015 2:06:17 PM David Sterba wrote:
> On Wed, May 13, 2015 at 05:15:26PM +0000, Luke Dashjr wrote:
> > 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They
> > can be handled in btrfs using the same code. Without this, 32-bit
> > {ch,ls}attr fail.
> 
> Yes, but this has to be implemented in another way. See eg.
> https://git.kernel.org/linus/e9750824114ff

I don't see what is different with that implementation. All f2fs_compat_ioctl 
does is change cmd to the plain-IOC equivalent and call f2fs_ioctl with the 
same arg (compat_ptr merely causes a cast to void* and back, which AFAIK is a 
noop on 64-bit?). Am I missing something? I could try to just imitate it, but 
I'd rather know what is significant/going on to ensure I don't waste your time 
with code I don't even properly understand myself.

Perhaps by coincidence, the patch does at least in practice work (although at 
least `btrfs send` appears to be broken still, and I'm at a loss for how to 
approach fixing that).

Luke
