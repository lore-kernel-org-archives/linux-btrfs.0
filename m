Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaG3GHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 02:07:36 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E1A0B3EE1DC
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:07:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id EA7DFAC06E9
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:07:33 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 88A4BE0800F
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:07:33 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 80F4732864A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:07:31 +0900 (JST)
Message-ID: <53D88B9E.8040301@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 15:07:26 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: remove unnecessary judgment for fd in
 scrub
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1405564839-28702-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/07/17 11:40), Gui Hecheng wrote:
> The scrub_read_file function is always on a branch,
> which has (fd >= 0), so there is not need to judgment
> the pasted in arg.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   cmds-scrub.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index f9e2b40..a604b25 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -474,9 +474,6 @@ static struct scrub_file_record **scrub_read_file(int fd, int report_errors)
>   	char empty_uuid[BTRFS_FSID_SIZE] = {0};
>   	struct scrub_file_record **p = NULL;
>   
> -	if (fd < 0)
> -		return ERR_PTR(-EINVAL);
> -

It's correct. In addition, adding "'fd' should point to a opened file"
like comment is better for potential users of this function.

Thanks,
Satoru


>   again:
>   	old_avail = avail - i;
>   	BUG_ON(old_avail < 0);
> 

