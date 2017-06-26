Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:53344 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdFZIl3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 04:41:29 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B6BDDAC00AC
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2017 17:41:25 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: mkfs: Replace number with a macro
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170626082355.16106-1-gujx@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <79edf523-cc9f-5450-8fe6-da45bc641789@jp.fujitsu.com>
Date: Mon, 26 Jun 2017 17:41:12 +0900
MIME-Version: 1.0
In-Reply-To: <20170626082355.16106-1-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/06/26 17:23, Gu Jinxiang wrote:
> For code maintainability and scalability,
> replace number with a macro of member blocks in btrfs_mkfs_config.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  mkfs/common.c | 2 +-
>  mkfs/common.h | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index e4785c5..420671b 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -94,7 +94,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	uuid_generate(chunk_tree_uuid);
>  
>  	cfg->blocks[0] = BTRFS_SUPER_INFO_OFFSET;
> -	for (i = 1; i < 7; i++) {
> +	for (i = 1; i <= BTRFS_MKFS_ROOTS_NR; i++) {

If you change 7 to BTRFS_MKFS_ROOTS_NR, you also need to change the following code.

 213         for (i = 1; i < 7; i++) {

Thanks,
Tsutomu

>  		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
>  			cfg->nodesize * i;
>  	}
> diff --git a/mkfs/common.h b/mkfs/common.h
> index 666a75b..e23e79b 100644
> --- a/mkfs/common.h
> +++ b/mkfs/common.h
> @@ -28,6 +28,9 @@
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
>  #define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
>  
> +/* roots: root tree, extent tree, chunk tree, dev tree, fs tree, csum tree */
> +#define BTRFS_MKFS_ROOTS_NR 6
> +
>  struct btrfs_mkfs_config {
>  	/* Label of the new filesystem */
>  	const char *label;
> @@ -43,7 +46,7 @@ struct btrfs_mkfs_config {
>  	/* Output fields, set during creation */
>  
>  	/* Logical addresses of superblock [0] and other tree roots */
> -	u64 blocks[8];
> +	u64 blocks[BTRFS_MKFS_ROOTS_NR + 1];
>  	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
>  	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
>  
> 

