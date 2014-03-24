Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaCXUwO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 16:52:14 -0400
Message-ID: <53309AF9.8090203@friedels.name>
Date: Mon, 24 Mar 2014 21:52:09 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: free space inode generation (0) did not match free space cache
 generation
References: <532DF38B.40409@friedels.name> <532DFDAB.7000600@friedels.name> <pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>
In-Reply-To: <pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>> I read through the FAQ you mentioned, but I must admit, that I do not
>> fully understand.
>
> My experience is that it takes a bit of time to soak in.  Between time,
> previous Linux experience, and reading this list for awhile, things do
> make more sense now, but my understanding has definitely changed and
> deepened over time.

Yes, I'm progressing. But I am a bit behind you :-)

>> What I am wondering about is, what caused this problem to arise. The
>> filesystem was hardly a week old, never mistreated (powered down without
>> unmounting or so) and not even half full. So what caused the data chunks
>> all being allocated?
>
> I can't really say, but it's worth noting that btrfs can normally
> allocate chunks, but doesn't (yet?) automatically deallocate them.  To
> deallocate, you balance.  Btrfs can reuse areas that have been deleted as
> the same thing, data or metadata, but it can't switch between them
> without a balance.

Ok, I do understand that. I don't know why it could not automatically 
deallocate them.. But then at least I'd expect it to automatically 
detect this problem and do a balance, when needed.
Note, that this Problem caused my System to become unavailable and it 
took days to find how to fix it (even if the fix was then very quick, 
thanks to your help).

> So the most obvious thing is that if you copy a bunch of stuff around so
> the filesystem is nearing full, then delete a bunch of it, consider
> checking your btrfs filesystem df/show stats and see whether you need a
> balance.  But like I said, that's obvious.

Yes. I did not really do much with the system. I copied everything onto 
the filesystem, rebooted and let it run for a week.

>> The only thing that I could think of is that I created hourly snapshots
>> with snapper.
>> In fact in order to be able to do the balance, I had to delete something
>> -so I deleted the snapshots.
>
> One possibility off the top of my head:  Do you have noatime set in your
> mount options?  That's definitely recommended with snapshotting, since
> otherwise, atime updates will be changes to the filesystem metadata since
> the last snapshot, and thus will add to the difference between snapshots
> that must be stored.  If you're doing hourly snapshots and are accessing
> much of the filesystem each hour, that'll add up!

Really? I do have noatime set, but I would expect the accesstime be 
stored in the metadata. So when snapshotting, only the changed metadata 
would have to be stored for the files that have been accesed between the 
two snapshots. That should not be a problem, is it?

> Additionally, I recommend snapshot thinning.  Hourly snapshots are nice
> but after some time, they just become noise.  Will you really know or
> care which specific hour it was if you're having to retrieve a snapshot
> from a month ago?

In fact, snapper does that for me.

> Also, it may or may not apply to you, but internal-rewrite (as opposed to
> simply appended) files are bad news for COW-based filesystems such as
> btrfs.

I don't see any applications that do internal re-writes on my system. 
Interesting nevertheless, esp. wrt. the posible solution. Thaks.

>> Besides this:
>> You recommend monitoring the output of btrfs fi show and to do a
>> balance, whenever unallocated space drops too low. I can monitor this
>> and let monit send me a message once that happens. Still, I'd like to
>> know how to make this less likely.
>
> I haven't had a problem with it here, but then I haven't been doing much
> snapshotting (and always manual when I do it), I don't run any VMs or
> large databases, I mounted with the autodefrag option from the beginning,
> and I've used noatime for nearing a decade now as it was also recommended
> for my previous filesystem, reiserfs.

The only differences are that my snapshotting is automated and the 
autodefrag is not set. No databases, no VMs, noatime set. It's a simple 
install of Ubuntu.

> But regardless of my experience with my own usage pattern, I suspect that
> with reasonable monitoring, you'll eventually become familiar with how
> fast the chunks are allocated and possibly with what sort of actions
> beyond the obvious active moving stuff around on the filesystem triggers
> those allocations, for your specific usage pattern, and can then adapt as
> necessary.

Yes, that's a workaround. But really, that makes one the slave to your 
filesystem. That's not really acceptable, is it?

Regards,
Hendrik


