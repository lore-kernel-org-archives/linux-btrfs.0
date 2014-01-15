Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42022 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAOTkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 14:40:35 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: why am  I getting "No space left on device" here?
Date: Wed, 15 Jan 2014 20:40:29 +0100
Message-ID: <2656163.prAmgAF69M@merkaba>
In-Reply-To: <pan$6d4dc$e3f7651a$b8f89b4a$ecb5f643@cox.net>
References: <20140115115543.790adafb@wpkg.org> <pan$6d4dc$e3f7651a$b8f89b4a$ecb5f643@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 15. Januar 2014, 19:05:41 schrieb Duncan:
> But just as my already allocated mixed-mode chunks were just about full 
> and I needed another one allocated to complete the job, so your data 
> chunks are full or very close, according to btrfs fi df, and you need a 
> new one allocated (and if the file is greater than a gig in size, likely 
> more than one) to finish the job.
> 
> And in both our cases, there's plenty of unallocated space in the pool, 
> but for whatever reason, btrfs isn't allocating that new chunk when it 
> should!  Why, I can't say, but as I mentioned, I was able to work around 
> the problem here by trying the remaining files in a different order, and 
> at some point, btrfs figured out it needed that new chunk allocated, and 
> everything went fine after that.
> 
> So... why btrfs is failing to allocate a new chunk when it needs to I 
> can't say, but I *CAN* say you're not the only one to have run into the 
> problem recently; I did too.
> 
> And just as I did, here, with a bit of monkeying around, you can 
> /probably/ get btrfs to allocate that new data chunk and get on with 
> things.  But the trouble is, since I don't know what the exact problem is 
> or what exactly I did to persuade btrfs to do that new chunk allocation, 
> I can't tell you exactly what to do to get it to happen, all I can do is 
> suggest you try copying smaller files or files of different sizes around 
> a bit, hoping to trigger that allocation.
> 
> Once that chunk allocation happens, you should be good for at least a 
> gig, since that's the data-chunk size, but if your file is over a gig in 
> size, you may run into the problem again.  In that case...  Well, you 
> could try copying several gigs of smaller files, then once it allocates 
> what you need, delete them, leaving the data chunks allocated but with 
> enough unused space to copy the original multi-gig file over.

I think you can cause BTRFS to allocate a chunk or more by creating a file with 
the fallocate command. Unless BTRFS doesn´t do it due to a bug and errors out 
with no space left.

fallocate gives also an easy way to find out how much it might still allocate 
and at what point it fails – and that without writing tons of data first. 
fallocate just triggers allocation and does not write any actual data.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
