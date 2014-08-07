Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47897 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaHGK0E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Aug 2014 06:26:04 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 8E4523EE1BA
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:26:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A28E5AC0933
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:26:01 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 574341DB8042
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:26:01 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 786F2BD65CD
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:26:00 +0900 (JST)
Message-ID: <53E35430.9070408@jp.fujitsu.com>
Date: Thu, 7 Aug 2014 19:25:52 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Documentations: Fix a format error in btrfs-replace.txt
References: <1407137334-6183-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1407137334-6183-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/08/04 16:28), Qu Wenruo wrote:
> Missing '+'s cause '-B' option not displayed correctly, add it to fix.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   Documentation/btrfs-replace.txt | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
> index eecf9b0..067b02d 100644
> --- a/Documentation/btrfs-replace.txt
> +++ b/Documentation/btrfs-replace.txt
> @@ -42,6 +42,7 @@ The <targetdev> needs to be same size or larger than the <srcdev>.
>   only read from <srcdev> if no other zero-defect mirror exists.
>   (enable this if your drive has lots of read errors, the access would be very
>   slow)
> ++
>   -f::::
>   force using and overwriting <targetdev> even if it looks like
>   containing a valid btrfs filesystem.
> @@ -49,6 +50,7 @@ containing a valid btrfs filesystem.
>   A valid filesystem is assumed if a btrfs superblock is found which contains a
>   correct checksum. Devices which are currently mounted are
>   never allowed to be used as the <targetdev>.
> ++
>   -B::::
>   no background replace.
>   
> 

