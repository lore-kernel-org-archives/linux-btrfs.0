Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59864 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752AbaBGFat convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 00:30:49 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Provide a better free space estimate on RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140207104005.7bd1438a@natsu>
Date: Thu, 6 Feb 2014 22:30:46 -0700
Cc: kreijack@inwind.it, kreijack@libero.it,
        Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Message-Id: <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
References: <20140206021516.304732cd@natsu> <52F33BE7.4020708@swiftspirit.co.za> <20140206184502.128b7dbe@natsu> <52F3E86B.4030805@libero.it> <20140207104005.7bd1438a@natsu>
To: Roman Mamedov <rm@romanrm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 6, 2014, at 9:40 PM, Roman Mamedov <rm@romanrm.net> wrote:

> On Thu, 06 Feb 2014 20:54:19 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
>> I agree with you about the needing of a solution. However your patch to me seems even worse than the actual code.
>> 
>> For example you cannot take in account the mix of data/linear and metadata/dup (with the pathological case of small files stored in the metadata chunks ), nor different profile level like raid5/6 (or the future raidNxM)
>> And do not forget the compression...
> 
> Every estimate first and foremost should be measured by how precise it is, or
> in this case "wrong by how many gigabytes". The actual code returns a result
> that is pretty much always wrong by 2x, after the patch it will be close
> within gigabytes to the correct value in the most common use case (data raid1,
> metadata raid1 and that's it). Of course that PoC is nowhere near the final
> solution, what I can't agree with is "if another option is somewhat better,
> but not ideally perfect, then it's worse than the current one", even
> considering the current one is absolutely broken.

Is the glass half empty or is it half full?

>From the original post, context is a 2x 1TB raid volume:

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2

Earlier conventions would have stated Size ~900GB, and Avail ~900GB. But that's not exactly true either, is it? It's merely a convention to cut the storage available in half, while keeping data file sizes the same as if they were on a single device without raid.

On Btrfs the file system Size is reported as the total storage stack size, and that's not incorrect. And the amount Avail is likewise not wrong because that space is "not otherwise occupied" which is the definition of available. It's linguistically consistent, it's just not a familiar convention.

What I don't care for is the fact that btrfs fi df doesn't report total and used for raid1, the user has to mentally double the displayed values. I think the doubling should already be computed, that's what total and used mean, rather than needing secret decoder ring knowledge to understand the situation.

Anyway, there isn't a terribly good solution for this issue still. But I don't find the argument that it's absolutely broken very compelling. And I disagree that upending Used+Avail=Size as you suggest is a good alternative. How is that going to work, by the way?

Your idea:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1.8T  1.1M  912G   1% /mnt/p2

If I copy 500GB to this file system, what do you propose df shows me? Clearly Size stays the same, and Avail presumably becomes 412G. But what does Used go to? 500G? Or 1T? And when full, will it say Size 1.8T, Used 900G, Avail 11M? So why is the Size 1.8T, only 900G used and yet it's empty? That doesn't make sense. Nor does Used increasing at twice the rate Avail goes down.

I also don't think it's useful to fix the problem more than once either.



Chris Murphy

