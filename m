Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:34925 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaFRGUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 02:20:43 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id D10DF3EE0C7
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:20:41 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E8766AC03B0
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:20:40 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9EC011DB8045
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:20:40 +0900 (JST)
Message-ID: <53A12FAE.7060307@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 15:20:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Adam Buchbinder <abuchbinder@google.com>, <linux-btrfs@vger.kernel.org>
CC: <dave@jikos.cz>
Subject: Re: [PATCH] Fix undefined behavior in radix-tree.c.
References: <1402694330-21211-1-git-send-email-abuchbinder@google.com>
In-Reply-To: <1402694330-21211-1-git-send-email-abuchbinder@google.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Adam,

(2014/06/14 6:18), Adam Buchbinder wrote:
> When running with UndefinedBehaviorSanitizer, the tests produce the following
> error:
> 
>    radix-tree.c:836:30: runtime error: shift exponent 18446744073709551613
>    is too large for 64-bit type 'unsigned long'
> 
> (That's a negative shift exponent represented as an unsigned long.)
> 
> Even though the value is discarded in those cases, it's still undefined
> behavior; see the C99 standard, section 6.5.7, paragraph three: "If the
> value of the right operand is negative [...] the behavior is undefined."
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   radix-tree.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/radix-tree.c b/radix-tree.c
> index 4f295fc..7457944 100644
> --- a/radix-tree.c
> +++ b/radix-tree.c
> @@ -833,10 +833,10 @@ int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
>   static unsigned long __maxindex(unsigned int height)
>   {
>   	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
> -	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
> +	unsigned long index = ~0UL;
>   
> -	if (tmp >= RADIX_TREE_INDEX_BITS)
> -		index = ~0UL;
> +	if (tmp < RADIX_TREE_INDEX_BITS)
> +		index = (index >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
>   	return index;
>   }
>   
> 

