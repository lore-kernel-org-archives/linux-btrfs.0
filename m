Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35486 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbcH2HZg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 03:25:36 -0400
Received: by mail-wm0-f51.google.com with SMTP id f65so65979318wmi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 00:25:07 -0700 (PDT)
Subject: Re: Crash in btrfs_uuid_tree_iterate during mount
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <57A473B0.2040203@kyup.com>
 <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com> <57A863C6.5060503@kyup.com>
 <ce59ace9-9cf3-ec8e-1f25-d6b794cf5109@fb.com> <57A89583.6070600@kyup.com>
 <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
Cc: SiteGround Operations <operations@siteground.com>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <57C3E34F.30804@kyup.com>
Date: Mon, 29 Aug 2016 10:25:03 +0300
MIME-Version: 1.0
In-Reply-To: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/08/2016 05:24 PM, Chris Mason wrote:
> On 08/08/2016 10:21 AM, Nikolay Borisov wrote:
>>
>>
>> On 08/08/2016 05:16 PM, Chris Mason wrote:
>>>
>>> Fantastic, thanks again for digging through it.  Making the patch is
>>> much easier than testing the patch in this case.  If you can trigger
>>> this semi-reliably, we can add some debugging to make sure we're not
>>> papering over some other problem.
>>
>> I don;'t have a reproducer per-se, but I have a fair number of servers,
>> whose workload causes the issue, so if I patch btrfs and apply it to
>> 5-10 server I;d expect at least one of them to show what the real
>> issue is.
>>
> 
> Ok, I'll try and get a patch out before my vacation on Wednesday.  Thanks!

Ping


> 
> -chris
