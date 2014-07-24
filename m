Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbaGXNYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:24:33 -0400
Date: Thu, 24 Jul 2014 15:24:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/10] Btrfs: fix wrong fsid check of scrub
Message-ID: <20140724132431.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
 <1406173035-29478-3-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406173035-29478-3-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:37:08AM +0800, Miao Xie wrote:
> All the metadata in the seed devices has the same fsid as the fsid
> of the seed filesystem which is on the seed device, so we should check
> them by the current filesystem. Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/scrub.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 23d3f6e..9a81874e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1361,6 +1361,16 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
>  	return;
>  }
>  
> +static inline int scrub_check_fsid(u8 fsid[],

Please use 'const u8 *fsid' type.

> +				   struct scrub_page *spage)
> +{
> +	struct btrfs_fs_devices *fs_devices = spage->dev->fs_devices;
> +	int ret;
> +
> +	ret = memcmp(fsid, fs_devices->fsid, BTRFS_UUID_SIZE);

ret is not necessary

> +	return !ret;
> +}
