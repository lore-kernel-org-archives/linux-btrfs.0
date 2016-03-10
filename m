Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbcCJNXY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 08:23:24 -0500
Date: Thu, 10 Mar 2016 14:23:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-debug-tree: show the compression
 method string
Message-ID: <20160310132303.GF18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457599239-5512-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457599239-5512-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 04:40:39PM +0800, Xiaoguang Wang wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  print-tree.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 53a6813..5727cb9 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -286,6 +286,20 @@ static void print_uuids(struct extent_buffer *eb)
>  	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
>  }
>  
> +static char *compress_flags_to_str(u8 flag)
> +{
> +	switch (flag) {
> +	case BTRFS_COMPRESS_NONE:
> +		return "none";
> +	case BTRFS_COMPRESS_ZLIB:
> +		return "zlib";
> +	case BTRFS_COMPRESS_LZO:
> +		return "lzo";
> +	default:
> +		return "UNKNOWN";

would be good to print the actual value
