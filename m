Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E65C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 11:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14DD206BA
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 11:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="dwDwHok9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfDLLix (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:38:53 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:34334 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDLLix (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 07:38:53 -0400
Received: from [192.168.178.50] (ip5f59220b.dynamic.kabel-deutschland.de [95.89.34.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id AF1884A29F4E;
        Fri, 12 Apr 2019 14:38:51 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1555069131;
        bh=fe8yyirbbi2s8eD0Lfv9J3ZQn9P4HoqgL4BPAtUzhz0=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=dwDwHok9ew2djicLuhCmexHe2lOyDSoJscUaTNW6Jn+CZdzUSUcnVw7DUaEFc2+jJ
         apnXNVqw/H82KjBDZq/Li/L8+Rwzdy4n7yNvFAXWPlZktXUF8Bb3mONUkP0sls1kS4
         X4d0gN+0S8CVXP6YiFddH6ZZURX3Yk6NhWPFLxa8qGg11fZBWgPulcxXlvneNlyfUN
         Af2WkWWoCZdliBwFyZ8ePSvyt5rvPd1OZBEIuV1J4fX4M86ZKxvIorm+BdRj85xdaj
         C+ykUzlA8nRGZXBT729Xd7+QUpnbCVOFdep9kKtzjz7SUGXAjU1hbXXAknptayXLU3
         4CSLkW/k0I2Xg==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
 <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
 <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>
 <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <fea90c59-9aad-e997-8763-6c9221652acc@avgustinov.eu>
Date:   Fri, 12 Apr 2019 13:38:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-12 12:50, Qu Wenruo:
> 
> 
> On 2019/4/12 下午6:44, Nik. wrote:
>>
>> 2019-04-08 23:22, Nik.:
>>>
>>>
>>> 2019-04-08 15:09, Qu Wenruo:
>>>> Unfortunately, I didn't receive the last mail from Nik.
>>>>
>>>> So I'm using the content from lore.kernel.org.
>>>>
>>>> [122293.101782] BTRFS critical (device md0): corrupt leaf: root=1
>>>> block=1894009225216 slot=82, bad key order, prev (2034321682432 168
>>>> 262144) current (2034318143488 168 962560)
>>>>
>>>> Root=1 means it's root tree, 168 means EXTENT_ITEM, which should only
>>>> occur in extent tree, not in root tree.
>>>>
>>>> This means either the leaf owner, or some tree blocks get totally
>>>> screwed up.
>>>>
>>>> This is not easy to fix, if possible.
>>>>
>>>> Would you please try this kernel branch and mount it with
>>>> "rescue=skip_bg,ro"?
>>>> https://github.com/adam900710/linux/tree/rescue_options
>>>>
>>>> I think that's the last method. Before that, you could try
>>>> btrfs-restore, which is purely user-space and should be easier to setup
>>>> than custom kernel.
>>>>
>>>> Thanks,
>>>> Qu
>>>
>>> Tried "btrfs restore -vsxmi ..." (it did not work before my first
>>> email), it is processing for at least 6 hours until now. It seems that
>>> despite many error messages files are getting restored. As soon as it
>>> finishes will check what is the result and give feedback. Will also
>>> test the mentioned kernel branch.
>>>
>> After almost four days only about 120 GB of my initially 3.7TB of free
>> space remain free, and the restore is still working (how about
>> introducing a "progress" switch?)... I guess that due to the option "-s"
>> and the lack of deduplication the snapshots are going to fill all the
>> space without reaching the "end" of the file restoring system.
>>
>> Until now I still did not have chance (and time) to compare the restored
>> with backups, but at this point I would like to ask you: what else would
>> you like to know|try|do? Should I try the mentioned above kernel and its
>> rescue options?
> 
> That's the only remaining thing you need.

Ok, the "git clone ..." just finished, but in your earlier mail you 
spoke about kernel 5.1/5.2, and the readme of the above repository is 
talking about "Linux kernel release 4.x"? Since building the kernel is 
not a "minute" task (especially when building on atom processor), I 
would like to double check the steps to be done.
Until now:
$ git clone https://github.com/adam900710/linux.git
$ git checkout --track origin/rescue_options

What next? No autogen, no configure. ... The Readme refers to 
"Documentation/process/changes.rst", so am I going to follow its section 
"Configuring the kernel"?
If there is another description of the steps to be taken somewhere - 
please provide a link.

Best,
Nik.

> In fact, I didn't consider the size of the fs, and for that large fs,
> rescue mount option should be the first choice before btrfs-restore.
> 
> Thanks,
> Qu
> 
>> Something else, which is risky and should not be tried
>> on a production system?
>>
>> Kind regards,
>>
>> Nik.
>>
>> -- 
>>
>> [snip]
>>
> 
