Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47763 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753111AbdI0OSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 10:18:36 -0400
Date: Wed, 27 Sep 2017 16:17:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: take the error path out if
 btrfs_attach_transaction() fails
Message-ID: <20170927141701.GI31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927095052.22663-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170927095052.22663-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 05:50:52PM +0800, Anand Jain wrote:
> btrfs_init_new_device() calls btrfs_attach_transaction() to
> commit sys chunks, however take the error path out if it fails.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index fad3b10a1f81..b526d13a74da 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2494,7 +2494,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  		if (IS_ERR(trans)) {
>  			if (PTR_ERR(trans) == -ENOENT)
>  				return 0;
> -			return PTR_ERR(trans);
> +			ret = PTR_ERR(trans);
> +			goto error_sysfs;

The label is introduced by another patch, please resend the whole
patchset, I've seen several iterations and feedback from various people
and I'm not sure I'm looking at the latest version.

Regarding error handling in btrfs_init_new_device, the seeding device
makes it hard to read. This patch would lead to a double unlock of
uuid_mutex and sb::s_umount, because the label error_sysfs will continue
to do the cleanups, that were already partially done in the containing
'if (seeding_dev)' block where the test fails.

I'd suggest to first get rid of the in-place returns and add necessary
labels or separate exit sequences and then address the new error
handling.
