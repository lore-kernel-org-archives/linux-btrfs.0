Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37814 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLYCo1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 21:44:27 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 860473EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 11:44:25 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 8B0F0AC02EE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 11:44:24 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 376CE1DB8049
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 11:44:24 +0900 (JST)
Message-ID: <549B79FD.9080408@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 11:44:13 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 5/8] Return the fsid from make_btrfs()
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-6-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 5:14, Goffredo Baroncelli wrote:
> The function make_btrfs() has as argument the fsid of the filesystem.
> If this fsid is empty or null make_btrfs() generates a new fsid. However
> If the buffer is valid (but the string is empty) the generated fsid is
> copied back to the caller.

The code is goods. However, I have a comment to the description.

In this case, describing the purpose of this patch is better.
I consider your purpose is to use fs_uuid after make_btrfs()
when user doesn't passed -U option.

Anyway,

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>   mkfs.c  | 7 ++++---
>   utils.c | 7 ++++++-
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 042d12e..70c88ea 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1281,7 +1281,7 @@ int main(int ac, char **av)
>   	int dev_cnt = 0;
>   	int saved_optind;
>   	char estr[100];
> -	char *fs_uuid = NULL;
> +	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
>   	u64 features = DEFAULT_MKFS_FEATURES;
>   
>   	while(1) {
> @@ -1356,7 +1356,8 @@ int main(int ac, char **av)
>   				source_dir_set = 1;
>   				break;
>   			case 'U':
> -				fs_uuid = optarg;
> +				strncpy(fs_uuid,optarg,
> +					BTRFS_UUID_UNPARSED_SIZE - 1);
>   				break;
>   			case 'K':
>   				discard = 0;
> @@ -1387,7 +1388,7 @@ int main(int ac, char **av)
>   		exit(1);
>   	}
>   
> -	if (fs_uuid) {
> +	if (*fs_uuid) {
>   		uuid_t dummy_uuid;
>   
>   		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
> diff --git a/utils.c b/utils.c
> index 3f50e4d..c7f1b2f 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -203,7 +203,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
>   	memset(&super, 0, sizeof(super));
>   
>   	num_bytes = (num_bytes / sectorsize) * sectorsize;
> -	if (fs_uuid) {
> +	if (fs_uuid && *fs_uuid) {
>   		if (uuid_parse(fs_uuid, super.fsid) != 0) {
>   			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>   			ret = -EINVAL;
> @@ -216,6 +216,11 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
>   		}
>   	} else {
>   		uuid_generate(super.fsid);
> +		/*
> +		 * if the fs_uuid is a valid pointer, return the generated uuid
> +		 */
> +		if (fs_uuid)
> +			uuid_unparse(super.fsid, fs_uuid);
>   	}
>   	uuid_generate(super.dev_item.uuid);
>   	uuid_generate(chunk_tree_uuid);
> 

