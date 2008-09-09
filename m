From: Paul P Komkoff Jr <i@stingr.net>
Subject: Re: parity data
Date: Tue, 9 Sep 2008 18:07:49 +0400
Message-ID: <20080909140749.GA4219@stingr.net>
References: <1220766185.20018.7.camel@telesto> <1220885271.8537.31.camel@think.oraclecorp.com> <1220921206.7953.32.camel@telesto> <1220957012.29741.38.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Eric Anopolsky <erpo41@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220957012.29741.38.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Replying to Chris Mason:

I'd like to step into this thread because it's relevant to my
interests.

> > Let's say I have 4 100GB drives (2 fast ones and 2 slow ones). I've
> > restricted a performance critical directory to the two fastest drives,
> > currently totaling 100GB of performance critical data. The rest of the
> > data on the system is striped.
> > 
> > How much free space do I have on the filesystem? 100GB (the amount of
> > data I can store in the performance critical directory)? 200GB (the
> > amount of data I can store outside the performance critical directory if
> > the striping is guaranteed)? 300GB (the amount of data I can store
> > outside the performance critical directory if the striping is best
> > effort)?
> > 
> 
> People already create these configurations, they just do it with
> multiple filesystems.  And, when they want to resize the performance
> critical section, it is a difficult (and often slow) operation.
> 
> More flexibility in managing storage is the end goal for btrfs, and
> we're just barely getting to the point where we can start addressing
> these difficult issues.

Some time ago I created some list of features of ideal filesystems.
Currently, btrfs (with all proposed but not implemented yet things) is
very close. For example, the ability to freely manage the media pool,
IOW add and remove harddisks of arbitrary size is very important now,
when it's not very uncommon to have a box with 24 hard drives each of
them can fail at any time, and it's economically unfeasible to keep
spare pool of N drives of exactly the same size.
The individual drive size constraint, which is very important in
traditional layered raid-then-lvm-then-fs approach, is not present in
our ideal case, which allows us to manage our storage more
effectively.

Another point is per-object locality/redundancy policy. It's a killer
feature, because, in a traditional world, you'll have to manage
(resize and move) all those partitions around, which is not very
flexible given that you might have 24 drives and then you'll have to
create one raid10, one raid6, and one raid0 on top of them, juggling
the underlying partition sizes, etc, you know.

It is essential to have a filesystem which will do it for you, again,
with more efficiency that you can extract from 30-year-old way of
setting up "block devices".

-- 
Paul P 'Stingray' Komkoff Jr // http://stingr.net/key <- my pgp key
 This message represents the official view of the voices in my head
