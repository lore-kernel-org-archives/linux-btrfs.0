From: David Nicol <davidnicol@gmail.com>
Subject: Re: the idea for improving the performance of b-tree search
Date: Wed, 13 Oct 2010 15:38:50 -0500
Message-ID: <AANLkTin-2r786B3p2R5Ci8yVgzY24oAv1R7AdSEzE-Az@mail.gmail.com>
References: <4CB57548.7000304@cn.fujitsu.com> <20101013112445.GP22691@think>
 <AANLkTimC=HXPBMxcCL5dx0edN-Z+XzcHpe+G5Bi1hqoX@mail.gmail.com> <20101013154545.GW22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101013154545.GW22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

>> > 3) Do delayed inode deletion. =C2=A0See above, but change the word=
 insert
>> > with delete ;)
>>
>> And the reserved-for-the-future-but-not-used-yet flags field in the
>> ioctl#21 control structure gets a use: bits to indicate for the
>> completion of which of the potential delayed things the caller is
>> waiting.
>
> This is similar to the delayed allocation we already do for file data
> extents. =C2=A0It is supposed to be transparent to userland, and just=
 a way
> to more efficiently poke the on disk structures.
>
> -chris

What I mean is, if we want to give a userland way to see when any
deferred anything is done, using one wait queue that wakes all waiters
on all completion events will be simpler than having a separate wait
queue structure for every class of event, at the cost of unnecessary
tests when a waiter is woken on the wrong event. That is what is
traded off when deciding how many wait queues -- just like locks -- to
have; it's a granularity question.

Now that there is rmdir of empty subvolumes, though, ioctl#21 might be
redundant; I suppose that's your call.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
