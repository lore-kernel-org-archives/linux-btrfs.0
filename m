Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbbJ2P1E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 11:27:04 -0400
Date: Thu, 29 Oct 2015 16:25:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Thomas Rohwer <tr@ohwer.de>
Cc: Luke Dashjr <luke@dashjr.org>, dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20151029152536.GA13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201505131715.27483.luke@dashjr.org>
 <201505141627.56205.luke@dashjr.org>
 <20150515111922.GB23255@twin.jikos.cz>
 <201510290822.35540.luke@dashjr.org>
 <56320B79.9090207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56320B79.9090207@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 01:05:13PM +0100, Thomas Rohwer wrote:
> Investigating the source, I noticed that probably the problem is the member clone_sources in the structure

That's, right. Yet another thing to keep in mind when designing ioctls.

> struct btrfs_ioctl_send_args {
>    __s64 send_fd;      /* in */
>    __u64 clone_sources_count;  /* in */
>    __u64 __user *clone_sources;  /* in */
>    __u64 parent_root;    /* in */
>    __u64 flags;      /* in */
>    __u64 reserved[4];    /* in */
> };
> 
> in include/uapi/linux/btrfs.h and the missing adaption code in
> fs/btrfs/ioctl.c. The member clone_sources is only 32 bit wide in case
> of 32 bit user space.  For the ioctl RECEIVED_SUBVOL somebody already
> added code for the in this case also necessary translation. I took
> this as a template and wrote a patch (see below). The patch compiles
> and with the new kernel I seem to get valid data with send (I have to
> read it back yet, but I get about the expected amount and structure).

I'm not yet sure if this is the right approach, but I'm still
considering it. My suggestion is to add the union and force the width.
In case of the receive subvol this was not possible because it was
around an external structure.

The basic difference if we use the same structure definition, let the
compiler pick the pointer type width, and do the conversion in kernel
transparently (ie. the RECEIVED_SUBVOL workaround), or if we patch the
structure so the pointer magic happens in the userspace.

> This is a proof of concept patch; for example the compiler currently warns for
>   (args64->clone_sources = (__u64*)args32->clone_sources;
> and I would have to investigate how to properly convert the pointer.

args64->clone_sources = (__u64*)(long)args32->clone_sources;

should work.

> Further there are probably some issues with the formating of the source code.

Yeah there are some, but at this point we're not sure what's the right
approach so don't worry.
