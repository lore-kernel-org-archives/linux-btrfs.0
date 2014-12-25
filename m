Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36860 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaLYGtZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Dec 2014 01:49:25 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 6E2C03EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:49:24 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 715A2AC0254
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:49:23 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D1FDFE08002
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:49:22 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id DB0453285B3
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:49:21 +0900 (JST)
Message-ID: <549BB36C.6030606@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 15:49:16 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: refine btrfs-debug-tree error prompt
 when a mount point given
References: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/25 10:16, Gui Hecheng wrote:
> Now, if exec:
> 	# btrfs-debug-tree <mount_point>
> it echos:
> 	: Superblock bytenr is larger than device size
> 
> But it is quite misleading, because it is a valid btrfs.
> In this case, we should tell the developer to provide a block device.
> 
> After apply:
> 	: '<mount_point>' is not a block device
> 	: 'usage: btrfs-debug-tree [options] device
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   btrfs-debug-tree.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
> index e46500d..7f079a9 100644
> --- a/btrfs-debug-tree.c
> +++ b/btrfs-debug-tree.c
> @@ -179,6 +179,12 @@ int main(int ac, char **av)
>   	if (check_argc_exact(ac, 1))
>   		print_usage();
>   
> +	ret = check_arg_type(av[optind]);
> +	if (ret != BTRFS_ARG_BLKDEV) {
> +		fprintf(stderr, "'%s' is not a block device\n", av[optind]);

fprintf(stderr, "ERROR: '%s' is ...)" is better since
other error messages in btrfs-progs have this convention.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> +		print_usage();
> +	}
> +
>   	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
>   	if (!info) {
>   		fprintf(stderr, "unable to open %s\n", av[optind]);
> 

