Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45742 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaLVDUk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 22:20:40 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 6B95C3EE188
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:20:39 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7F640AC03F3
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:20:38 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 2D5EBE08002
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:20:38 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 3140246E5D3
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:20:37 +0900 (JST)
Message-ID: <54978DFE.6010507@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 12:20:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Documentation: add T/P/E description for
 resize cmd
References: <1419213702-3945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1419213702-3945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/22 11:01, Gui Hecheng wrote:
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   Documentation/btrfs-filesystem.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> index a8f2972..f2bd50d 100644
> --- a/Documentation/btrfs-filesystem.txt
> +++ b/Documentation/btrfs-filesystem.txt
> @@ -102,8 +102,8 @@ If the prefix + or - is present the size is increased or decreased
>   by the quantity <size>.
>   If no units are specified, the unit of the <size> parameter defaults to
>   bytes. Optionally, the size parameter may be suffixed by one of the following
> -units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
> -respectively.
> +units designators: \'K\'(KiB), \'M\'(MiB), \'G\'(GiB), \'T\'(TiB), \'P\'(PiB),
> +\'E\'(EiB).

Just a minor point. s/\'E\'(EiB)/or \'E\'(EiB)/ is better.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

>   +
>   If \'max' is passed, the filesystem will occupy all available space on the
>   device devid.
> 

