Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50174 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaG3FUY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 01:20:24 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id CD81C3EE0E7
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 14:20:22 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E1F2FAC0492
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 14:20:21 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9CF921DB8048
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 14:20:21 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 5F597BD6598
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 14:20:20 +0900 (JST)
Message-ID: <53D8808E.4020609@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 14:20:14 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs-progs: correct manpage option description for
 scrub
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1405564839-28702-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-4-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/07/17 11:40), Gui Hecheng wrote:
> The -f option of scrub means to skip checking running scrub,
> not to force checking.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   Documentation/btrfs-scrub.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
> index 7b27d63..1af9b9f 100644
> --- a/Documentation/btrfs-scrub.txt
> +++ b/Documentation/btrfs-scrub.txt
> @@ -47,7 +47,7 @@ manpage).
>   -n <ioprio_classdata>::::
>   Set IO priority classdata (see `ionice`(1) manpage).
>   -f::::
> -force to check whether scrub has started or resumed in userspace.
> +force to skip checking whether scrub has started or resumed in userspace.

I consider "scrub has started and resumed" is not user-friendly
expression. First, it can be replaced with more easy one,
"scrub is running". Second, there in no explanation about
this checking behavior before "-f" option's description.

So, how about the following idea?

 Fix 1. Add "If scrub is already running running, it fails."
        to the description before `Options` section
 Fix 2. Replace "force to check ..." with
        "force starting new scrub even if scrub is already running."
 Fix 3. Fix cmd_scrub_start_usage too.

Thanks,
Satoru

>   this is useful when scrub stat record file is damaged.
>   
>   *cancel* <path>|<device>::
> 

