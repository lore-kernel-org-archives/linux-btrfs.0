Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43447 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaGYHwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 03:52:54 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id BA5D13EE0FE
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 16:52:52 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B988DAC09C6
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 16:52:51 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 913201DB802C
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 16:52:47 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 71DF46D667F
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 16:52:46 +0900 (JST)
Message-ID: <53D20CB4.3000409@jp.fujitsu.com>
Date: Fri, 25 Jul 2014 16:52:20 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
References: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

(2014/07/25 10:49), Qu Wenruo wrote:
> When page aligned start and len passed to extent_fiemap(), the result is
> good, but when start and len is not aligned, e.g. start = 1 and len =
> 4095 is passed to extent_fiemap(), it returns no extent.
> 
> The problem is that start and len is all rounded up which causes the
> problem. This patch will round down start and round up (start + len) to
> return right extent.
> 
> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> changelog:
> v2: reword the description(ALIGN rounds up, not rounds down).
> ---
>   fs/btrfs/extent_io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a389820..1c70cff 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4213,8 +4213,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   		return -ENOMEM;
>   	path->leave_spinning = 1;
>   
> -	start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
> -	len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
> +	start = round_down(start, BTRFS_I(inode)->root->sectorsize);
> +	len = round_up(max, BTRFS_I(inode)->root->sectorsize) - start;

I have one question.

Why isn't it "len = round_up(len, BTRFS_I(inode)->root->sectorsize);" ?
Old behavior make len sectorsize aligned. However, if start is not
aligned to sectorsize, new bahavior make len not sectorsize aligned.
Does it an expected behavior?

CMIIW. I'm not good at extent code.

Thanks,
Satoru

>   
>   	/*
>   	 * lookup the last file extent.  We're not using i_size here
> 

