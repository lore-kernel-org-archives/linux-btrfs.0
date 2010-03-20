From: Boyd Waters <waters.boyd@gmail.com>
Subject: Re: Content based storage
Date: Fri, 19 Mar 2010 22:46:27 -0400
Message-ID: <2b0225fb1003191946k1cf92c63q18e40d41274ce3e8@mail.gmail.com>
References: <hnnijd$jol$1@dough.gmane.org> <201003171625.50257.hka@qbs.com.pl>
	 <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>
	 <201003172043.17314.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003172043.17314.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

2010/3/17 Hubert Kario <hka@qbs.com.pl>:
>
> Read further, Sun did provide a way to enable the compare step by using
> "verify" instead of "on":
> zfs set dedup=verify <pool>

I have tested ZFS deduplication on the same data set that I'm using to
test btrfs. I used a 5-element radiz, dedup=on, which uses SHA256 for
ZFS checksumming and duplication detection on Build 133 of OpenSolaris
for x86_64.

Subjectively, I felt that the array writes were slower than without
dedup. For a while, the option for "dedup=fletcher4,verify" was in the
system, which permitted the (faster, more prone to collisions)
fletcher4 hash for ZFS checksum, and full comparison in the
(relatively rare) case of collision. Darren Moffat worked to unify the
ZFS SHA256 code with the OpenSolaris crypo-api implementation, which
improved performance [1]. But I was not able to test that
implementation.

My dataset reported a dedup factor of 1.28 for about 4TB, meaning that
almost a third of the dataset was duplicated. This seemed plausible,
as the dataset includes multiple backups of a 400GB data set, as well
as numerous VMWare virtual machines.

Despite the performance hit, I'd be pleased to see work on this
continue. Darren Moffat's performance improvements were encouraging,
and the data set integrity was rock-solid. I had a disk failure during
this test, which almost certainly had far more impact on performance
than the deduplication: failed writes to the disk were blocking I/O,
and it got pretty bad before I was able to replace the disk. I never
lost any data, and array management was dead simple.

So anyway FWIW the ZFS dedup implementation is a good one, and had
headroom for improvement.

Finally, ZFS also lets you set a minimum number of duplicates that you
would like applied to the dataset; it only starts pointing to existing
blocks after the "duplication minimum" is reached. (dedupditto
property) [2]


[1] http://blogs.sun.com/darren/entry/improving_zfs_dedup_performance_via
[2] http://opensolaris.org/jive/thread.jspa?messageID=426661
