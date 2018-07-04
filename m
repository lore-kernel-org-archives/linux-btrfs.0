Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64343 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932074AbeGDBNJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 21:13:09 -0400
Subject: Re: [PATCH] btrfs-progs: check: add experimental flag for lowmem mode
To: David Disseldorp <ddiss@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20180703114237.11053-1-ddiss@suse.de>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <2ed8b8a2-65a1-f774-27f4-b1098f0fd1dd@cn.fujitsu.com>
Date: Wed, 4 Jul 2018 09:19:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180703114237.11053-1-ddiss@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/03/2018 07:42 PM, David Disseldorp wrote:
> The experimental flag is already carried in the manpage, but was removed
> from the btrfs check usage message as part of refactoring via
> 87c1bd13c1fca430c3dbf0da62e9aa33bde609c8. Add it back.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   check/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 3190b5d4..9aca0c09 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -9386,7 +9386,7 @@ const char * const cmd_check_usage[] = {
>   	"                            original - read inodes and extents to memory (requires",
>   	"                                       more memory, does less IO)",
>   	"                            lowmem   - try to use less memory but read blocks again",
> -	"                                       when needed",
> +	"                                       when needed (experimental)",
>   	"--check-data-csum           verify checksums of data blocks",
>   	"-Q|--qgroup-report          print a report on qgroup consistency",
>   	"-E|--subvol-extents <subvolid>",
> 


