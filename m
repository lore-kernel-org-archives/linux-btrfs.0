Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54631 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754841AbcJRE2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 00:28:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bwM07-0003Dy-2k
        for linux-btrfs@vger.kernel.org; Tue, 18 Oct 2016 06:27:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: speed up cp --reflink=always
Date: Tue, 18 Oct 2016 04:27:29 +0000 (UTC)
Message-ID: <pan$96d47$1ea9f2f$a24464c5$13bbbcb3@cox.net>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
        <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
        <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
        <db2d3b51-1e3d-1308-3f26-1df96764d9fe@cn.fujitsu.com>
        <ca6a57c9-4bb3-a81c-4beb-770f5331e994@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG posted on Mon, 17 Oct 2016 08:50:37 +0200 as
excerpted:

> Am 17.10.2016 um 03:50 schrieb Qu Wenruo:
>> At 10/17/2016 02:54 AM, Stefan Priebe - Profihost AG wrote:
>>> Am 16.10.2016 um 00:37 schrieb Hans van Kranenburg:
>>>> Hi,
>>>>
>>>> On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
>>>>>
>>>>> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
>>>>>
>>>>> An example:
>>>>>
>>>>> source file:
>>>>> # ls -la vm-279-disk-1.img
>>>>> [...] 204010946560 Oct 14 12:15 vm-279-disk-1.img
>>>>>
>>>>> target file after around 10 minutes:
>>>>> # ls -la vm-279-disk-1.img.tmp
>>>>> [...] 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp
>>>>
>>>> Two quick thoughts:
>>>> 1. How many extents does this img have?
>>>
>>> filefrag says:
>>> 1011508 extents found
>> 
>> Too many fragments.
>> Average extent size is only about 200K.
>> Quite common for VM images, if not setting no copy-on-write (C) attr.
>> 
>> Normally it's not a good idea to put VM images into btrfs without any
>> tuning.
> 
> Those are backups just written sequentially once. As far as i know the
> extent size is hardcoded to 128k for compression. Isn't it?

I flagged that as I read it, too, but...

200 KB extents average suggests it can't be compressed, because if it 
were they'd be 128 KB extents, not 200 KB.  That's a difference of over 
half a million extents (128 KB would be ~1.5565 million extents, while 
just over a million are reported), too much to be rounding error, so the 
evidence doesn't support btrfs compression being the culprit.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

