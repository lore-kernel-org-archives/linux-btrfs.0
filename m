Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55731 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHADQf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 23:16:35 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 123243EE0AE
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 12:16:34 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 0C1D7AC07D2
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 12:16:33 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B432D1DB803B
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 12:16:32 +0900 (JST)
Message-ID: <53DB0686.8020208@jp.fujitsu.com>
Date: Fri, 1 Aug 2014 12:16:22 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: remove experimental tag
References: <1406809294-24702-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1406809294-24702-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/31 21:21), David Sterba wrote:
> Make it consistent with kernel status and documentation.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

I'm glad to see this patch :-)

Thanks,
Satoru

> ---
>   mkfs.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 16e92221a547..538b6e6837b2 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1439,8 +1439,8 @@ int main(int ac, char **av)
>   	}
>   
>   	/* if we are here that means all devs are good to btrfsify */
> -	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
> -	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
> +	printf("%s\n", BTRFS_BUILD_VERSION);
> +	printf("See http://btrfs.wiki.kernel.org for more\n\n");
>   
>   	dev_cnt--;
>   
> @@ -1597,7 +1597,6 @@ raid_groups:
>   	    label, first_file, nodesize, leafsize, sectorsize,
>   	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
>   
> -	printf("%s\n", BTRFS_BUILD_VERSION);
>   	btrfs_commit_transaction(trans, root);
>   
>   	if (source_dir_set) {
> 

