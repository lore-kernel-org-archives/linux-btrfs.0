Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38376 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDCV1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:21:27 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 023D93EE0EC
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:21:26 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 03683AC0ACF
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:21:25 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id AF7431DB8032
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:21:24 +0900 (JST)
Message-ID: <53B60F91.9070004@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 11:21:05 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Quota Ignored On write
References: <53B60DE1.9070905@gmail.com>
In-Reply-To: <53B60DE1.9070905@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kevin,

(2014/07/04 11:13), Kevin Brandstatter wrote:
> basing of the latest for-linus branch i found i can write way more than
> the quota
>
> btrfs quota enable
> btrfs subvolume create test
> btrfs qgruop limit 1G test
> dd if=/dev/zero of=test/file bs=1024 count=1500000
> output:
> 1500000+0 records in
> 1500000+0 records out
> 1536000000 bytes (1.5 GB) copied, 5.91909 s, 259 MB/s
>
> thats a full half gig over the quota limit. I noticed some changes to
> the quota
> accounting in the logs, what changed that could cause this?

Do you remember what kernel version quota worked correctly?

Thanks,
Satoru

>
> -Kevin Brandstatter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

