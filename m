Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84905C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 21:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51EA820818
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 21:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="PBtKruIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfDJVEF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 17:04:05 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:51046 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfDJVEE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 17:04:04 -0400
Received: from [192.168.29.36] (avgustinov.eu [87.140.63.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 19F3749C82A6;
        Thu, 11 Apr 2019 00:04:01 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554930241;
        bh=+NakhqLAzT300xW6DLHmO7RcfwdZkR3o0y95jKVGHsg=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=PBtKruIHabWI/DQEr5e//iB0fAAQaTwPTXuSfUJdObimc2C99+pHCgqAJIfz7DK5m
         ieB1Jyje7yxC5k9I4nWbgBIpZHBQxxVs+lIjehBralOFp3vUCvXbEQ722JjEDdMUbQ
         HgPXBzKGbihXYyXsN3uXHo5OtX5U/F3Yk+uPJHNhgALrSTFBHvUe4lcd+/Kqe9GHNQ
         Zg6izMJ8giD/XjI3SLRdGadVjKv7WaR4ALuM9sx/P2b6UzNxjTZrQ2pIaGvpogpxU1
         m0Gu/ofewCGbQs7pocRgLQpB6Rwa2ukWub+3O6kHMvi8N61ZmIRKNic2/McmaUFWqt
         aoQiWR21UBIvg==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
 <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <f6ee7655-e6e2-4162-6c34-7b4b3dba71c7@avgustinov.eu>
Date:   Wed, 10 Apr 2019 23:03:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-07 20:45, Chris Murphy:
> On Sun, Apr 7, 2019 at 1:42 AM Nik. <btrfs@avgustinov.eu> wrote:
>> 2019-04-07 01:18, Qu Wenruo:
> 
>>> You have 2 bits flipped just in one tree block!
>>>
>> If the data-tree structures alone have so many bits flipped, how much
>> flipped bits are to be expected in the data itself? What should a normal
>> btrfs user do in order to prevent such disasters?
> 
> I think the corruption in your case is inferred by Btrfs only by bad
> key ordering, not csum failure for the leaf? I can't tell for sure
> from the error, but I don't see a csum complaint.

I do not quite understand where the "bad key ordering" came from, but my 
question why (in my case) it keeps happening only to the btrfs file 
systems? Is it relevant, that all four failed systems have had initially 
ext4 format and were converted to btrfs (with the btrfs-progs used 5-6 
years ago)?

Another question: I am sure that many btrfs users are ready in some 
cases to trade reliability for performance; wouldn't it be interesting 
to introduce a kind of switch/option like the "verify on", used many 
years ago on msdos-systems to ensure that write operations (especially 
on floppy disks) were successful? Just an idea...

My btrfs-restore is still running (since Monday evening, until now about 
50% restored), and I am on a business trip. As soon as it finishes and I 
am back home I will compare with the backup and give more info, but it 
seems that this would need another day or two.

Kind regards,

Nik.
--

> I'd expect a RAM caused corruption could affect a metadata leaf data,
> followed by csum computation. Therefore no csum failure on subsequent
> read. Whereas if the corruption is storage stack related, we'd see a
> csum error on subsequent read.
> 
> Once there's corruption in a block address, the corruption can
> propagate into anything else that depends on that block address even
> if there isn't another corruption event. So one event, multiple
> corruptions.
> 
> 
>> And another thing: if I am getting it right, it should have been more
>> reliable/appropriate to let btrfs manage the five disks behind the md0
>> with a raid1 profile instead binding them in a RAID5 and "giving" just a
>> single device to btrfs.
> 
> Not necessarily. If corruption happens early enough, it gets baked
> into all copies of the metadata.
> 
> 
