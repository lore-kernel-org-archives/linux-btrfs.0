Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37676 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaGDCdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:33:00 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id EEF1F3EE1AE
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:32:58 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 09F97AC0561
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:32:58 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9A945E08005
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 11:32:57 +0900 (JST)
Message-ID: <53B61247.4070406@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 11:32:39 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Quota Ignored On write
References: <53B60DE1.9070905@gmail.com> <53B60F91.9070004@jp.fujitsu.com> <53B610B6.8020704@gmail.com>
In-Reply-To: <53B610B6.8020704@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/04 11:25), Kevin Brandstatter wrote:
> 3.15.3 via arch/ and from linux-git

OK, I'll bisect it.

Satoru

>
> -Kevin
>
> On 07/03/2014 09:21 PM, Satoru Takeuchi wrote:
>> Hi Kevin,
>>
>> (2014/07/04 11:13), Kevin Brandstatter wrote:
>>> basing of the latest for-linus branch i found i can write way more than
>>> the quota
>>>
>>> btrfs quota enable
>>> btrfs subvolume create test
>>> btrfs qgruop limit 1G test
>>> dd if=/dev/zero of=test/file bs=1024 count=1500000
>>> output:
>>> 1500000+0 records in
>>> 1500000+0 records out
>>> 1536000000 bytes (1.5 GB) copied, 5.91909 s, 259 MB/s
>>>
>>> thats a full half gig over the quota limit. I noticed some changes to
>>> the quota
>>> accounting in the logs, what changed that could cause this?
>>
>> Do you remember what kernel version quota worked correctly?
>>
>> Thanks,
>> Satoru
>>
>>>
>>> -Kevin Brandstatter
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

