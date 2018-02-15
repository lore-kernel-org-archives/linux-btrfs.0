Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37481 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426559AbeBOQvJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:51:09 -0500
Received: by mail-it0-f50.google.com with SMTP id d10so1333644itj.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 08:51:08 -0800 (PST)
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <pan$1e47d$b81e6870$8ea78200$5b24ec4@cox.net>
 <a344bfd4-51c3-334a-1f79-7ffe9e875128@panasas.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <77826af0-594a-01c9-35fa-1511364f0489@gmail.com>
Date: Thu, 15 Feb 2018 11:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <a344bfd4-51c3-334a-1f79-7ffe9e875128@panasas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-15 10:42, Ellis H. Wilson III wrote:
> On 02/14/2018 06:24 PM, Duncan wrote:
>>> Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No
>>> compression.  No quotas enabled.  Many (potentially tens to hundreds) of
>>> subvolumes, each with tens of snapshots.  No control over size or number
>>> of files, but directory tree (entries per dir and general tree depth)
>>> can be controlled in case that's helpful).
>>
>> ??  How can you control both breadth (entries per dir) AND depth of
>> directory tree without ultimately limiting your number of files?
> 
> I technically misspoke when I said "No control over size or number of 
> files."  There is an upper-limit to the metadata (not BTRFS, for our 
> filesystem) we can store on an accompanying SSD, which limits the number 
> of files that ultimately can live on our BTRFS RAID0'd HDDs.  The 
> current design is tuned to perform well up to that maximum, but it's a 
> relatively shallow tree, so if there were known performance issues with 
> more than N files per directory or beyond a specific depth of 
> directories I was calling out that I can change the algorithm now.
There are scaling performance issues with directory listings on BTRFS 
for directories with more than a few thousand files, but they're not 
well documented (most people don't hit them because most applications 
are designed around the expectation that directory listings will be slow 
in big directories), and I would not expect them to be much of an issue 
unless you're dealing with tens of thousands of files and particularly 
slow storage.
> 
>> Anyway, AFAIK the only performance issue there would be the (IIRC) ~65535
>> limit on directory hard links before additional ones are out-of-lined
>> into a secondary node, with the entailing performance implications.
> 
> Here I interpret "directory hard links" to mean hard links within a 
> single directory -- not real directory hard links as in Macs.  It's moot 
> anyhow, as we support hard links at a much higher level in our parallel 
> file system and no hard-links will exist whatsoever from BTRFS's 
> perspective.
> 
>> So far, so good.  But then above you mention concern about btrfs-progs
>> treating the free-space-tree (free-space-cache-v2) as read-only, and the
>> time cost of having to clear and rebuild it after a btrfs check --repair.
>>
>> Which is what triggered the mismatch warning I mentioned above.  Either
>> that raid0 data is of throw-away value appropriate to placement on a
>> raid0, and btrfs check --repair is of little concern as the benefits are
>> questionable (no guarantees it'll work and the data is either directly
>> throw-away value anyway, or there's a backup at hand that /does/ have a
>> tested guarantee of viability, or it's not worthy of being called a
>> backup in the first place), or it's not.
> 
> I think you may be looking at this a touch too black and white, but 
> that's probably because I've not been clear about my use-case.  We do 
> have mechanisms at a higher level in our parallel file system to do 
> scale-out object-based RAID, so in a way the data is "throw-away" in 
> that we can lose it without true data loss.  However, one should not 
> underestimate the foreground impact of a reconstruction of 60-80TB of 
> data, even with architectures like ours that scale reconstruction well. 
> When I lose an HDD I fully expect we will need to rebuild that entire 
> BTRFS filesystem, and we can.  But I'd like to limit it to real media 
> failure.  In other words, if I can't mount my BTRFS filesystem after 
> power-fail, and I can't run btrfs check --repair, then in essence I've 
> lost a lot of data I need to rebuild for no "good" reason.
> 
> Perhaps more critically, when an entire cluster of these systems 
> power-fail, if more than N of these running BTRFS come up and require 
> check --repair prior to mount due to some commonly triggered BTRFS bug 
> (not saying there is one, I'm just conservative), I'm completely hosed. 
> Restoring PB's of data from backup is a non-starter.
Whether or not this is likely to be an issue is just as much dependent 
on the storage hardware as how BTRFS handles it.  In my own experience, 
I've only ever lost a BTRFS volume to a power failure _once_ in the 
multiple years I've been using it, and that ended up being because the 
power failure trashed the storage device pretty severely (it was 
super-cheap flash storage).  I do know however that there are people who 
have had much worse results than me.
> 
> In short, I've been playing coy about the details of my project and need 
> to continue to do so for at least the next 4-6 months, but if you read 
> anything about the company I'm emailing from, you can probably make 
> reasonable guesses about what I'm trying to do.
> 
>> It's also worth mentioning that btrfs raid0 mode, as well as single mode,
>> hobbles the btrfs data and metadata integrity feature, because while
>> checksums can and are still generated, stored and checked by default, and
>> integrity problems can still be detected, because raid0 (and single)
>> includes no redundancy, there's no second copy (raid1/10) or parity
>> redundancy (raid5/6) to rebuild the bad data from, so it's simply gone.
> 
> I'm ok with that.  We have a concept called "on-demand reconstruction" 
> which permits us to rebuild individual objects in our filesystem 
> on-demand (one component of which will be a failed file on one of the 
> BTRFS filesystems).  So long as I can identify that a file has been 
> corrupted I'm fine.
Somewhat ironically, while BTRFS isn't yet great at fixing things when 
they go wrong, it's pretty good at letting you know something as gone 
wrong.  Unfortunately, it tends to be far more aggressive in doing so 
than it sounds like you need it to be.
> 
>> 12-14 TB individual drives?
>>
>> While you /did/ say enterprise grade so this probably doesn't apply to
>> you, it might apply to others that will read this.
>>
>> Be careful that you're not trying to use the "archive application"
>> targeted SMR drives for general purpose use.
> 
> We're using traditional PMR drives for now.  That's available at 12/14TB 
> capacity points presently.  I agree with your general sense that SMR 
> drives are unlikely to play particularly well with BTRFS for all but the 
> truly archival use-case.
It's not exactly a 'general sense' or a hunch, issues with BTRFS on SMR 
drives have been pretty well demonstrated in practice, hence Duncan 
making this statement despite the fact that it most likely did not apply 
to you.
