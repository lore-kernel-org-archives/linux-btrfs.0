Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57152 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbeAKUMl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 15:12:41 -0500
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <pan$c820$53f2dc3f$a7c2e26e$ab6cc680@cox.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <ca4fa1fc-4492-29d9-08e8-b251cb861678@mendix.com>
Date: Thu, 11 Jan 2018 21:12:39 +0100
MIME-Version: 1.0
In-Reply-To: <pan$c820$53f2dc3f$a7c2e26e$ab6cc680@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/2018 05:38 AM, Duncan wrote:
> [...]
> 
> And I've definitely noticed an effect since the ssd option stopped using 
> the 2 MiB spreading algorithm in 4.14.

Glad to hear. :-)

> In particular, while chunk usage 
> was generally stable before that and I only occasionally needed to run 
> balance to clear out empty chunks, now, balance with the usage filter 
> will apparently actively fill in empty space in existing chunks, so while 
> previously a usage-filtered balance that only rewrote one chunk didn't 
> actually free anything, simply allocating a new chunk to replace the one 
> it freed, so at least two chunks needed rewritten to actually free space 
> back to unallocated...
> 
> Now, usage-filtered rewrites of only a single chunk routinely frees the 
> allocated space, because it writes that small bit of data in the freed 
> chunk into existing free space in other chunks.

And that back-filling the existing chunks indeed also means a decrease
in total work that needs to be done. But this probably also means that
the free space gaps you have/had were rather small so they got ignored
in the past. Large free gaps would always get data written in them by
balance already. It probably also means that now you're on 4.14, much
less of these small free space gaps will be left behind, because they're
already immediately reused by new small writes.

> At least I /presume/ that new balance-usage behavior is due to the ssd 
> changes.

Most probably, yes.

>  Maybe it's due to other patches.  Either way, it's an 
> interesting and useful change. =:^)

-- 
Hans van Kranenburg
