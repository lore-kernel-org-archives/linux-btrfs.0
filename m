Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail3.fujitsu.co.jp ([164.71.1.134]:58711 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754881AbaFQFLY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 01:11:24 -0400
Received: from fgwmail.fujitsu.co.jp (fgwmail.fujitsu.co.jp [164.71.1.133])
	by fgwmail4.fujitsu.co.jp (Postfix) with ESMTP id ADE15178C261
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:03:10 +0900 (JST)
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id A39443EE0C2
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:02:59 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 61BE3AC0272
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:02:58 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0F5021DB8050
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:02:58 +0900 (JST)
Message-ID: <539FCBED.6010600@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 14:02:37 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: remove unused wait queue in struct extent_buffer
References: <1402920865-3120-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402920865-3120-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

(2014/06/16 21:14), Filipe David Borba Manana wrote:
> The lock_wq wait queue is not used anywhere, therefore just remove it.
> On a x86_64 system, this reduced sizeof(struct extent_buffer) from 320
> bytes down to 296 bytes, which means a 4Kb page can now be used for
> 13 extent buffers instead of 12.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

It looks good to me. This field was once removed by bd681513.
However, re-introduced in error by 727011e07c
(both are Chris's patch).

I consider it's better to fix the following comment too.

===
$ cat -n fs/btrfs/extent_io.h | grep -B 3 write_lock_wq
   152          /* readers use lock_wq while they wait for the write
   153           * lock holders to unlock
   154           */
   155          wait_queue_head_t write_lock_wq;
===

We should "s/ lock_wq / write_lock_wq /" here.

Thanks,
Satoru

> ---
>   fs/btrfs/extent_io.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 8b63f2d..dbbea4f 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -158,7 +158,6 @@ struct extent_buffer {
>   	 * to unlock
>   	 */
>   	wait_queue_head_t read_lock_wq;
> -	wait_queue_head_t lock_wq;
>   	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
>   #ifdef CONFIG_BTRFS_DEBUG
>   	struct list_head leak_list;
> 

