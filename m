Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbcCXPDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 11:03:39 -0400
Date: Thu, 24 Mar 2016 16:03:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Flex Liu <fliu@novell.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Petr Tesarik <ptesarik@suse.com>,
        Flex Liu <fliu@suse.com>
Subject: Re: [PATCH 1/1] Btrfs: Code Cleanup
Message-ID: <20160324150307.GR29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458457871-25512-1-git-send-email-fliu@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458457871-25512-1-git-send-email-fliu@novell.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2016 at 03:11:11PM +0800, Flex Liu wrote:
> From: Flex Liu <fliu@suse.com>
> 
> In fs/btrfs/volumes.c:2328
> 
>         if (seeding_dev) {
>                 sb->s_flags &= ~MS_RDONLY;
>                 ret = btrfs_prepare_sprout(root);
>                 BUG_ON(ret); /* -ENOMEM */
>         }
> 
> the error code would be return from:
> 
>         fs_devs = kzalloc(sizeof(*fs_devs), GFP_NOFS);
>         if (!fs_devs)
>                 return ERR_PTR(-ENOMEM);

> Insufficient memory in btrfs would let the kernel panic, it suboptimal.
> instead, we should return the error code in btrfs_init_new_device to
> btrfs_ioctl.
> 
> Hello kernel list.
> This is my first patch for kernel, so if I missed some of the guidelines,
> please be patient :) I hope everything is explained in the commit message.

So a few comments:

- the subject line should say something like

  "handle errors in btrfs_init_new_device"
  or "replace BUG_ON with proper error handling",

  because it's not a code cleanup in the sense we commonly use

- you don't need to quote the code in the changelog, we can see it in
  the sources (unless you want to point out something very specific that
  might not be obvious)

> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2325,7 +2325,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	if (seeding_dev) {
>  		sb->s_flags &= ~MS_RDONLY;
>  		ret = btrfs_prepare_sprout(root);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret) {
> +			btrfs_abort_transaction(trans, root, ret);

The transaction abort seems a bit heavy as it will take down the whole
filesystem. It's called from the device add ioctl, this is a restartable
operation.

Unfortunatelly btrfs_prepare_sprout is called after the transaction
start so btrfs_abort_transaction must be called. To avoid it, the code
would need to be reorganized, so the memory allocations happen in
advance.

Fixing the error handling might need more patches. btrfs_prepare_sprout
can be split into parts that do just allocations and initialization and
do not touch the filesystem state (like dropping the seeding flag).

The first part will hopefully cover all failure possibilities, before
the transaction stargs, the second shall not fail at all and the error
checking can be avoided completely.
