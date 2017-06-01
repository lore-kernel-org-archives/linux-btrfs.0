Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19186 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdFAJRS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 05:17:18 -0400
Subject: Re: [PATCH 2/5] btrfs: send: use kvmalloc in iterate_dir_item
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496252765.git.dsterba@suse.com>
 <b4c7abc3e53eda95ca717d793863639711625d63.1496252765.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <799c51c3-91af-4835-48b0-1eadad9c3042@oracle.com>
Date: Thu, 1 Jun 2017 17:23:21 +0800
MIME-Version: 1.0
In-Reply-To: <b4c7abc3e53eda95ca717d793863639711625d63.1496252765.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/01/17 01:49, David Sterba wrote:
> We use a growing buffer for xattrs larger than a page size, at some
> point vmalloc is unconditionally used for larger buffers. We can still
> try to avoid it using the kvmalloc helper.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 924b1d941b53..7416b17c0eac 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1083,7 +1083,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>  				buf = tmp;
>  			}
>  			if (!buf) {
> -				buf = vmalloc(buf_len);
> +				buf = kvmalloc(buf_len, GFP_KERNEL);
>  				if (!buf) {
>  					ret = -ENOMEM;
>  					goto out;
>
