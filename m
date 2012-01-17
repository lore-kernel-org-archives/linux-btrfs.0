From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: NULL Pointer Dereference While Scrubbing
Date: Tue, 17 Jan 2012 11:03:41 -0600
Message-ID: <CAKcLGm9+TPwngXj0NE0UShreUd=OzUK2_FuXbJTCRA7rzoUOmg@mail.gmail.com>
References: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>
	<CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com>
	<CAKcLGm-WbMm+RLu9DY1ggriCAWMM0mKNH650WdwfVEjb_cJYsg@mail.gmail.com>
	<4F15A4A5.8040501@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F15A4A5.8040501@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 10:41 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> On 17.01.2012 17:35, Mitch Harder wrote:
>> I've been able to clear this BUG_ON() after applying Miao Xie's
>> "[PATCH] Btrfs: fix enospc error caused by wrong checks of the chunk"
>> on top of the rebased integration branch with a 3.2.1 kernel.
>>
>> Btrfsck still shows the same inode errors 400 message, but I can
>> complete a balance of the filesystem without encountering a BUG_ON().
>
> Did you also try to scrub the device again (which I thought that's was
> this thread is all about)?
>
> However, I'm not sure whether it's worth investigating any further, as
> the bug seems to be readahead-related which is presumably being replaced
> soon.
>
> -Jan

You're correct about my original problem being with scrub.  I had lost
track of the multiple ways to make the partition BUG.

I've re-run scrub, and scrub now proceeds without error also, but it
still leaves the inode 400 error from btrfsck.

I am beginning to suspect that the partition had another inconsistency
that didn't have anything to do the the btrfsck reported error, but
was causing btrfs to run into a BUG when running various operations on
the disk.

The current Scrub results are:

# btrfs scrub start -B /mnt/gentoo/
scrub done for 75b9f12c-7f3a-4bb2-abe4-dc3da29558ed
	scrub started at Tue Jan 17 10:52:26 2012 and finished after 57 seconds
	total bytes scrubbed: 2.91GB with 0 errors

Which still leaves the following btrfsck result:

# btrfsck /dev/sdb5
root 5 inode 19772 errors 400
found 3125092352 bytes used err is 1
total csum bytes: 2476744
total tree bytes: 588513280
total fs tree bytes: 554622976
btree space waste bytes: 146782986
file data blocks allocated: 2536579072
 referenced 5144166400
Btrfs Btrfs v0.19-dirty
