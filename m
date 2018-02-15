Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:37856 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164177AbeBOR5V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 12:57:21 -0500
Received: by mail-io0-f170.google.com with SMTP id t126so1487692iof.4
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 09:57:20 -0800 (PST)
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <pan$1e47d$b81e6870$8ea78200$5b24ec4@cox.net>
 <a344bfd4-51c3-334a-1f79-7ffe9e875128@panasas.com>
 <77826af0-594a-01c9-35fa-1511364f0489@gmail.com>
 <39aa2851-2c0a-d6c4-6ccf-d364c4aacbf4@panasas.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2d653ebf-11b0-2163-a223-609420423a5b@gmail.com>
Date: Thu, 15 Feb 2018 12:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <39aa2851-2c0a-d6c4-6ccf-d364c4aacbf4@panasas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-15 11:58, Ellis H. Wilson III wrote:
> On 02/15/2018 11:51 AM, Austin S. Hemmelgarn wrote:
>> There are scaling performance issues with directory listings on BTRFS 
>> for directories with more than a few thousand files, but they're not 
>> well documented (most people don't hit them because most applications 
>> are designed around the expectation that directory listings will be 
>> slow in big directories), and I would not expect them to be much of an 
>> issue unless you're dealing with tens of thousands of files and 
>> particularly slow storage.
> 
> Understood -- thanks.  Then plan is to keep it to around 1k entries per 
> directory.  We've done some fairly concrete testing here to find the 
> fall-off point for dirent caching in BTRFS, and the sweet-spot between 
> having a large number of small directories cached vs. a few massive 
> directories cached.  ~1k seems most palatable for our use-case and 
> directory tree structure.
Yeah, in my own experience this starts to get noticeable on slower 
storage around about 4k or more entries in a directory, but it ends up 
depending on the hardware to a certain extent and the rest of the system 
as well (something Samba does seems to make it significantly worse than 
listing locally for example, while NFS seems to be only be worse because 
of network latency).
> 
>> I've only ever lost a BTRFS volume to a power failure _once_ in the 
>> multiple years I've been using it, and that ended up being because the 
>> power failure trashed the storage device pretty severely (it was 
>> super-cheap flash storage).  I do know however that there are people 
>> who have had much worse results than me.
> 
> Good to know.  We'll be running power-fail testing over the next couple 
> months.  I'm waiting for some hardware to arrive presently.  We'll 
> power-cycle fairly large filesystems a few thousand times before we deem 
> it safe to ship.  If there are latent bugs in BTRFS still w.r.t. 
> power-fail, I can guarantee we'll trip over them...
Most of my own experience regarding power failures with BTRFS is on 
SSD's.  We actually use it on the embedded systems we build where I 
work, and a lot of our customers don't have the most reliable mains 
power (or they're too lazy to shut off the computer properly before 
flipping the main breaker for the machine to power it off for the 
evening), so some of our systems may see power failures on an almost 
daily basis.  Despite that, we've never had issues with BTRFS not 
recovering by itself, though we do have a very read-heavy workload with 
very infrequent writes, so that may be part of why it's worked so well 
for us.
