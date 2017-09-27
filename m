Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:48327 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdI0MIb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 08:08:31 -0400
Received: by mail-io0-f182.google.com with SMTP id n69so15443368ioi.5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 05:08:31 -0700 (PDT)
Subject: Re: Give up on bcache?
To: Ferry Toth <ftoth@telfort.nl>, linux-btrfs@vger.kernel.org
References: <oqe0fo$keo$1@blaine.gmane.org>
 <b545953d-7fbe-c451-0213-9c1fbec72a3b@gmail.com>
 <oqelb8$2e0$1@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <282ff5d5-ce3e-ab2d-a1ea-07e41a821615@gmail.com>
Date: Wed, 27 Sep 2017 08:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <oqelb8$2e0$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-26 18:46, Ferry Toth wrote:
> Op Tue, 26 Sep 2017 15:52:44 -0400, schreef Austin S. Hemmelgarn:
> 
>> On 2017-09-26 12:50, Ferry Toth wrote:
>>> Looking at the Phoronix benchmark here:
>>>
>>> https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
>>> raid&num=2
>>>
>>> I think it might be idle hopes to think bcache can be used as a ssd
>>> cache for btrfs to significantly improve performance.. True, the
>>> benchmark is using ext.
>> It's a benchmark.  They're inherently synthetic and workload specific,
>> and therefore should not be trusted to represent things accurately for
>> arbitrary use cases.
> 
> So what. A decent benchmark tries to measure a specific aspect of the fs.
Yes, and it usually measures it using a ridiculously unrealistic 
workload.  Some of the benchmarks in iozone are a good example of this, 
like the backwards read one (there is nearly nothing that it provides 
any useful data for).  For a benchmark to be meaningful, you have to 
test what you actually intend to use, and from a practical perspective, 
that article is primarily testing throughput, which is not something you 
should be using SSD caching for.
> 
> I think you agree that applications doing lots of fsyncs (databases,
> dpkg) are slow on btrfs especially on hdd's, whatever way you measure
> that (it feels slow, it measures slow, it really is slow).
Yes, but they're also slow on _everything_.  fsync() is slow.  Period. 
It just more of an issue on BTRFS because it's a CoW filesystem _and_ 
it's slower than ext4 even with that CoW layer bypassed.
> 
> On a ssd the problem is less.
And most of that is a result of the significantly higher bulk throughput 
on the SSD, which is not something that SSD caching replicates.
> 
> So if you can fix that by using a ssd cache or a hybrid solution, how
> would you like to compare that? It _feels_ faster?
That depends.  If it's on a desktop, then that actually is one of the 
best ways to test it, since user perception is your primary quality 
metric (you can make the fastest system in the world, but if the user 
can't tell, you've gained nothing).  If you're on anything else, you 
test the actual workload if possible, and a benchmark that tries to 
replicate the workload if not.  Put another way, if you're building a 
PGSQL server, you should be bench-marking things with a PGSQL 
bench-marking tool, not some arbitrary that likely won't replicate a 
PGSQL workload.
> 
>>> But the most important one (where btrfs always shows to be a little
>>> slow)
>>> would be the SQLLite test. And with ext at least performance _degrades_
>>> except for the Writeback mode, and even there is nowhere near what the
>>> SSD is capable of.
>> And what makes you think it will be?  You're using it as a hot-data
>> cache, not a dedicated write-back cache, and you have the overhead from
>> bcache itself too.  Just some simple math based on examining the bcache
>> code suggests you can't get better than about 98% of the SSD's
>> performance if you're lucky, and I'd guess it's more like 80% most of
>> the time.
>>>
>>> I think with btrfs it will be even worse and that it is a fundamental
>>> problem: caching is complex and the cache can not how how the data on
>>> the fs is used.
>> Actually, the improvement from using bcache with BTRFS is higher
>> proportionate to the baseline of not using it by a small margin than it
>> is when used with ext4.  BTRFS does a lot more with the disk, so you
>> have a lot more time spent accessing the disk, and thus more time that
>> can be reduced by improving disk performance.  While the CoW nature of
>> BTRFS does somewhat mitigate the performance improvement from using
>> bcache, it does not completely negate it.
> 
> I would like to reverse this, how much degradation do you suffer from
> btrfs on a ssd as baseline compared to btrfs on a mixed ssd/hdd system.
Performance-wise?  It's workload dependent, but in most case it's a hit 
regardless of if you're using BTRFS or some other filesystem.

If instead you're asking what the difference in device longevity, you 
can probably expect the SSD to wear out faster in the second case. 
Unless you have a reasonably big SSD and are using write-around caching, 
every write will hit the SSD too, and you'll end up with lots of 
rewrites on the SSD.
> 
> IMHO you are hoping to get ssd performance at hdd cost.
Then you're looking at the wrong tool.  The primary use cases for SSD 
caching are smoothing latency and improving interactivity by reducing 
head movement.  Any other measure of performance is pretty much 
guaranteed to be worse with SSD caching than just using an SSD, and bulk 
throughput is often just as bad as, if not worse than, using a regular 
HDD by itself.

If you are that desperate for performance like an SSD, quit whining 
about cost and just buy an SSD.  Decent ones are down to less than 0.40 
USD per GB depending on the brand (search 'Crucial MX300' on Amazon if 
you want an example), so the cost isn't nearly as bad as people make it 
out to be, especially considering that most the time a normal person who 
isn't doing multimedia work or heavy gaming doesn't use more than about 
200GB of the 1TB HDD that comes standard in most OEM systems these days.
> 
>>> I think the original idea of hot data tracking has a much better chance
>>> to significantly improve performance. This of course as the SSD's and
>>> HDD's then will be equal citizens and btrfs itself gets to decide on
>>> which drive the data is best stored.
>> First, the user needs to decide, not BTRFS (at least, by default, BTRFS
>> should not be involved in the decision).  Second, tiered storage (that's
>> what that's properly called) is mostly orthogonal to caching (though
>> bcache and dm-cache behave like tiered storage once the cache is
>> warmed).
> 
> So, on your desktop you really are going to seach for all sqllite, mysql
> and psql files, dpkg files etc. and move them to the ssd? You can already
> do that. Go ahead!
First off, finding all that data is trivial, so it's not like automatic 
placement is absolutely necessary for this to work as a basic feature. 
The shell fragment following will find all SQLite databases on a filesystem:

	for item in `find / -xdev -type f` ; do
		if ( file ${item} | grep -q SQLite ) ; then
			# Do something with the SQLite databases
		fi
	done

Secondly, it is non-trivial to configure a system like this.  It 
requires a lot of effort to make sure all the symlinks that are needed 
are arranged properly and won't be modified by the applications.  Having 
the ability to mark files in the filesystem itself and get them put on a 
particular device would significantly improve the user experience here 
with a lot less work required than automatic placement.
> 
> The big win would be if the file system does that automatically for you.
Except that:
1. We can't check file format in the filesystem itself, because handling 
different file formats differently in the file system based on the 
format breaks user expectations.
2. Heuristic behavior won't be accurate at least half the time.  Just 
because something is an SQLite database doesn't mean it will behave in a 
way that will get it detected for placement on an SSD.
3. Most of the logic that would be implemented (how often is the file 
accessed, and is it random access or sequential) is already implemented 
in bcache, so the standard heuristics won't help any more here.
4. Automatic placement is not needed to have tiering, and is 
significantly more complex than just the basic tiering, which means from 
a development perspective that it should be handled separately.
> 
>>> With this implemented right, it would also finally silence the never
>>> ending discussion why not btrfs and why zfs, ext, xfs etc. Which would
>>> be a plus by its own right.
>> Even with this, there would still be plenty of reasons to pick one of
>> those filesystems over BTRFS.  There would however be one more reason to
>> pick BTRFS over ext or XFS (but necessarily not ZFS, it already has
>> caching built in).
> 
> Exactly, one more advantage of btrfs and one less of zfs.
Again, ZFS already does something similar, and they arguably don't 
_need_ tiering because they already do a ridiculously good job at 
caching (and are more efficient in many ways other than that too).  In 
fact, even with this, the primary arguments don't really change:

* Licensing: BTRFS is GPLv2 and in the mainline kernel, ZFS is CDDL and 
third-party.
* API support: BTRFS supports the Linux fallocate syscall completely 
(albeit in ways that are liable to break userspace applications), ZFS 
only supports the POSIX fallocate call, and doesn't implement it to the 
specification.
* Special features: Seed devices on BTRFS and ZVOL's on ZFS are the two 
big ones.
* Performance: ZFS wins here.
* User experience: ZFS also wins here.
* Reliability: Yet again, ZFS wins here.
