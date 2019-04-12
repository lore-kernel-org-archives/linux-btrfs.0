Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AE1C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 244CD2084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="oYs0+ha1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfDLKoI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:44:08 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:34050 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfDLKoI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 06:44:08 -0400
Received: from [192.168.178.50] (ip5f59220b.dynamic.kabel-deutschland.de [95.89.34.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 5B65B4A27B09;
        Fri, 12 Apr 2019 13:44:06 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1555065846;
        bh=sH4zHkPIUmEYwEmTE1SWju7Df1giM5Kqq+wpa3eXGOo=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=oYs0+ha1Rb7v4dFkRVtTk4FAW2v+L/iWvR59J04hY8UkjMrkeZs3KIpH7XhaQx+iG
         VBMnHtOUiteOeX4i/X+uw+DVzqLdTKiZ67ujL/S4760pNVXWbG/eCyCHKGGnLGqfXa
         JIhsdN+fqFxyxeQLDlDSWHtOLdlwiobmzfRu7AVe04vh5w+Ktg2wwlvHam5zWel/DT
         v2iRl1zWbmd3/XcPChQ3m/ZYnb4fmNvoKxOBQwrG/Y1cqsPZPPzyO4lrdju1gm3usG
         BU2JIG578QDCXdijXp//UhNGIigAOsQgZlQ1ji0wepBvqTf1X18TwH02iUbwl/W1UO
         0DbII1yT5cdJw==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
From:   "Nik." <btrfs@avgustinov.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
 <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
Message-ID: <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>
Date:   Fri, 12 Apr 2019 12:44:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


2019-04-08 23:22, Nik.:
>
>
> 2019-04-08 15:09, Qu Wenruo:
>> Unfortunately, I didn't receive the last mail from Nik.
>>
>> So I'm using the content from lore.kernel.org.
>>
>> [122293.101782] BTRFS critical (device md0): corrupt leaf: root=1
>> block=1894009225216 slot=82, bad key order, prev (2034321682432 168
>> 262144) current (2034318143488 168 962560)
>>
>> Root=1 means it's root tree, 168 means EXTENT_ITEM, which should only
>> occur in extent tree, not in root tree.
>>
>> This means either the leaf owner, or some tree blocks get totally
>> screwed up.
>>
>> This is not easy to fix, if possible.
>>
>> Would you please try this kernel branch and mount it with
>> "rescue=skip_bg,ro"?
>> https://github.com/adam900710/linux/tree/rescue_options
>>
>> I think that's the last method. Before that, you could try
>> btrfs-restore, which is purely user-space and should be easier to setup
>> than custom kernel.
>>
>> Thanks,
>> Qu
>
> Tried "btrfs restore -vsxmi ..." (it did not work before my first 
> email), it is processing for at least 6 hours until now. It seems that 
> despite many error messages files are getting restored. As soon as it 
> finishes will check what is the result and give feedback. Will also 
> test the mentioned kernel branch.
>
After almost four days only about 120 GB of my initially 3.7TB of free 
space remain free, and the restore is still working (how about 
introducing a "progress" switch?)... I guess that due to the option "-s" 
and the lack of deduplication the snapshots are going to fill all the 
space without reaching the "end" of the file restoring system.

Until now I still did not have chance (and time) to compare the restored 
with backups, but at this point I would like to ask you: what else would 
you like to know|try|do? Should I try the mentioned above kernel and its 
rescue options? Something else, which is risky and should not be tried 
on a production system?

Kind regards,

Nik.

--

[snip]

