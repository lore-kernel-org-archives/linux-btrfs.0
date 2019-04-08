Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B7BC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 21:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D8320880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 21:22:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="Esw+0sfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfDHVWu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:22:50 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:57084 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfDHVWt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 17:22:49 -0400
Received: from [192.168.29.36] (avgustinov.eu [87.140.63.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 3EE7B494F415;
        Tue,  9 Apr 2019 00:22:47 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554758567;
        bh=4SeKJgvZl4KpLKQMAluZBU1u9hOuXzndj+ZZiX92CWc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Esw+0sfKWVdNLwqivT/ZXBAQ+ZmDhFik3KMarS/h7WSdobv+Vz0TjocWUsZshcIln
         /gwbB4AjXP3KVIuP11BYLq1dVICO7VnRCvvG/0k9rHRzx9/gI05DRVztc30ARqxpB9
         MS8KWHvu4sfxzEFOO4AJVmKid/C2E7euC+ebDqaN3tZHTJKTa3SFdKUZl1yBXGfuI+
         2hxSo0c/zboQrdQA+XvEI11OynU9+zldYTL+RLEWo4JCUMeLEtz4O17U3HlqC9j7y8
         oz1i4ttQ8X++G4zuFdbRtUb7Mmp73Mzpzb+LwDpgs2tmTYI0MPHVFe37mWCWequMak
         jEF7lO6AhbhaQ==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
Date:   Mon, 8 Apr 2019 23:22:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-1901
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-08 15:09, Qu Wenruo:
> Unfortunately, I didn't receive the last mail from Nik.
> 
> So I'm using the content from lore.kernel.org.
> 
> [122293.101782] BTRFS critical (device md0): corrupt leaf: root=1
> block=1894009225216 slot=82, bad key order, prev (2034321682432 168
> 262144) current (2034318143488 168 962560)
> 
> Root=1 means it's root tree, 168 means EXTENT_ITEM, which should only
> occur in extent tree, not in root tree.
> 
> This means either the leaf owner, or some tree blocks get totally
> screwed up.
> 
> This is not easy to fix, if possible.
> 
> Would you please try this kernel branch and mount it with
> "rescue=skip_bg,ro"?
> https://github.com/adam900710/linux/tree/rescue_options
> 
> I think that's the last method. Before that, you could try
> btrfs-restore, which is purely user-space and should be easier to setup
> than custom kernel.
> 
> Thanks,
> Qu

Tried "btrfs restore -vsxmi ..." (it did not work before my first 
email), it is processing for at least 6 hours until now. It seems that 
despite many error messages files are getting restored. As soon as it 
finishes will check what is the result and give feedback. Will also test 
the mentioned kernel branch.

Kind regards,
Nik.
--
> 
> On 2019/4/8 上午2:45, Chris Murphy wrote:
>> On Sun, Apr 7, 2019 at 1:42 AM Nik. <btrfs@avgustinov.eu> wrote:
>>> 2019-04-07 01:18, Qu Wenruo:
>>
>>>> You have 2 bits flipped just in one tree block!
>>>>
>>> If the data-tree structures alone have so many bits flipped, how much
>>> flipped bits are to be expected in the data itself? What should a normal
>>> btrfs user do in order to prevent such disasters?
>>
>> I think the corruption in your case is inferred by Btrfs only by bad
>> key ordering, not csum failure for the leaf? I can't tell for sure
>> from the error, but I don't see a csum complaint.
>>
>> I'd expect a RAM caused corruption could affect a metadata leaf data,
>> followed by csum computation. Therefore no csum failure on subsequent
>> read. Whereas if the corruption is storage stack related, we'd see a
>> csum error on subsequent read.
>>
>> Once there's corruption in a block address, the corruption can
>> propagate into anything else that depends on that block address even
>> if there isn't another corruption event. So one event, multiple
>> corruptions.
>>
>>
>>> And another thing: if I am getting it right, it should have been more
>>> reliable/appropriate to let btrfs manage the five disks behind the md0
>>> with a raid1 profile instead binding them in a RAID5 and "giving" just a
>>> single device to btrfs.
>>
>> Not necessarily. If corruption happens early enough, it gets baked
>> into all copies of the metadata.
>>
>>
> 
