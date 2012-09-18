Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48978 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773Ab2IRMKq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 08:10:46 -0400
Date: Tue, 18 Sep 2012 14:10:36 +0200
From: David Sterba <dave@jikos.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: make space to keep default mount options
Message-ID: <20120918121035.GZ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CE50.1050706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5057CE50.1050706@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 10:28:48AM +0900, Hidetoshi Seto wrote:
> This patch create space to hold default mount option,
> and to use saved default mount option change super.c
> to read default mount option first when mount devices.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  fs/btrfs/ctree.h |    5 ++++-
>  fs/btrfs/super.c |    2 ++
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fa5c45b..3eb0551 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -458,8 +458,11 @@ struct btrfs_super_block {
>  
>  	__le64 cache_generation;
>  
> +	/* default mount options */
> +	unsigned long default_mount_opt;

you need to use __le64 here, unsigned long has not fixed size

> +
>  	/* future expansion */
> -	__le64 reserved[31];
> +	__le64 reserved[30];
>  	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>  	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
>  } __attribute__ ((__packed__));
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e239915..7ef4a2e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -340,6 +340,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  	char *compress_type;
>  	bool compress_force = false;
>  
> +	info->mount_opt = info->super_copy->default_mount_opt;

the options have to respect some priority, eg. when I set default
options to a filesystem, but mount with a different set, I expect that
the explicit flags apply and override the defaults.

I don't remember if this was discussed in the mailinglist or on IRC
only, should be easy to dig up if needed.

> +
>  	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
>  	if (cache_gen)
>  		btrfs_set_opt(info->mount_opt, SPACE_CACHE);


david
