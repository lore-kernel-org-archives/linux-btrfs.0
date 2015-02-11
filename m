Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbbBKSk6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:40:58 -0500
Date: Wed, 11 Feb 2015 19:40:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 22/24] Btrfs: sysfs: don't fail seeding for the sake of
 sysfs kobject issue
Message-ID: <20150211184057.GJ28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-23-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423439785-10260-23-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 07:56:23AM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 51873ec..1490723 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2249,7 +2249,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  						root->fs_info->fsid);
>  		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
>  								fsid_buf))
> -			goto error_trans;
> +			printk(KERN_WARNING\
> +			"BTRFS: sysfs: failed to create fsid for sprout\n");

You can safely use btrfs_warn here.
