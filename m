Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:62030 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbASMZd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 07:25:33 -0500
Message-ID: <54BCF7BA.90302@giantdisaster.de>
Date: Mon, 19 Jan 2015 13:25:30 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 10/16] Btrfs: Avoid trustless page-level-repair in dev-replace
References: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com> <1421666465-3892-11-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421666465-3892-11-git-send-email-zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Jan 2015 19:20:59 +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Current code of page level repair for dev-replace can only support
> io-error, we can't use it in checksum-fail case.
> 
> We can skip this kind of repair in dev-replace just as we in scrub.

Why? I see dev-replace as a disk copy operation with integrated support
to pick the best mirror source device. Therefore the strategy was to
always write to the target device, even in case of uncorrectable
checksum errors. Maybe the checksum was wrong, not the data itself, and
you can repair files later by recalculating the checksum. If you write
nothing at all, some random, old data remains on the target disk,
instead of potentially fixable data.

Therefore this is handled differently for the dev-replace and for the
scrub case. For scrub, data is only overwritten when the source data is
verified, since the goal is to repair something. Dev-replace's goal is
to copy something.


> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 9afc6dd..6cf0dc7 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1099,6 +1099,10 @@ nodatasum_case:
>  		}
>  	}
>  
> +	/* can only fix I/O errors from here on */
> +	if (sblock_bad->no_io_error_seen)
> +		goto did_not_correct_error;
> +
>  	/*
>  	 * for dev_replace, pick good pages and write to the target device.
>  	 */
> @@ -1181,10 +1185,6 @@ nodatasum_case:
>  	 * area are unreadable.
>  	 */
>  
> -	/* can only fix I/O errors from here on */
> -	if (sblock_bad->no_io_error_seen)
> -		goto did_not_correct_error;
> -
>  	success = 1;
>  	for (page_num = 0; page_num < sblock_bad->page_count; page_num++) {
>  		struct scrub_page *page_bad = sblock_bad->pagev[page_num];
> 

