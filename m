Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbcEQNQX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:16:23 -0400
Date: Tue, 17 May 2016 15:15:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 07/21] btrfs: dedupe: Implement
 btrfs_dedupe_calc_hash interface
Message-ID: <20160517131556.GP511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-8-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-8-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:34:58PM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Unlike in-memory or on-disk dedupe method, only SHA256 hash method is
> supported yet, so implement btrfs_dedupe_calc_hash() interface using
> SHA256.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 9175a5f..bdaea3a 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -593,3 +593,52 @@ int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
>  	}
>  	return ret;
>  }
> +
> +int btrfs_dedupe_calc_hash(struct btrfs_fs_info *fs_info,
> +			   struct inode *inode, u64 start,
> +			   struct btrfs_dedupe_hash *hash)
> +{
> +	int i;
> +	int ret;
> +	struct page *p;
> +	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
> +	struct crypto_shash *tfm = dedupe_info->dedupe_driver;
> +	struct {
> +		struct shash_desc desc;
> +		char ctx[crypto_shash_descsize(tfm)];
> +	} sdesc;

This construct has been obsoleted, please use SHASH_DESC_ON_STACK.
