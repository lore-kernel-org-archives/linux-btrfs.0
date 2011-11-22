From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs-delalloc - threaded?
Date: Tue, 22 Nov 2011 17:01:33 +0000 (UTC)
Message-ID: <slrnjcnlbd.cqt.stephane.chazelas@spam.is.invalid>
References: <CALjZLS5iA1TVJCVWSpE+Xg5hG_E1c+LVrFz2EJK2b=Xc7MQw_Q@mail.gmail.com>
 <slrnjcncff.cqt.stephane.chazelas@spam.is.invalid>
 <20111122144744.GI28259@shiny>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-11-22, 09:47(-05), Chris Mason:
> On Tue, Nov 22, 2011 at 02:30:07PM +0000, Stephane CHAZELAS wrote:
>> 2011-09-6, 11:21(-05), Andrew Carlson:
>> > I was doing some testing with writing out data to a BTFS filesystem
>> > with the compress-force option.  With 1 program running, I saw
>> > btfs-delalloc taking about 1 CPU worth of time, much as could be
>> > expected.  I then started up 2 programs at the same time, writing data
>> > to the BTRFS volume.  btrfs-delalloc still only used 1 CPU worth of
>> > time.  Is btrfs-delalloc threaded, to where it can use more than 1 CPU
>> > worth of time?  Is there a threshold where it would start using more
>> > CPU?
>> [...]
>> 
>> Hiya,
>> 
>> I observe the same here. The bottleneck when writing data
>> sequencially seems to be that btrfs-delalloc using 100% of the
>> time of one CPU.
>
> The compression is spread out to multiple CPUs.  Using zlib on my 4 cpu
> box, I get 4 delalloc threads working on two concurrent dds.
>
> The thread hand off is based on the amount of work queued up to each
> thread, and you're probably just below the threshold where it kicks off
> another one.  Are you using lzo or zlib? 

mounted with -o compress-force, so getting whatever the default
compression algorithm is.

> What is the workload you're using?  We can make the compression code
> more aggressive at fanning out.
[...]

That was a basic test of:

head -c 40M /dev/urandom > a
(while :; do cat a; done) | pv -rab > b

(I expect the content of "a" to be cached in memory).

Running "dstat -df" and top in parallel.

Nothing else reading or writing to that FS.

btrfs maxes out at about 150MB/s, and zfs at about 400MB/s.

For the concurrent writing, replace

pv  with pv | tee b c d e > f

(I suppose there's a fair chance of this incurring disk seeking,
so reduced throughput is probably to be expected. I get the same
kind of throughput (mayby 15% more) with zfs raid5 in that case).

-- 
Stephane

