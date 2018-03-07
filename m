Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933351AbeCGPWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:22:10 -0500
Subject: Re: [PATCH] Btrfs: scrub: batch rebuild for raid56
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180302231041.10442-1-bo.li.liu@oracle.com>
 <20180306104747.GM5942@twin.jikos.cz>
 <20180306182220.GM30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <20180307144310.GC23693@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e252bc9f-4d56-45c1-5998-60f125364514@suse.com>
Date: Wed, 7 Mar 2018 17:22:08 +0200
MIME-Version: 1.0
In-Reply-To: <20180307144310.GC23693@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.03.2018 16:43, David Sterba wrote:
> On Tue, Mar 06, 2018 at 11:22:21AM -0700, Liu Bo wrote:
>> On Tue, Mar 06, 2018 at 11:47:47AM +0100, David Sterba wrote:
>>> On Fri, Mar 02, 2018 at 04:10:37PM -0700, Liu Bo wrote:
>>>> In case of raid56, writes and rebuilds always take BTRFS_STRIPE_LEN(64K)
>>>> as unit, however, scrub_extent() sets blocksize as unit, so rebuild
>>>> process may be triggered on every block on a same stripe.
>>>>
>>>> A typical example would be that when we're replacing a disappeared disk,
>>>> all reads on the disks get -EIO, every block (size is 4K if blocksize is
>>>> 4K) would go thru these,
>>>>
>>>> scrub_handle_errored_block
>>>>   scrub_recheck_block # re-read pages one by one
>>>>   scrub_recheck_block # rebuild by calling raid56_parity_recover()
>>>>                         page by page
>>>>
>>>> Although with raid56 stripe cache most of reads during rebuild can be
>>>> avoided, the parity recover calculation(xor or raid6 algorithms) needs to
>>>> be done $(BTRFS_STRIPE_LEN / blocksize) times.
>>>>
>>>> This makes it less stupid by doing raid56 scrub/replace on stripe length.
>>>
>>> missing s-o-b
>>
>> I'm surprised that checkpatch.pl didn't complain.

I have written a python script that can scrape the mailing list and run
checkpatch (and any other software deemed appropriate) on posted patches
and reply back with results. However, I haven't really activated it, I
guess if people think there is merit in it I could hook it up to the
mailing list :)

> 
> Never mind, I'm your true checkpatch.cz
> 
> (http://checkpatch.pl actually exists)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
