From: Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: Confused by performance
Date: Wed, 16 Jun 2010 21:21:34 +0200
Message-ID: <4C19243E.9050507@robertoragusa.it>
References: <4BFAEABD.2070700@noir.com> <4BFF2024.3040509@noir.com> <4C191330.5060905@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "K. Richard Pixley" <rich@noir.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C191330.5060905@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

K. Richard Pixley wrote:
> Once again I'm stumped by some performance numbers and hoping for some
> insight.
> 
> Using an 8-core server, building in parallel, I'm building some code. 
> Using ext2 over a 5-way, (5 disk), lvm partition, I can build that code
> in 35 minutes.  Tests with dd on the raw disk and lvm partitions show me
> that I'm getting near linear improvement from the raw stripe, even with
> dd runs exceeding 10G, so I think that convinces me that my disks and
> controller subsystem are capable of operating in parallel and in
> concert.  hdparm -t numbers seem to support what I'm seeing from dd.
> 
> Running the same build, same parallelism, over a btrfs (defaults)
> partition on a single drive, I'm seeing very consistent build times
> around an hour, which is reasonable.  I get a little under an hour on
> ext4 single disk, again, very consistently.
> 
> However, if I build a btrfs file system across the 5 disks, my build
> times decline to around 1.5 - 2hrs, although there's about a 30min
> variation between different runs.
> 
> If I build a btrfs file system across the 5-way lvm stripe, I get even
> worse performance at around 2.5hrs per build, with about a 45min
> variation between runs.
> 
> I can't explain these last two results.  Any theories?

If you just want theory, I can try. :-)

Theory of striping follows (numbers invented).
If you have a stripe size of 8 sectors, 40 successive sectors are
divided in 5 groups of 8 sectors, with each group on a different disk.
Suppose you want to read 40 sectors; with one disk and no striping
you need:
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 40 sectors (around 0ms)
Suppose you want to read 40 sectors with your 5disk striped volume,
you need
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 8 sectors (around 0ms)
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 8 sectors (around 0ms)
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 8 sectors (around 0ms)
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 8 sectors (around 0ms)
    time_to_place_disk_head_and_rotational_latency (10ms)
  + time to read 8 sectors (around 0ms)
so you are 5 times slower. Now, it could be that you submit the
5 requests together; in that case you do not pay a 5 times penalty,
but a 2 times penalty. Why? Because, if you think about rotational
latency, if a disk takes 10ms to do one rotation, you will have
your data ready in a random time equally distributed between
0 and 10 ms (average 5ms). If you submit 5 command to 5 disks
each of one will have a (independent!) flat distribution between
0 and 10ms; as you need all 5 pieces you have to wait the
unluckier of the disks, so your average will be near 10ms.
So in general striping costs you a 2 to 5 speed penalty.

If your build if really parallel, when one process is waiting
data, another one will make requests. But remember that all the disks
are busy because of the first process, so it is not unreasonable
to have that multiple processes do not gain any speed.
In reality, the first 5 requests and the second 5 could be evaluated
at the same time to give precedence to the one of the two more
easy for the drive (maybe the second one is lucky from a rotational point
of view, so it is better to do that before the first). In this case the
disks are better utilized, but the net effect on the overall build
is not so easy to establish, because, when you give precedence
to the second request, you are delaying the first, so the entire
first 40-sectors read could have worse timing than 0-10ms_almost_surely_10,
and can get a 0-20ms_maybe_15.

There is a lot of maths you can study (queue theory and scheduling
algorithms) and a lot of factors can be important (disk queue size,
NCQ, caching) at various levels (O.S., controller, disk).

In my opinion, the basic rule in these cases should be:
  == use a stripe size bigger than the sizes of your random reads ==
In case of seeky load I would personally use a stripe size of 64MiB,
for example. One read should only involve one disk.
Stripe size is often configured with very small values (such as 4KiB),
because it produces very big numbers when you read sequentially
(as you are really using all the disks together).
But latency sucks.

In your case, the build is probably very seeky, and the "seekiness"
could be exacerbated by having many writes (and things become even worse
when the filesystems involve a journal...).

(sorry for the long mail. you asked for a theory :-) )
-- 
   Roberto Ragusa    mail at robertoragusa.it
