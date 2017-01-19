Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38807 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbdASRHc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 12:07:32 -0500
Received: by mail-it0-f44.google.com with SMTP id c7so1307613itd.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 09:06:38 -0800 (PST)
Subject: Re: Fwd: dup vs raid1 in single disk
To: "Alejandro R. Mosteo" <alejandro@mosteo.com>, linux-btrfs@vger.kernel.org
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
 <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <96508d61-719e-6103-ea16-6be1fdb0aca4@gmail.com>
Date: Thu, 19 Jan 2017 12:06:32 -0500
MIME-Version: 1.0
In-Reply-To: <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-19 11:39, Alejandro R. Mosteo wrote:
> Hello list,
>
> I was wondering, from a point of view of data safety, if there is any
> difference between using dup or making a raid1 from two partitions in
> the same disk. This is thinking on having some protection against the
> typical aging HDD that starts to have bad sectors.
>
> On a related note, I see this caveat about dup in the manpage:
>
> "For example, a SSD drive can remap the blocks internally to a single
> copy thus deduplicating them. This negates the purpose of increased
> redunancy (sic) and just wastes space"
>
> SSDs failure modes are different (more an all or nothing thing, I'm
> told) so it wouldn't apply to the use case above, but I'm curious for
> curiosity's sake if there would be any difference too.

On a traditional HDD, there actually is a reasonable safety benefit to 
using 2 partitions in raid1 mode over using dup mode.  This is because 
most traditional HDD firmware still keeps the mapping of physical 
sectors to logical sectors mostly linear, so having separate partitions 
will (usually) mean that the two copies are not located near each other 
on physical media.  A similar but weaker version of the same effect can 
be achieved by using the 'ssd_spread' mount option, but I would not 
suggest relying on that.  This doesn't apply to hybrid drives (because 
they move stuff around however they want like SSD's), or SMR drives 
(because they rewrite large portions of the disk when one place gets 
rewritten, so physical separation of the data copies doesn't get you as 
much protection).

For most SSD's, there is no practical benefit because the FTL in the SSD 
firmware generally maps physical sectors to logical sectors in whatever 
arbitrary way it wants, which is usually not going to be linear.

As far as failure modes on an SSD, you usually see one of two things 
happen, either the whole disk starts acting odd (or stops working), or 
individual blocks a few MB in size (which seem to move around the disk 
as they get over-written) start behaving odd.  The first case is the 
firmware or primary electronics going bad, while the second is 
individual erase blocks going bad.  As a general rule, SSD's will run 
longer as they're going bad than HDD's will, but in both cases you 
should look at replacing the device once you start seeing the error 
counters going up consistently over time (or if you see them suddenly 
jump to a much higher number).
