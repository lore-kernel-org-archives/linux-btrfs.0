Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38428 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbbJ2Tgj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 15:36:39 -0400
From: Thomas Rohwer <tr@ohwer.de>
Message-ID: <56327543.5070308@gmail.com>
Date: Thu, 29 Oct 2015 20:36:35 +0100
MIME-Version: 1.0
To: dsterba@suse.cz, Luke Dashjr <luke@dashjr.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION}
 in btrfs_ioctl
References: <201505131715.27483.luke@dashjr.org> <201505141627.56205.luke@dashjr.org> <20150515111922.GB23255@twin.jikos.cz> <201510290822.35540.luke@dashjr.org> <20151029143932.GZ13624@twin.jikos.cz>
In-Reply-To: <20151029143932.GZ13624@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I suggest to add an anonymous union and add a u64 member that would
> force the type width:
>
> struct btrfs_ioctl_send_args {
>          __s64 send_fd;                  /* in */
>          __u64 clone_sources_count;      /* in */
> 	union {
> 		__u64 __user *clone_sources;    /* in */
> 		u64 __pointer_alignment;
> 	};
>          __u64 parent_root;              /* in */
>          __u64 flags;                    /* in */
>          __u64 reserved[4];              /* in */
> };

I am no expert, but would this change alone modify the user space ABI of a 32-bit Linux kernel?
I.e. people in the (presumably currently working) btrfs-send situation (32-bit) user space/32-bit kernel
would have to upgrade user space tools and kernel at the same time. Otherwise, they will encounter a non-working setup.
I think, my suggested patch does not change any working ABI, and no change to the user
space tools are necessary.


Sincerely,

Thomas Rohwer

