Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:51634 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbeH1GBl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 02:01:41 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
From: Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
Date: Mon, 27 Aug 2018 22:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>
>> The system uses ECC memory and edac-util has not reported any errors.
>> However, I will run a memtest anyway.
> So it should not be the memory problem.
>
> BTW, what's the current generation of the fs?
>
> # btrfs inspect dump-super <device> | grep generation
>
> The corrupted leaf has generation 2862, I'm not sure how recent did the
> corruption happen.

generation              358392
chunk_root_generation   357256
cache_generation        358392
uuid_tree_generation    358392
dev_item.generation     0

I don't recall the last time I ran a scrub but I doubt it has been more 
than a year.

I am running 'btrfs check --init-csum-tree' now. Hopefully that clears 
everything up.

Thank you for your help and advice,

--Larkin
