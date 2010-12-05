From: Evert Vorster <evorster@gmail.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 06:49:29 -0700
Message-ID: <AANLkTinA81Zb102g4rmzp-+tR3Y_+1hrGh2EXW=xeCn4@mail.gmail.com>
References: <AANLkTimJ3dDdOFiQb8G=rrjCk2h68Y59oWdKEGH-80jN@mail.gmail.com>
	<BbJOCYcD1uB@helmut.hullen.de>
	<AANLkTim9nJrfHeFqLp4d+KYs4jX3hQBV_JTuSBCzFmu3@mail.gmail.com>
	<20101205112208.GD4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Evert Vorster <evorster@gmail.com>,
	Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101205112208.GD4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>> >>> =A0 =A0 =A0 devid =A0 =A02 size 1.35TB used 1.35TB path /dev/sdc=
3
>> >>> =A0 =A0 =A0 devid =A0 =A01 size 1.81TB used 1.35TB path /dev/sdf=
2
>>
>> Here devid 2 is at 100%, and hence you are getting the no more space
>> left errors. So, the 300 TB is on the bigger disk, and not usable fo=
r
>> you right now.
>
> =A0 I _think_ that a balance is all that's needed at this point. It
> can't hurt, anyway (other than taking quite a long time).
I am under the impression that as soon as one of the devices in a
btrfs is out of space, and write to that file system returns ENOSPACE
This certainly does look like it from this example, and from what I
have read elsewhere. Also, I believe that the balance operation tries
to equalize the amount of bytes used on each underlying device, rather
than try to equalize the percentage of underlying devices filled. With
exactly the same amount used on both disks, I doubt that there would
be any advantage to a balance operation.

>> I know of the disk mode you speak.. an old raid card of mine called =
it
>> "Just a bunch of disks" and it literally filled up the first disk
>> before carrying on to the second one until that was full under
>> windows... under UNIX it had the effect of just adding all the secto=
rs
>> to each other, and stretching the file system over the disks in a
>> linear fashion. Most UNIX file systems writes files in the middle of
>> the largest contiguous free space, which meant that some files got
>> written on the first disk, and some on the second. As far as I know,
>> btrfs does not support this raid mode.
>
> =A0 It does support it: that's what the "single" RAID profile in
> mkfs.btrfs is. It attempts to use the disk space marginally more
> intelligently than traditional linear mode, though, as it allocates
> block groups (in chunks of about 1G) to each disk in turn. This isn't
> the same as RAID-0, which stripes within block groups with a much
> smaller stripe size.
I stand corrected.
Which brings us to the question... if you don't specify the raid level
when creating the btrfs, what is the default? raid0? single?

>> Another thing to keep in mind is that as far as I know you cannot
>> remove devid 1 from a btrfs volume. This is due to be fixed, but I
>> have no idea on the status of that.
>
> =A0 I've done it (I have a filesystem with IDs 7, 8, 9, 12, 13, 14).
> Looks like that particular problem has been fixed.
Good to know. I'm outgrowing one of my filesystems as well... and
would like to be able to migrate to bigger disks without rebuilding
the btrfs from scratch.

>> You could, if you really wanted to use all of two differently sized
>> disks in a btrfs, subdivide the disks in equal sized partitions, and
>> just put all of those partitions in a btrfs raid0...
> [...]
>
> =A0 That would be a really bad idea, as your disks would thrash
> horribly, reading stripes from different locations on the disk.
True, it would be slower than a normal raid0... in "single" mode there
should be almost no thrashing, though.

This does warrant some testing, though. I'll see what I can do testing
wise. Unfortunately, I'm no good at coding so the best I can do is
test and report results...

:(

-Evert Vorster-
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
