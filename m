Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42356 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLYBCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:02:39 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id CB2B13EE190
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:02:37 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id AE13CAC0661
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:02:36 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 46B931DB804D
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:02:36 +0900 (JST)
Received: from G01JPEXCHYT18.g01.fujitsu.local (G01JPEXCHYT18.g01.fujitsu.local [10.128.194.57])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id DF54E46E7F1
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:02:34 +0900 (JST)
Message-ID: <549B6223.6080205@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 10:02:27 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: fix incorrect format of 'l' option
 in mkfs.btrfs
References: <201412240710.AA00005@WIN-R1VKH1IH438.jp.fujitsu.com>
In-Reply-To: <201412240710.AA00005@WIN-R1VKH1IH438.jp.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tsutomu,

On 2014/12/24 16:10, Tsutomu Itoh wrote:
> The format of 'l' option in mkfs.btrfs.txt is wrong.
> And, when the head of the character string is 65536, the following warning
> is displayed.
>
>      $ make
>      Making all in Documentation
>          [ASCII]  mkfs.btrfs.xml
>      asciidoc: WARNING: mkfs.btrfs.xml.tmp1: line 67: list item index: expected 1 got 65536
>          [XMLTO]  mkfs.btrfs.8
>          [GZ]     mkfs.btrfs.8.gz
>      rm mkfs.btrfs.8 mkfs.btrfs.xml
>
> So, fix it.
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Current man 8 mkfs.btrfs is wrong as follows.

===============================================================================
...
        -n|--nodesize <size>
                                                                                                                              
        + -l|--leafsize <size>:: Specify the nodesize, the tree block size in which btrfs stores data. The default value
        is 16KB (16384) or the page size, whichever is bigger. Must be a multiple of the sectorsize, but not larger than
        65536. Leafsize always equals nodesize and the options are aliases.
...
===============================================================================

In addition, after removing '+' between '-n' and '-l'
to fix this problem, the warning which you said is displayed.
After applying this patch, both two problems disappeared.

Thanks,
Satoru

> ---
>   Documentation/mkfs.btrfs.txt | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
> index ba7e42b..01b615d 100644
> --- a/Documentation/mkfs.btrfs.txt
> +++ b/Documentation/mkfs.btrfs.txt
> @@ -59,19 +59,18 @@ By default, mkfs.btrfs will not write to the device if it suspects that
>   there is a filesystem or partition table on the device already.
>
>   -n|--nodesize <size>
> -+
> +
>   -l|--leafsize <size>::
>   Specify the nodesize, the tree block size in which btrfs stores
>   data. The default value is 16KB (16384) or the page size, whichever is
> -bigger. Must be a multiple of the sectorsize, but not larger than
> -65536. Leafsize always equals nodesize and the options are aliases.
> +bigger. Must be a multiple of the sectorsize, but not larger than 65536.
> +Leafsize always equals nodesize and the options are aliases.
>
>   -L|--label <name>::
>   Specify a label for the filesystem.
>   +
>   NOTE: <name> should be less than 256 characters.
>
> -
>   -m|--metadata <profile>::
>   Specify how metadata must be spanned across the devices specified. Valid
>   values are 'raid0', 'raid1', 'raid5', 'raid6', 'raid10', 'single' or 'dup'.
>

