Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751346AbdFAJ6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:58:14 -0400
Subject: Re: [PATCH v2 6/9] btrfs: Check name before read in
 'iterate_dir_item'
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-7-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f4b0f4bd-105b-9a6d-d4c4-ddc842ae014f@suse.com>
Date: Thu, 1 Jun 2017 12:58:12 +0300
MIME-Version: 1.0
In-Reply-To: <20170601085716.25898-7-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.06.2017 11:57, Su Yue wrote:
> Since 'iterate_dir_item' checks namelen in its way,
> use 'btrfs_is_namelen_valid' not 'verify_dir_item'.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/send.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index fc496a6f842a..caf96af106e6 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1069,6 +1069,12 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>  			}
>  		}
>  
> +		ret = btrfs_is_namelen_valid(eb, path->slots[0],
> +			  (unsigned long)(di + 1), name_len + data_len);
> +		if (!ret) {
> +			ret = -ENAMETOOLONG;

In 5/9 and 7/9 the return values upon btrfs_is_namelen_valid failure are
different. Shouldn't the failure root cause (corrupted datastructures)
always be the same when btrfs_is_namelen_valid fails? E.g. in the case
of send we shouldn't really have entries which are ENAMETOOLONG, since
they should've been rejected at time they were originally created with
ENAMETOOLONG. And in case corruption happened and iterate_dir_item
observes failure from btrfs_is_namelen_valid then this should be
EIO/EUCLEAN ?


> +			goto out;
> +		}
>  		if (name_len + data_len > buf_len) {
>  			buf_len = name_len + data_len;
>  			if (is_vmalloc_addr(buf)) {
> 
