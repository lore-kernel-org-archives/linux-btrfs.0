Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42996 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbbBSSQc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 13:16:32 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150216220234.GK12722@dastard>
References: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
	<20150216003337.GG12722@dastard>
	<CAL3q7H5utEhz7r8ZeWq00_tuLY_NS34XR6PMXsAE-TG0UGUM7A@mail.gmail.com>
	<20150216220234.GK12722@dastard>
Date: Thu, 19 Feb 2015 18:16:29 +0000
Message-ID: <CAL3q7H40rr2D9iSowsVBRBiPCp-UsV+56o4zPo89mDg1-=SMtQ@mail.gmail.com>
Subject: Re: [PATCH] fstests: generic test for fsync followed by truncate and link
From: Filipe David Manana <fdmanana@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 10:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Feb 16, 2015 at 09:45:22AM +0000, Filipe David Manana wrote:
>> On Mon, Feb 16, 2015 at 12:33 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Fri, Feb 13, 2015 at 12:47:54PM +0000, Filipe Manana wrote:
>> >> This test is motivated by an fsync issue discovered in btrfs.
>> >> The issue was that we could lose file data, that was previously fsync'ed
>> >> successfully, if we end up shrinking (via truncate) the file, add a hard
>> >> link to our file and then persist the fsync log later via an fsync of
>> >> other inode for example. After a power loss our file content wouldn't
>> >> match what it had when we last fsync'ed, but instead it had the data
>> >> prior to that fsync.
>> >
>> > Prior to which fsync?
>>
>> The fsync of file "foo" - this is the file we're testing for
>> correctness and we only fsync it once.
>
> Ok. But there's also an implied fsync because btrfs is supposed to
> have an ordered metadata transaction subsystem.
>
>> > XFS has strictly ordered metadata journalling, which means
>> > transactions committed prior to *any* fsync will be present on disk
>> > after the fsync. ext4 is not quite so strict, but has essentially
>> > the same behaviour. ext3 in ordered mode behaves like XFS.
>> >
>> > As such, ext3, ext4 and XFS return the state of the file as "0xaa for
>> > 0 to 5k, 0x00 out to 32k" and the hardlink foo_link is present after
>> > the filesystem is remounted and the log replayed.
>>
>> Well, that's not I get with XFS, at least on a 3.19 kernel.
>> After log replay, I get a file with a size of 32Kb, the first 8192
>> bytes have the value 0xaa and the remaining 24Kb have value 0x00 -
>> this doesn't match the file content after any operation.
>
> See my previous reply in the thread. In memory behaviour appears
> correct, which means fsx will pass but we won't have picked up a
> regression in power failure behaviour.
>
>> I'm ok with changing the test to consider valid any of those 3 cases.
>>
>> >
>> > So, as this test is written, it does not encapsulate the
>> > longstanding, expected behaviour of existing filesystems. btrfs
>> > should behave like XFS, ext3 and ext4 if possible - being different
>> > is only going to cause confusion and pain for application
>> > developers.
>> >
>> >> The btrfs issue was fixed by the following linux kernel patch:
>> >>
>> >>   Btrfs: don't remove extents and xattrs when logging new names
>> >
>> > Sounds like you've just introduced an ordered mode behavioural
>> > journalling regression into btrfs...
>>
>> How can it be a regression?
>
> Maybe it's not a regression - I don't know what the old behaviour
> was - but it certainly seems like a bug to me.  Btrfs is supposed to
> have a strongly ordered transaction model, similar to XFS and ext4
> and the test as you've written it implies transactional change
> ordering is not preserved in btrfs (ouch!).
>
> Ordered mode on this test is tricky because you are running fsync on
> a newly created file. That implies fsync on the parent directory,
> because fsync means you are stabilising all the *transactions* that
> changed metadata on the new file. That means the dirent created to
> point to the new file should be fsync()d, too.
>
> So, order of modifications:
>
> file foo data written and synced
> file foo truncate/extent
> hard link foo_link to foo created
> new file bar created
> new file bar fsync
>
> In this case, it's the hard link of foo to foo_link that creates the
> ordered dependency between foo, the parent directory and bar. The
> directory is then modified in a future transaction by creating bar,
> and the fsync on bar stabilises the parent directory as
> transactional atomicity requires all objects in a transaction to be
> stabilised when one object is asked to be stabilised. And for the
> latest modification to an object to be stabilised, ordered metadata
> requires all previous modifications to that object also need to be
> stabilised at the same time.
>
> IOWs, the fsync on bar has this ordered change dependency
> resolution:
>
> fsync(bar)
>   - implied parent directory fsync for dirent pointing to bar
>     - stabilises parent directory, which
>       - also stabilises new hard link dirent to foo_link, which
>         - stabilises new link count in foo, which
>           - stabilises inode core of foo, which
>             - stabilises changed inode size from truncate/extent
>             - stabilises extent list changes from truncate/extent
>
> IOWs, ordered metadata transactions mean the second fsync, through
> the chain of dependent modifications previously made, should also
> stabilise all the metadata changes made on foo since the fsync was
> called on it.
>
>> Before this change, after the fsync log replay, the file content
>> matched what it had when "sync" was called - i.e. doesn't match the
>> content when the fsync (on "foo") was performed nor the content after
>> any of the subsequent truncate operations.
>
> IOWs, btrfs did not follow ordered metadata behavioural rules before
> the change, nor does it follow them after the change, but it's
> now broken in a different, more subtle and surprising way.

Dave, thanks for the detailed explanation.
I'll update the test once I get btrfs to have the same behaviour as
xfs and ext3/4.



>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
