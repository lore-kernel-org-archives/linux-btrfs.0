From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 10:55:21 +0000 (UTC)
Message-ID: <pan.2012.01.28.10.55.21@cox.net>
References: <4F22BCCC.5090800@danisch.de>
	<CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
	<4F234616.6020407@danisch.de> <pan.2012.01.28.03.32.23@cox.net>
	<CAJboL97CGufkN=QEtr=ysU83nrq+UuUoEFuL+wJu85Hx+xBEuA@mail.gmail.com>
	<20120128142344.6f18c989@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sat, 28 Jan 2012 14:23:44 +0600 as excerpted:

> On Sat, 28 Jan 2012 17:05:41 +1100 Ben Klein <shacklein@gmail.com>
> wrote:
> 
>> If the compression routine changes in a later kernel/filesystem
>> revision,
> 
> There are already two different algorithms, zlib and lzo, and a third
> one - snappy - planned for inclusion.
> 
>> then you could end up with some files using one routine and others
>> using another.
> 
> Which is absolutely not a problem even right now.

Reading them isn't a problem, sure, but the thread indicates a desire to 
set the write-compression characteristics.

But that's why I specifically mentioned more than just a compression 
flag.  Presumably it'd be several bits (four bits, 16 values, would leave 
enough room for additional compression types in the future, tho three or 
even two would do it with the current three choices plus uncompressed), 
with one value indicating a no-compression default, and the others 
various choices as the default.  The mount option could then be used to 
override the default, just as it is now, altho the only choice for 
default currently is no compression.

Actually, given that btrfs is in line to be the successor to the ext* 
series, I'd say it should be close to a given that many mount options 
will have settable defaults recorded in the superblocks at mkfs time, and 
updatable using some btrfs parallel to tune2fs (tunebtrfs? tunebfs?).  
However, as I said earlier, committing to specifics with incremental on-
disk including superblock format changes doesn't really cut it.  If a big 
format change is needed due to continuing development, so it can be 
tested and gotchas worked out, yeah, do it now, and hopefully there's 
some space in the superblock(s) reserved for more trivial stuff like 
mount-option defaults already, but especially for mount options since 
they can be tested without committing to the superblock spec changes 
necessary to nail it down there, just testing them using the mount 
options is fine at this point, and the actual recording of the default 
choices can be nailed down all at once in one final change, just before 
the "be prepared for on-disk-format-changes" label comes off.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

