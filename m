Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f53.google.com ([209.85.167.53]:43671 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbeH1HT2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 03:19:28 -0400
Received: by mail-lf1-f53.google.com with SMTP id h64-v6so125079lfi.10
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 20:29:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Aug 2018 21:29:53 -0600
Message-ID: <CAJCQCtQhoKHNAUTeFKowmXMV6brqr08FO+yyCUYGjJ-82RiFmA@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 8:12 PM, Larkin Lowrey
<llowrey@nuclearwinter.com> wrote:
> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>
>>
>>> The system uses ECC memory and edac-util has not reported any errors.
>>> However, I will run a memtest anyway.
>>
>> So it should not be the memory problem.
>>
>> BTW, what's the current generation of the fs?
>>
>> # btrfs inspect dump-super <device> | grep generation
>>
>> The corrupted leaf has generation 2862, I'm not sure how recent did the
>> corruption happen.
>
>
> generation              358392
> chunk_root_generation   357256
> cache_generation        358392
> uuid_tree_generation    358392
> dev_item.generation     0
>
> I don't recall the last time I ran a scrub but I doubt it has been more than
> a year.
>
> I am running 'btrfs check --init-csum-tree' now. Hopefully that clears
> everything up.


I'd expect --init-csum-tree on recreates the data csum tree, and will
not assume metadata leaf is correct and just recompute a csum for it.


-- 
Chris Murphy
