Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36966 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751857AbdHaQTR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 12:19:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dnSBQ-000878-PK
        for linux-btrfs@vger.kernel.org; Thu, 31 Aug 2017 18:19:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: number of subvolumes
Date: Thu, 31 Aug 2017 16:18:52 +0000 (UTC)
Message-ID: <pan$30aee$f76230b$532de4a7$4d3a9985@cox.net>
References: <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822204811.GO14804@rus.uni-stuttgart.de>
        <20170823071821.GA28319@rus.uni-stuttgart.de>
        <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
        <22943.4266.793339.528061@tree.ty.sabi.co.uk>
        <20170831064916.GA5783@rus.uni-stuttgart.de>
        <0b8ff573-ae13-121a-dd14-29d0de72ef58@gmail.com>
        <59A81F56.70708@sarach.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michał Sokołowski posted on Thu, 31 Aug 2017 16:38:14 +0200 as excerpted:

> On 08/31/2017 01:18 PM, Austin S. Hemmelgarn wrote:
>> [...]
>>> Any hint here?
>> Having compression enabled causes no issues with defray and balance.
>> There appears to be a prevalent belief however that defrag is pointless
>> if you're using compression, probably because some versions of
>> `filefrag` don't report compressed extents properly (they list each
>> 128k compressed unit as one extent, which is wrong).
> Is there another tool to verify fragments number of given file when
> using compression?

AFAIK there isn't an official one, tho someone posted a script (python, 
IIRC) at one point and may repost it here.

You can actually get the information needed from filefrag -v (and the 
script does), but it takes a bit more effort than usual, scripted or 
brain-power, to convert the results into real fragmentation numbers.

The problem is that btrfs compression works in 128 KiB blocks, and 
filefrag sees each of those as a fragment.  The extra effort involves 
checking the addresses of the reported 128 KiB blocks to see if they are 
actually contiguous, that is, one starts just after the previous one 
ends.  If so it's actually not fragmented at that point.  But if the 
addresses aren't contiguous, there's fragmentation at that point.

I don't personally worry too much about it here, for two reasons.  First, 
I /always/ run with the autodefrag mount option, which keeps 
fragmentation manageable in any case[1], and second, I'm on ssd, where 
the effects of fragmentation aren't as pronounced.  (On spinning rust 
it's generally the seek times that dominate.  On ssds that's 0, but 
there's still an IOPS cost.)

So while I've run filefrag -v and looked at the results a few times out 
of curiousity, and indeed could see the reported fragmentation that was 
actually contiguous, it was simply a curiosity to me, thus my not 
grabbing that script and putting it to immediate use.

---
[1] AFAIK autodefrag checks fragmentation on writes, and rewrites 16 MiB 
blocks if necessary.  If like me you always run it from the moment you 
start putting data on the filesystem, that should work pretty well.  If 
however you haven't been running it or doing manual defrag, because 
defrag only works on writes and the free space may be fragmented enough 
there's not 16 MiB blocks to write into, it may take awhile to "catch 
up", and of course won't defrag anything that's never written to again, 
but is often reread, making its existing fragmentation an issue.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

