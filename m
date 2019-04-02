Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B23C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 15:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1572075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 15:04:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="kXXGpadY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbfDBPE3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:04:29 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:33350 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731278AbfDBPE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 11:04:29 -0400
Received: from [192.168.99.127] (unknown [93.241.30.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 179C747C601A;
        Tue,  2 Apr 2019 18:04:27 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554217467;
        bh=xH/f59XOZw2la3J4uti+MzEg9pyu1ckG+xnTTDyBKSE=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=kXXGpadYrOpYysj2Rk3ayaiLzuguFCsA4Bivj+orVT/cUN/jLNDtvXm6EoaMjVxaa
         lQCj7bGftArO58bDhfKq2hX/hj7WtPt6WJZrtiA4QvlgPsRLoAZpVmY9PFpp+z182K
         YRSS6jpmqQVPj12c3DGwnlOr7c53uFpu6gOadAS2sZzNvH1nXmc8pt5gpwHcJXO3L4
         kAD4uhdkdYPvSJVznHRXUCHekBh6Y0v0uGxBXMt3fZ9lpZK8o4I27QE9mlZ/p+miU8
         5QuPmp7oOUUmRejmbrQhm6f3vNmNdhpQa4493kv2SyKsB51FCi+svOjmqB2X8Km6eR
         LYrM96kXqgmTw==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Hans van Kranenburg <hans@knorrie.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <bb5e9213-7fd1-0452-7ece-3a904528d277@knorrie.org>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <454746ef-b97f-bc4e-5100-61dd4b56ee7f@avgustinov.eu>
Date:   Tue, 2 Apr 2019 17:04:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bb5e9213-7fd1-0452-7ece-3a904528d277@knorrie.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-1901
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-02 16:19, Hans van Kranenburg:
> On 4/2/19 4:12 PM, Qu Wenruo wrote:
>>
>>
>> On 2019/4/2 下午9:59, Nik. wrote:
>>>
>>>
>>> 2019-04-02 15:24, Qu Wenruo:
>>>>
>>>>
>>>> On 2019/4/2 下午9:06, Nik. wrote:
>>>>>
>>>> If the larger fs really doesn't get any write (btrfs check --repair
>>>> failed to open the fs, thus have the output "cannot open file system"),
>>>> I'm interesting in that one.
>>>
>>> This is excerpt from the terminal log:
>>> "# btrfs check --readonly /dev/md0
>>> incorrect offsets 15003 146075
>>> ERROR: cannot open file system
>>> #"
>>
>> That's great.
>>
>> And to my surprise, this is completely different problem.
>>
>> And I believe, it will be detected by latest write time tree checker
>> patches in next kernel release.
>>
>> This problem is normally caused by memory bit flip.
> 
> To illustrate for whoever needs it to follow this reasoning:
> 
> bin(146075) -> 0b100011101010011011
> bin(15003)  ->     0b11101010011011

Wait a minute! I hope you are not saying that the file system grew too 
much for addressing it on a 32bit architecture (inappropriate variable 
type somewhere in the code)? Because the problem came shortly after 
adding another drive to the file system...


> So, 146075 is actually 15003, but with a bit flipped from 0 to 1.
> 
>> This should ring a little alert about the problem.
> 
> Hans
> 
