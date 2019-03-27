Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C67C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85622054F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="PHPZNFrJ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="agUpJ+0/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbfC0UgC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:36:02 -0400
Received: from a4-15.smtp-out.eu-west-1.amazonses.com ([54.240.4.15]:36186
        "EHLO a4-15.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728922AbfC0UgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1553718958;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=05DsaJUgsuWiB3DFwlUDc70ppMO1/vg9runCo2bMtw8=;
        b=PHPZNFrJmUxLkv518hmu2OdnCY3Ldl0UsqxLZ+yHh+00MsvgYWus8M2ANWhl+8/z
        keNI9cz59jWNkupp7enOTq6Zc4/t42DoCu3xoAwqv5IUtFRU51OSlJWMYpujs4JEoj6
        TcT59emTTadOFJ4N7KvEhjameolm3McxEqNwZk4c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1553718958;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=05DsaJUgsuWiB3DFwlUDc70ppMO1/vg9runCo2bMtw8=;
        b=agUpJ+0/TswosDbSUTd0r+90G2ev0+aWpwqb09/ev7eZipASh5vxEyZb+dggXRp1
        qCWdp7iFmcIw4wTYmGiQtu+BRBIJvIMnl2QHpNtOJRmiG9KPzwznxiK9vuvA9/RlwqU
        PZYOhg1xNFkO7jHnGch8sEigEOP/L9L4DJxyw0mI=
Subject: =?UTF-8?Q?Re=3a_backup_uuid=5ftree_generation_not_consistent_across?=
 =?UTF-8?Q?_multi_device_=28raid0=29_btrfs_-_won=c2=b4t_mount?=
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
 <cc557b84-602c-8b2e-33f9-3c6d56578631@gmx.com>
 <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>
 <0b96fc73-b6ce-f548-a61d-b3092d3534eb@gmx.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020169c0ddd825-7eef5c9d-5269-4a27-b5ef-f6df837aabfb-000000@eu-west-1.amazonses.com>
Date:   Wed, 27 Mar 2019 20:35:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <0b96fc73-b6ce-f548-a61d-b3092d3534eb@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2019.03.27-54.240.4.15
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 26.03.2019 14:37 Qu Wenruo wrote:
> On 2019/3/26 下午6:24, berodual_xyz wrote:
>> Mount messages below.
>>
>> Thanks for your input, Qu!
>>
>> ##
>> [42763.884134] BTRFS info (device sdd): disabling free space tree
>> [42763.884138] BTRFS info (device sdd): force clearing of disk cache
>> [42763.884140] BTRFS info (device sdd): has skinny extents
>> [42763.885207] BTRFS error (device sdd): parent transid verify failed on 1048576 wanted 60234 found 60230
> So btrfs is using the latest superblock while the good one should be the
> old superblock.
>
> Btrfs-progs is able to just ignore the transid mismatch, but kernel
> doesn't and shouldn't.
>
> In fact we should allow btrfs rescue super to use super blocks from
> other device to replace the old one.
>
> So my patch won't help at all, the failure happens at the very beginning
> of the devices list initialization.
>
> BTW, if btrfs restore can't recover certain files, I don't believe any
> rescue kernel mount option can do more.
>
> Thanks,
> Qu

I have made btrfs limp along (till a rebuild) in the past by commenting
out/removing the transid checks. Obviously you should still mount it
read-only (and with no log replay) and it might crash, but there is a
small chance this would work.

>
>> [42763.885263] BTRFS error (device sdd): failed to read chunk root
>> [42763.900922] BTRFS error (device sdd): open_ctree failed
>> ##
>>
>>
>>
>>
>> Sent with ProtonMail Secure Email.
>>
>> ‐‐‐‐‐‐‐ Original Message ‐‐‐‐‐‐‐
>> On Tuesday, 26. March 2019 10:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>> On 2019/3/26 下午4:52, berodual_xyz wrote:
>>>
>>>> Thank you both for your input.
>>>> see below.
>>>>
>>>>>> You sda and sdb are at gen 60233 while sdd and sde are at gen 60234.
>>>>>> It's possible to allow kernel to manually assemble its device list using
>>>>>> "device=" mount option.
>>>>>> Since you're using RAID6, it's possible to recover using 2 devices only,
>>>>>> but in that case you need "degraded" mount option.
>>>>> He has btrfs raid0 profile on top of hardware RAID6 devices.
>>>> Correct, my FS is a "raid0" across four hardware-raid based raid6 devices. The underlying devices of the raid controller are fine, same as the volumes themselves.
>>> Then there is not much we can do.
>>>
>>> The super blocks shows all your 4 devices are in 2 different states.
>>> (older generation with dirt log, newer generation without log).
>>>
>>> This means some writes didn't reach all devices.
>>>
>>>> Only corruption seems to be on the btrfs side.
>>> Please provide the kernel message when trying to mount the fs.
>>>
>>>> Does your tip regarding mounting by explicitly specifying the devices still make sense?
>>> Not really. For RAID0 case, it doesn't make much sense.
>>>
>>>> Will this figure out automatically which generation to use?
>>> You could try, as all the mount option is making btrfs completely RO (no
>>> log replay), so it should be pretty safe.
>>>
>>>> I am at the moment in the process of using "btrfs restore" to pull more data from the filesystem without making any further changes.
>>>> After that I am happy to continue testing, and will happily test your mentioned "skip_bg" patch - but if you think that there is some other way to mount (just for recovery purpose - read only is fine!) while having different gens on the devices, I highly appreciate it.
>>> With mounting failure dmesg, it should be pretty easy to determine
>>> whether my skip_bg will work.
>>>
>>> Thanks,
>>> Qu
>>>
>>>> Thanks Qu and Andrei!


