Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59109 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbeC2IeQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 04:34:16 -0400
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
 <c8a655bc-ae35-2d4d-2b0f-2fd4535a9070@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aca5e9f8-4943-6b58-76b6-5e358fbed8d8@suse.com>
Date: Thu, 29 Mar 2018 11:34:14 +0300
MIME-Version: 1.0
In-Reply-To: <c8a655bc-ae35-2d4d-2b0f-2fd4535a9070@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.03.2018 11:22, Misono Tomohiro wrote:
> "fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
> running without root privilege even if raid5/6 is not used.  What
> happens is it cannot get the per device profile usage info, so change
> the message more appropriately.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  cmds-fi-usage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index de7ad668..f2307fe0 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -629,7 +629,7 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
>  	ret = load_chunk_info(fd, chunkinfo, chunkcount);
>  	if (ret == -EPERM) {
>  		warning(
> -"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, run as root");
> +"cannot read detailed chunk info. per device usage will not be shown, run as root");
                                    ^^^
nit: New sentences must start with a capital letter :)
>  	} else if (ret) {
>  		return ret;
>  	}
> 
