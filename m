From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and backups
Date: Mon, 26 Mar 2012 14:26:12 +0000 (UTC)
Message-ID: <pan.2012.03.26.14.26.12@cox.net>
References: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
	<4F702F54.90300@gmail.com>
	<CAG1y0scd6L75=m=en1+52gATpYKvvzo55E5PvxNcbqfuy7uCDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Mon, 26 Mar 2012 16:01:54 +0700 as excerpted:

> On Mon, Mar 26, 2012 at 3:56 PM, Felix Blanke <felixblanke@gmail.com>
> wrote:
>> On 3/26/12 10:30 AM, James Courtier-Dutton wrote:
>>> Is there some tool like rsync that I could copy all the data and
>>> snapshots to a backup system, but still only use the same amount of
>>> space as the source filesystem.
> 
> 
>> I'm not sure if I understand your problem right, but I would suggest:
>>
>> 1) Snapshot the subvolume on the source 2) rsync the snapshot to the
>> destination 3) Snapshot the destination
> 
> James did say "only use the same amount of space as the source
> filesystem." Your approach would increase the usage when one or more
> subvolume shares the same space (e.g. when one subvolume starts as
> snapshot).
> 
> AFAIK the (planned) way to do this is using "btrfs send | receive",
> which is not available yet.

What about rsyncing the snapshots, one at a time, snapshotting on the 
destination after each one?  I think that's what Felix' idea was.

On the source filesystem, if each of the snapshots is mounted in turn and 
rsynced across, then rsync should only catch the differences between the 
previous and currently rsyncing snapshots.

On the destination, after the first rsync, a snapshot could be taken and 
mounted, so the second rsync is cumulative.  Then a second snapshot can 
be taken, then it mounted, for the next rsync.  Given COW, I'd think 
that'd work.

That's in contrast to an attempted rsync of the root filesystem, which 
would appear to rsync as if each snapshot was a separate directory tree, 
which would indeed kill the data sharing between them, thus taking up N 
times the space of one snapshot on the destination.

But if each snapshot is mounted in turn on both sides, destination of 
course trailing source by one snapshot, in theory at least, it should 
work, tho it depends on the rsync implementation being COW-friendly and 
I'm not positive it is but expect that it should be.

Here, I'd probably do it manually the first few snapshot generations, 
checking usage on the destination to see that it was working as intended 
as I went and ensuring I had the process down, then script parts of it, 
automating the parts, before ultimately combining the scripts into a full 
automation that, depending on the intent, could ideally be run from a cron 
job or the like.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

