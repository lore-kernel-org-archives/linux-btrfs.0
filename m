Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38715 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbLVMRS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:17:18 -0500
Received: by mail-ig0-f171.google.com with SMTP id jw2so56721991igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 04:17:18 -0800 (PST)
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1450069158.2388.72.camel@scientia.net> <566ECF41.10709@gmail.com>
 <1450149311.701.126.camel@scientia.net> <56703928.7070003@gmail.com>
 <1450318197.6242.170.camel@scientia.net> <56780042.5060307@gmail.com>
 <pan$b5e12$31be6ea6$fd54b60e$5d72fa7a@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56793F26.1030302@gmail.com>
Date: Tue, 22 Dec 2015 07:16:38 -0500
MIME-Version: 1.0
In-Reply-To: <pan$b5e12$31be6ea6$fd54b60e$5d72fa7a@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-22 04:12, Duncan wrote:
> Austin S. Hemmelgarn posted on Mon, 21 Dec 2015 08:36:02 -0500 as
> excerpted:
>
>> On 2015-12-16 21:09, Christoph Anton Mitterer wrote:
>
>>> On Tue, 2015-12-15 at 11:00 -0500, Austin S. Hemmelgarn wrote:
>
>>>> nodatacow only [avoids fragmentation] if the file is
>>>> pre-allocated, if it isn't, then it still ends up fragmented.
>
>>> Hmm is that "it may end up fragmented" or a "it will definitely? Cause
>>> I'd have hoped, that if nothing else had been written in the meantime,
>>> btrfs would perhaps try to write next to the already allocated blocks.
>
>> If there are multiple files being written, then there is a relatively
>> high probability that they will end up fragmented if they are more than
>> about 64k and aren't pre-allocated.
>
> Does the 30-second-by-default commit window (and similarly 30-second-
> default dirty-flush-time at the VFS level) modify this at all?  It has
> been my assumption that same-file writes accumulated during this time
> should merge, increasing efficiency and decreasing fragmentation (both
> with and without nocow), tho of course further writes outside this 30-
> second window will likely trigger it, if other files have been written in
> parallel or in the mean time.
>
I think it does, but not much, and it depends on the workload.  I do 
notice less fragmentation on the filesystems I increase the commit 
window on, and more on ones I decrease it, but the difference is pretty 
small as long as you use something reasonable (I've never tested 
anything higher than 300, and I rarely go above 60).  My guess based on 
what the commit window is for (namely, it's the amount of time the log 
tree gets updated before forcing a transaction to be committed) would be 
that it has less effect if stuff is regularly calling fsync().
