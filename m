From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC PATCH 4/4] btrfs: Moved repair code from inode.c to extent_io.c
Date: Sun, 24 Jul 2011 19:28:08 +0200
Message-ID: <4E2C5628.1020406@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>	<31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net> <m21uxftzo7.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m21uxftzo7.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.07.2011 18:24, Andi Kleen wrote:
> Jan Schmidt <list.btrfs@jan-o-sch.net> writes:
>>
>> Repair works that way: Whenever a read error occurs and we have more
>> mirrors to try, note the failed mirror, and retry another. If we find a
>> good one, check if we did note a failure earlier and if so, do not allow
>> the read to complete until after the bad sector was written with the good
>> data we just fetched. As we have the extent locked while reading, no one
>> can change the data in between.
> 
> This has the potential for error loops: when the write fails too
> you get another error in the log and can flood the log etc. 
> I assume this could get really noisy if that disk completely
> went away.

I wasn't clear enough on that: We only track read errors, here. Ans
error correction can only happen on the read path. So if the write
attempt fails, we can't go into a loop.

> Perhaps it needs a threshold to see if there aren't too many errors
> on the mirror and then stop retrying at some point.

This might make sense for completely broken disks that did not went
away, yet. However, for the future I'd like to see some intelligence in
btrfs monitoring disk errors and automatically replacing a disk after a
certain (maybe configurable) number of errors. For the mean time, I'd
accept a completely broken disk to flush the log.

Anyway, I've got some sata error injectors and will test my patches with
those in the following days. Maybe some obvious point turns up where we
could throttle things.

-Jan
