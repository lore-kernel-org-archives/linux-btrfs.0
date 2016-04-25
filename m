Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35800 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbcDYLSw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 07:18:52 -0400
Received: by mail-ig0-f176.google.com with SMTP id bi2so62400644igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 04:18:52 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id nj19sm8724255igb.19.2016.04.25.04.18.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 25 Apr 2016 04:18:50 -0700 (PDT)
Subject: Re: Add device while rebalancing
To: linux-btrfs@vger.kernel.org
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
 <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <571DFCF2.6050604@gmail.com>
Date: Mon, 25 Apr 2016 07:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-23 01:38, Duncan wrote:
> Juan Alberto Cirez posted on Fri, 22 Apr 2016 14:36:44 -0600 as excerpted:
>
>> Good morning,
>> I am new to this list and to btrfs in general. I have a quick question:
>> Can I add a new device to the pool while the btrfs filesystem balance
>> command is running on the drive pool?
>
> Adding a device while balancing shouldn't be a problem.  However,
> depending on your redundancy mode, you may wish to cancel the balance and
> start a new one after the device add, so the balance will take account of
> it as well and balance it into the mix.
I'm not 100% certain about how balance will handle this, except that 
nothing should break.  I believe that it picks a device each time it 
goes to move a chunk, so it should evaluate any chunks operated on after 
the addition of the device for possible placement on that device (and it 
will probably end up putting a lot of them there because that device 
will almost certainly be less full than any of the others).  That said, 
you probably do want to cancel the balance, add the device, and re-run 
the balance so that things end up more evenly distributed.
>
> Note that while device add doesn't do more than that on its own, device
> delete/remove effectively initiates its own balance, moving the chunks on
> the device being removed to the other devices.  So you wouldn't want to
> be running a balance and then do a device remove at the same time.
IIRC, trying to delete a device while running a balance will fail, and 
return an error, because only one balance can be running at a given moment.
>
> Similarly with btrfs replace, altho in that case, it's more directly
> moving data from the device being replaced (if it's still there, or using
> redundancy or parity to recover it if not) to the replacement device, a
> more limited and often faster operation.  But you probably still don't
> want to do a balance at the same time as it places unnecessary stress on
> both the filesystem and the hardware, and even if the filesystem and
> devices handle the stress fine, the result is going to be that both
> operations take longer as they're both intensive operations that will
> interfere with each other to some extent.
Agreed, this is generally not a good idea because of the stress it puts 
on the devices (and because it probably isn't well tested).
>
> Similarly with btrfs scrub.  The operations are logically different
> enough that they shouldn't really interfere with each other logically,
> but they're both hardware intensive operations that will put unnecessary
> stress on the system if you're doing more than one at a time, and will
> result in both going slower than they normally would.
Actually, depending on a number of factors, scrubbing while balancing 
can actually finish faster than running one then the other in sequence. 
  It's really dependent on how both decide to pick chunks, and how your 
underlying devices handle read and write caching, but it can happen. 
Most of the time though, it should take around the same amount of time 
as running one then the other, or a little bit longer if you're on 
traditional disks.
>
> And again with snapshotting operations.  Making a snapshot is normally
> nearly instantaneous, but there's a scaling issue if you have too many
> per filesystem (try to keep it under 2000 snapshots per filesystem total,
> if possible, and definitely keep it under 10K or some operations will
> slow down substantially), and deleting snapshots is more work, so while
> you should ordinarily automatically thin down snapshots if you're
> automatically making them quite frequently (say daily or more
> frequently), you may want to put the snapshot deletion, at least, on hold
> while you scrub or balance or device delete or replace.
I would actually recommend putting all snapshot operations on hold, as 
well as most writes to the filesystem, while doing a balance or device 
deletion.  The more writes you have while doing those, the longer they 
take, and the less likely that you end up with a good on-disk layout of 
the data.

