Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:29108 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755425AbcLOIHY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 03:07:24 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A1E57AC0176
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 17:07:20 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: Fix NULL pointer when receive clone
 operation
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20161215072802.21452-1-quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <fb824e22-658e-80f5-bb77-041ce0b6088e@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 17:07:03 +0900
MIME-Version: 1.0
In-Reply-To: <20161215072802.21452-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/12/15 16:28, Qu Wenruo wrote:
> The subvol_info returned from subvol_uuid_search() can be NULL.
> So the branch checking IS_ERR(si) should also check if it's NULL.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  cmds-receive.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-receive.c b/cmds-receive.c
> index cb42aa2..c8f2fff 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -750,7 +750,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
>  	si = subvol_uuid_search(&rctx->sus, 0, clone_uuid, clone_ctransid,
>  				NULL,
>  				subvol_search_by_received_uuid);
> -	if (IS_ERR(si)) {
> +	if (IS_ERR(si) || !si) {

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

But I like  if (!si || IS_ERR(si)) {

Thanks,
Tsutomu

>  		if (memcmp(clone_uuid, rctx->cur_subvol.received_uuid,
>  				BTRFS_UUID_SIZE) == 0) {
>  			/* TODO check generation of extent */
> 

