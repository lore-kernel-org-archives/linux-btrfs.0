Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3J2Vdd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 17:33:33 -0400
Date: Tue, 29 Oct 2013 14:33:31 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add framework to read fs info from btrfs-control
Message-ID: <20131029213331.GC17681@lenny.home.zabbo.net>
References: <1382721007-5531-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382721007-5531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> This adds ioctl BTRFS_IOC_GET_FSIDS which reads the fs
> info through the btrfs-control

Why not use sysfs?

> +	sz_fslist_arg = sizeof(*fslist_arg);
> +	fslist_arg = memdup_user(arg, sz_fslist_arg);

Doesn't check allocation failure.

> +
> +	sz_fslist = sizeof(*fslist) * fslist_arg->count;
> +	kfree(fslist_arg);

That allocation and copy and free gets a single u64.  Use
copy_from_user() for the u64.

> +	fslist_arg = memdup_user(arg, sz_fslist_arg + sz_fslist);

Allocates an arbitrarily huge size that depends only on user input.
Doesn't check failure again.  And I bet you can scribble on kernel
memory if you wrap the size.

> +	if (copy_to_user(arg, fslist_arg, sz_fslist_arg + sz_fslist))
> +		ret = -EFAULT;

And there's no reason to buffer all this in the kernel to begin with.
Just copy_to_user() as you iterate over each fs_devices.

> +			fslist = (struct btrfs_ioctl_fslist *) fslist +
> +							sizeof(*fslist);

AKA fslist++.

- z
