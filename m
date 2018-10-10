Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90DBC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC102086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nuclearwinter.com header.i=@nuclearwinter.com header.b="TPxDF4Y0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BC102086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuclearwinter.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeJJXHV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 19:07:21 -0400
Received: from titan.nuclearwinter.com ([205.185.120.7]:55178 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeJJXHV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 19:07:21 -0400
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id w9AFiRPC000867
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 10 Oct 2018 11:44:28 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com w9AFiRPC000867
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1539186269;
        bh=Kq6sv4jzGd/IpSvyzHp6BpdVB4s9njGcGjjTNCI7htw=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=TPxDF4Y05eRgOjwrqgvA45hi4FirHZhXa54j01pzIMKOsglijVwSdrT2qINh0fk4j
         AlBdMNL6BriVNgKDzvTZK41epiTRG7fgkKIjsDB7zOXq0vqYFJYGGQjGsK5skFgNVP
         8uOxzB6ov7hWFvPDTOAN4W8UGTRUuj48Fq9V7utE=
Subject: Re: Scrub aborts due to corrupt leaf
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
Message-ID: <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
Date:   Wed, 10 Oct 2018 11:44:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.16 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Wed, 10 Oct 2018 11:44:29 -0400 (EDT)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/11/2018 11:23 AM, Larkin Lowrey wrote:
> On 8/29/2018 1:32 AM, Qu Wenruo wrote:
>>
>> On 2018/8/28 下午9:56, Chris Murphy wrote:
>>> On Tue, Aug 28, 2018 at 7:42 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> 
>>> wrote:
>>>>
>>>> On 2018/8/28 下午9:29, Larkin Lowrey wrote:
>>>>> On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
>>>>>> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>>>>>>> The system uses ECC memory and edac-util has not reported any 
>>>>>>>> errors.
>>>>>>>> However, I will run a memtest anyway.
>>>>>>> So it should not be the memory problem.
>>>>>>>
>>>>>>> BTW, what's the current generation of the fs?
>>>>>>>
>>>>>>> # btrfs inspect dump-super <device> | grep generation
>>>>>>>
>>>>>>> The corrupted leaf has generation 2862, I'm not sure how recent 
>>>>>>> did the
>>>>>>> corruption happen.
>>>>>> generation              358392
>>>>>> chunk_root_generation   357256
>>>>>> cache_generation        358392
>>>>>> uuid_tree_generation    358392
>>>>>> dev_item.generation     0
>>>>>>
>>>>>> I don't recall the last time I ran a scrub but I doubt it has been
>>>>>> more than a year.
>>>>>>
>>>>>> I am running 'btrfs check --init-csum-tree' now. Hopefully that 
>>>>>> clears
>>>>>> everything up.
>>>>> No such luck:
>>>>>
>>>>> Creating a new CRC tree
>>>>> Checking filesystem on /dev/Cached/Backups
>>>>> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
>>>>> Reinitialize checksum tree
>>>>> csum result is 0 for block 2412149436416
>>>>> extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, 
>>>>> value -28
>>>> It's ENOSPC, meaning btrfs can't find enough space for the new csum 
>>>> tree
>>>> blocks.
>>> Seems bogus, there's >4TiB unallocated.
>> What a shame.
>> Btrfs won't try to allocate new chunk if we're allocating new tree
>> blocks for metadata trees (extent, csum, etc).
>>
>> One quick (and dirty) way to avoid such limitation is to use the
>> following patch
>
>> <<patch removed>>
>
> No luck.
>
> # ./btrfs check --init-csum-tree /dev/Cached/Backups
> Creating a new CRC tree
> Opening filesystem to check...
> Checking filesystem on /dev/Cached/Backups
> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
> Reinitialize checksum tree
> Segmentation fault (core dumped)
>
>  btrfs[16575]: segfault at 7ffc4f74ef60 ip 000000000040d4c3 sp 
> 00007ffc4f74ef50 error 6 in btrfs[400000+bf000]
>
> # ./btrfs --version
> btrfs-progs v4.17.1
>
> I cloned  btrfs-progs from git and applied your patch.
>
> BTW, I've been having tons of trouble with two hosts after updating 
> from kernel 4.17.12 to 4.17.14 and beyond. The fs will become 
> unresponsive and all processes will end up stuck waiting on io. The 
> system will end up totally idle but unable perform any io on the 
> filesystem. So far things have been stable after reverting back to 
> 4.17.12. It looks like there was a btrfs change in 4.17.13. Could that 
> be related to this csum tree corruption?

About once a week, or so, I'm running into the above situation where FS 
seems to deadlock. All IO to the FS blocks, there is no IO activity at 
all. I have to hard reboot the system to recover. There are no error 
indications except for the following which occurs well before the FS 
freezes up:

BTRFS warning (device dm-3): block group 78691883286528 has wrong amount 
of free space
BTRFS warning (device dm-3): failed to load free space cache for block 
group 78691883286528, rebuilding it now

Do I have any options other the nuking the FS and starting over?

--Larkin
