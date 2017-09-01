Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:37153 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdIAKVX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 06:21:23 -0400
Received: by mail-lf0-f48.google.com with SMTP id y128so7600109lfd.4
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 03:21:22 -0700 (PDT)
Message-ID: <59A9349E.1000302@gmail.com>
Date: Fri, 01 Sep 2017 12:21:18 +0200
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: number of subvolumes
References: <20170822214531.44538589@natsu>        <20170822165725.GL14804@rus.uni-stuttgart.de>        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>        <20170822180155.GM14804@rus.uni-stuttgart.de>        <22940.31139.194399.982315@tree.ty.sabi.co.uk>        <20170822204811.GO14804@rus.uni-stuttgart.de>        <20170823071821.GA28319@rus.uni-stuttgart.de>        <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>        <22943.4266.793339.528061@tree.ty.sabi.co.uk>        <20170831064916.GA5783@rus.uni-stuttgart.de>        <0b8ff573-ae13-121a-dd14-29d0de72ef58@gmail.com>        <59A81F56.70708@sarach.com.pl> <pan$30aee$f76230b$532de4a7$4d3a9985@cox.net>
In-Reply-To: <pan$30aee$f76230b$532de4a7$4d3a9985@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/31/2017 06:18 PM, Duncan wrote:
[...]
> Michał Sokołowski posted on Thu, 31 Aug 2017 16:38:14 +0200 as excerpted:
>> Is there another tool to verify fragments number of given file when
>> using compression?
> AFAIK there isn't an official one, tho someone posted a script (python, 
> IIRC) at one point and may repost it here.
>
> You can actually get the information needed from filefrag -v (and the 
> script does), but it takes a bit more effort than usual, scripted or 
> brain-power, to convert the results into real fragmentation numbers.
>
> The problem is that btrfs compression works in 128 KiB blocks, and 
> filefrag sees each of those as a fragment.  The extra effort involves 
> checking the addresses of the reported 128 KiB blocks to see if they are 
> actually contiguous, that is, one starts just after the previous one 
> ends.  If so it's actually not fragmented at that point.  But if the 
> addresses aren't contiguous, there's fragmentation at that point.
>
> I don't personally worry too much about it here, for two reasons.  First, 
> I /always/ run with the autodefrag mount option, which keeps 
> fragmentation manageable in any case[1], and second, I'm on ssd, where 
> the effects of fragmentation aren't as pronounced.  (On spinning rust 
> it's generally the seek times that dominate.  On ssds that's 0, but 
> there's still an IOPS cost.)
>
> So while I've run filefrag -v and looked at the results a few times out 
> of curiousity, and indeed could see the reported fragmentation that was 
> actually contiguous, it was simply a curiosity to me, thus my not 
> grabbing that script and putting it to immediate use.
>
> ---
> [1] AFAIK autodefrag checks fragmentation on writes, and rewrites 16 MiB 
> blocks if necessary.  If like me you always run it from the moment you 
> start putting data on the filesystem, that should work pretty well.  If 
> however you haven't been running it or doing manual defrag, because 
> defrag only works on writes and the free space may be fragmented enough 
> there's not 16 MiB blocks to write into, it may take awhile to "catch 
> up", and of course won't defrag anything that's never written to again, 
> but is often reread, making its existing fragmentation an issue.

Very comprehensive, thank you. I was asking because I'd like to learn
how really random writes by VM affects BTRFS (vs XFS,Ext4) performance
and try to develop some workaround to reduce/prevent it while having
csums, cow (snapshots) and compression.
