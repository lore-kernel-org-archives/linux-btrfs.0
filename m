Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbcCUI3p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 04:29:45 -0400
Subject: Re: [PATCH 1/1] Btrfs: Code Cleanup
To: Flex Liu <fliu@novell.com>, David Sterba <dsterba@suse.com>
References: <1458457871-25512-1-git-send-email-fliu@novell.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        Petr Tesarik <ptesarik@suse.com>, Flex Liu <fliu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56EFB0EE.6030605@oracle.com>
Date: Mon, 21 Mar 2016 16:29:34 +0800
MIME-Version: 1.0
In-Reply-To: <1458457871-25512-1-git-send-email-fliu@novell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Flex,


> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 366b335..5c16f04 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2325,7 +2325,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>   	if (seeding_dev) {
>   		sb->s_flags &= ~MS_RDONLY;

  This is not undone in the failure code. Theoretically
  it should report error during unmount, did you notice ?

  (in general, $subject can be more specific).

Thanks, Anand

>   		ret = btrfs_prepare_sprout(root);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret) {
> +			btrfs_abort_transaction(trans, root, ret);
> +			goto error_trans;
> +		}
>   	}
>
>   	device->fs_devices = root->fs_info->fs_devices;
>
