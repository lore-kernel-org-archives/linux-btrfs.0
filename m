Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7239 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750949AbdBFJ3n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 04:29:43 -0500
Subject: Re: Very slow balance / btrfs-transaction
To: Jorg Bornschein <jb@capsec.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        <linux-btrfs@vger.kernel.org>
References: <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
 <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
 <22abce5d39112d2223580b19b1adc4df@85337f6d4fa4>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cdd5e3ff-2235-64ba-af8f-d9d417d3dfaa@cn.fujitsu.com>
Date: Mon, 6 Feb 2017 17:29:30 +0800
MIME-Version: 1.0
In-Reply-To: <22abce5d39112d2223580b19b1adc4df@85337f6d4fa4>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/06/2017 05:14 PM, Jorg Bornschein wrote:
> February 6, 2017 1:45 AM, "Qu Wenruo" <quwenruo@cn.fujitsu.com>
>
>> Would you please provide the kernel version?
>>
>> v4.9 introduced a bad fix for qgroup balance, which doesn't completely fix qgroup bytes leaking,
>> but also hugely slow down the balance process:
>>
>
> I'm a bit behind the times: 4.8.13-1-ARCH
>
>
>
>    j
>
>
Unfortunately, v4.8 also has that bad commit :(.

So if you have your spare time, you could try v4.10.
Although for Archlinux it would take some time before v4.10 moved from 
[testing] to [core].

Thanks,
Qu


