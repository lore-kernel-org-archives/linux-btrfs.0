Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49290 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751095AbdARAmB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 19:42:01 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
 <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
 <1484499869.17186.1.camel@scientia.net>
 <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
 <1484535383.7577.53.camel@scientia.net>
 <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com>
 <1484542415.21166.1.camel@scientia.net>
 <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com>
 <1484604435.7086.22.camel@scientia.net>
 <5c66c74f-3c6d-b296-32ea-9263848ea16f@cn.fujitsu.com>
 <7A13A2CF-9D6F-40D7-9688-2A2460825428@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cacc3a27-6fcb-9ba9-2959-099145c34bad@cn.fujitsu.com>
Date: Wed, 18 Jan 2017 08:41:51 +0800
MIME-Version: 1.0
In-Reply-To: <7A13A2CF-9D6F-40D7-9688-2A2460825428@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/17/2017 06:39 PM, Christoph Anton Mitterer wrote:
> Am 17. Januar 2017 09:53:19 MEZ schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>> Just lowmem false alert, as extent-tree dump shows complete fine
>> result.
>>
>> I'll CC you and adds your reported-by tag when there is any update on
>> this case.
>
> Fine, just one thing left right more from my side on this issue:
> Do you want me to leave the fs untouched until I could verify a lowmem mode fix?
> Or is it ok to go on using it (and running backups on it)?
>
> Cheers,
> Chris.
>
>
Since we have your extent tree and root tree dump, I think we should be 
able to build a image to reproduce the case.

So you're OK to go on using it.
BTW, your fs is too large for us to really do some verification or other 
work.

Thanks,
Qu


