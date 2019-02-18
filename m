Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2015FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 06:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF23217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 06:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfBRGvC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:51:02 -0500
Received: from mout.gmx.net ([212.227.17.21]:34455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfBRGvC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 01:51:02 -0500
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHokD-1gunoc238X-003gNn; Mon, 18
 Feb 2019 07:50:52 +0100
Subject: Re: [PATCH v3 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.de>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-2-wqu@suse.com>
 <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
 <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
 <8e4f62e1-f0ab-5f1f-6fc6-684d3e53b8b8@suse.com>
 <51a84783-2eaf-8f90-ec0d-8bc175279ef8@suse.de>
 <72de8715-1a20-94b1-496e-dddb0983da87@gmx.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <9f7a6e72-3c1a-d899-8beb-0c19447ff56e@gmx.com>
Date:   Mon, 18 Feb 2019 14:59:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <72de8715-1a20-94b1-496e-dddb0983da87@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7cKwH7p/RMGtR5O/0ThqQ50AfD18F/Vv09pKPkoqEpF4E72dMMJ
 dB0IWB+6QWkwbaUdR3LTeIK+cBqAen9/ak6zvBv1jSwcoC53XgKjTCtu2IlLA4gWm3mcUB/
 yHWKpFvqeBK4B5NJl068pjaoepZMl/Mz+XmsbxPcc3/Kc/GJA0KqxwLmOep3K/n13EQqk8T
 9ws8D/WCNzb7pJaGSeTBg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ll3mrI4Gxjo=:tlbLrZtpJ4xCwNyzjkbexH
 ZHiYmemOcQgOIK3X0J71L9IWTLVnsYYuH7AC3b4nmnAJwPcPiihhJBDnVQB1l8zRZXJAci5cp
 85alhyeWvJOPZ7Cb6tz8yQ7riPMlonjf/YZ1m4P1+svqws7FjvOMcTp4h9DrWpbw+7/GSIqOr
 BPHHnBDUxQsemxtK1G1RL3XrwQZ7W/MiXROShFGg/4UMYhGWK1PgdHxO9ta0a+7Eq72iqvP1U
 uibgpNiCDDWJvvB84et0G+ZyPkC4q6gAUwtTlhq/lWfDzwJytld1gN2C2gKOmnjEBb6oNHTF7
 uk0NYief5kbkEqlcV7QHF2YLjPv5u1/SFJQDjc1KWl2GcFw/SzHXMaKvWhBICkGP05IUceJHi
 RJVBUtmDvaYJsdoep6FluHXoOFozpkVAd3PQFs8xNEcgEIFs3mIMFWl5fWsmPjFob3rEKLcs3
 76iE9W91DtxRC33+vPE1uL27j0k9rdJxLwJdw8LSLT7h16sRmxxnqo1xNPqj/agnfICG7rxmp
 L5kiqTnMEDRK0pe1w9mdhn0B+jPvITSm1THJ/VgHGriqA6XaRjzzlrizM/ajMkb5W1aocTTHD
 FQzx0uOJLQ/D6aiLOLiI0zmzh7PNKKNxox8nnpyhERmqujEY2gUtnbmiQKk0LUjWlo5bMdot3
 u87yyyDAFNQWq5V3yIdhqFxRxCFi/6mZx5Slm3cWO6FenrOK8+0OaGHue46iFuYFH3rqMtCg5
 3L7yrcIVMXWg++Kxp6WOJCXlfthcFFKnGiQ2Zrml8zixVX6dqmaiC6BwcVq3NOJhh5fWJ0u+2
 PDZJHUEgUoRB0AbZv9HaaT9GNyF7z4Wq7JH0VIJoYZA0cjTNRSEk8y1xdMWWJS51Ha9YsB2Uv
 jHlZ7HNz5P1fa4GvH32MKu9TAYAjgL9tM5yxqfw7LcaUd6zulPZZXspvqU0T+RhRkTYsKx0aF
 UABDO6nm79w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/18/19 1:00 PM, Qu Wenruo wrote:
> 
> 
> On 2019/2/11 下午10:23, Qu Wenruo wrote:
>> [snip]
>>>>> Looking at the dev
>>>>> docs and the description for 'offset' field in btrfs_file_extent_item I
>>>>> can sort of deduce that this field will only be different than null if
>>>>> this reference is for an extent which is shared between 2 snapshots.
>>>>
>>>> Don't forget reflink and data CoW.
>>>>
>>>> Like this:
>>>>
>>>> 	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>>> 		generation 6 type 1 (regular)
>>>> 		extent data disk byte 13631488 nr 1048576
>>>> 		extent data offset 0 nr 4096 ram 1048576
>>>> 	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
>>>> 		generation 7 type 1 (regular)
>>>> 		extent data disk byte 14680064 nr 4096
>>>> 		extent data offset 0 nr 4096 ram 4096
>>>> 	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
>>>> 		generation 6 type 1 (regular)
>>>> 		extent data disk byte 13631488 nr 1048576
>>>> 		extent data offset 8192 nr 1040384 ram 1048576
>>>>
>>>> EXTENT_DATA items at 0 and 8K offset are original from one larger
>>>> extent, EXTENT_DATA item at 4K offset is newly written one.
>>>
>>> Okay this makes sense, however if we take item 8 being inserted then
>>> according to the comments, the 'offset' member for this data ref will be
>>> 0 since 8k (from key.offset) - 8k (from btrfs_file_extent_offset)?  WHy
>>> is that, shouldn't the offset here be 8k rather than 0?
>>
>> To avoid creating a new data backref item.
>>
>> I don't like this idea too, it makes btrfs check, especially lowmem
>> mode, pretty slow.
>>
>> If I'm going to re-design the on-disk format, this is definitely going
>> to disappear.
>> But the design is already here for a long long time, even it caused
>> problems before, we still need to follow the behavior.
> 
> Is there any extra suggestion on the wording about the anti-initiative
> offset used in data backref?
> 

My personal suggestion is doing simplification first like your patches,
then to discuss "design" in detail.


> Thanks,
> Qu
> 
>>
>> Thanks,
>> Qu
>>
