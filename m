Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48028 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHRBdd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 21:33:33 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 8A0A33EE1DF
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 10:33:31 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9ABACAC02FC
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 10:33:30 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A5821DB803C
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 10:33:30 +0900 (JST)
Received: from G01JPEXCHYT13.g01.fujitsu.local (G01JPEXCHYT13.g01.fujitsu.local [10.128.194.52])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 159C46D648C
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 10:33:28 +0900 (JST)
Message-ID: <53F157DE.9030901@jp.fujitsu.com>
Date: Mon, 18 Aug 2014 10:33:18 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix a misformatting in 'man btrfs-replace'
References: <53E9D08A.3070404@jp.fujitsu.com>
In-Reply-To: <53E9D08A.3070404@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/08/12 17:30), Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Just fix the following misformatting in 'man btrfs-replace'.

Please ignore this patch.

It's part of the following Qu's patch.
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36116.html

In addition, to make matters worse, I've reviewed and tested this patch ;-(

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36206.html

Satoru

> 
> ===============================================================================
> -f
>      force using and overwriting <targetdev> even if it looks like containing
>      a valid btrfs filesystem.
> 
>      A valid filesystem is assumed if a btrfs superblock is found which
>      contains a correct checksum. Devices which are currently mounted are never
>      allowed to be used as the <targetdev>. -B:::: no background replace.
>                                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ===============================================================================
>   
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> ---
>   Documentation/btrfs-replace.txt | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
> index eecf9b0..476e351 100644
> --- a/Documentation/btrfs-replace.txt
> +++ b/Documentation/btrfs-replace.txt
> @@ -49,6 +49,7 @@ containing a valid btrfs filesystem.
>   A valid filesystem is assumed if a btrfs superblock is found which contains a
>   correct checksum. Devices which are currently mounted are
>   never allowed to be used as the <targetdev>.
> ++
>   -B::::
>   no background replace.
>   
> 

