Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52041 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751305AbdFFNN7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:13:59 -0400
Date: Tue, 6 Jun 2017 15:12:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 6/9] btrfs: Check name_len before read in
 iterate_dir_item
Message-ID: <20170606131254.GB2918@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
 <20170606095708.494-7-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606095708.494-7-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 05:57:05PM +0800, Su Yue wrote:
> Since 'iterate_dir_item' checks name_len in its way,
> so use 'btrfs_is_name_len_valid' not 'verify_dir_item' to make more strict
> name_len check.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/send.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index fc496a6f842a..f0e33f7f221e 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1069,6 +1069,12 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>  			}
>  		}
>  
> +		ret = btrfs_is_name_len_valid(eb, path->slots[0],
> +			  (unsigned long)(di + 1), name_len + data_len);
> +		if (!ret) {
> +			ret = -ENAMETOOLONG;

Nikolai pointed out in previous patch iteration that this should be EIO,
I'm fixing it at commit time.
