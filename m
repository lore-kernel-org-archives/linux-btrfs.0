Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40865 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbBPJpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 04:45:23 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150216003337.GG12722@dastard>
References: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
	<20150216003337.GG12722@dastard>
Date: Mon, 16 Feb 2015 09:45:22 +0000
Message-ID: <CAL3q7H5utEhz7r8ZeWq00_tuLY_NS34XR6PMXsAE-TG0UGUM7A@mail.gmail.com>
Subject: Re: [PATCH] fstests: generic test for fsync followed by truncate and link
From: Filipe David Manana <fdmanana@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 12:33 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Feb 13, 2015 at 12:47:54PM +0000, Filipe Manana wrote:
>> This test is motivated by an fsync issue discovered in btrfs.
>> The issue was that we could lose file data, that was previously fsync'ed
>> successfully, if we end up shrinking (via truncate) the file, add a hard
>> link to our file and then persist the fsync log later via an fsync of
>> other inode for example. After a power loss our file content wouldn't
>> match what it had when we last fsync'ed, but instead it had the data
>> prior to that fsync.
>
> Prior to which fsync?

The fsync of file "foo" - this is the file we're testing for
correctness and we only fsync it once.

>
> XFS has strictly ordered metadata journalling, which means
> transactions committed prior to *any* fsync will be present on disk
> after the fsync. ext4 is not quite so strict, but has essentially
> the same behaviour. ext3 in ordered mode behaves like XFS.
>
> As such, ext3, ext4 and XFS return the state of the file as "0xaa for
> 0 to 5k, 0x00 out to 32k" and the hardlink foo_link is present after
> the filesystem is remounted and the log replayed.

Well, that's not I get with XFS, at least on a 3.19 kernel.
After log replay, I get a file with a size of 32Kb, the first 8192
bytes have the value 0xaa and the remaining 24Kb have value 0x00 -
this doesn't match the file content after any operation.

That seems unexpected to me.
I think only 3 results are acceptable after the log replay:

1) A file with a size of 12Kb, first 8Kb of data with value 0xaa, and
the last 4Kb of data with the value 0xcc. This is the file content
after it was explicitly fsync'ed;

2) A file with a size of 5000 bytes, all bytes having the value 0xaa.
This is the result after the shrinking truncate;

3) A file with a size of 32Kb, where the first 5000 bytes all have the
value 0xaa and the remaining bytes with value 0xaa. This is the result
of the expanding truncate.

Result 1) is the one I most expected. Results 2) and 3) are possible -
the fs might decide to commit the current transaction after any of the
truncate operations - it's still correct behaviour.
Also, after adding the hard link to foo, it might decide update the
fsync log, in this case we should get to 3).

I'm ok with changing the test to consider valid any of those 3 cases.

>
> So, as this test is written, it does not encapsulate the
> longstanding, expected behaviour of existing filesystems. btrfs
> should behave like XFS, ext3 and ext4 if possible - being different
> is only going to cause confusion and pain for application
> developers.
>
>> The btrfs issue was fixed by the following linux kernel patch:
>>
>>   Btrfs: don't remove extents and xattrs when logging new names
>
> Sounds like you've just introduced an ordered mode behavioural
> journalling regression into btrfs...

How can it be a regression?
Before this change, after the fsync log replay, the file content
matched what it had when "sync" was called - i.e. doesn't match the
content when the fsync (on "foo") was performed nor the content after
any of the subsequent truncate operations.

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
