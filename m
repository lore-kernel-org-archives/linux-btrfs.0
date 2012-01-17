From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: NULL Pointer Dereference While Scrubbing
Date: Tue, 17 Jan 2012 18:08:01 +0100
Message-ID: <4F15AAF1.6090306@jan-o-sch.net>
References: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>	<CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com>	<CAKcLGm-WbMm+RLu9DY1ggriCAWMM0mKNH650WdwfVEjb_cJYsg@mail.gmail.com>	<4F15A4A5.8040501@jan-o-sch.net> <CAKcLGm9+TPwngXj0NE0UShreUd=OzUK2_FuXbJTCRA7rzoUOmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm9+TPwngXj0NE0UShreUd=OzUK2_FuXbJTCRA7rzoUOmg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.01.2012 18:03, Mitch Harder wrote:
> You're correct about my original problem being with scrub.  I had lost
> track of the multiple ways to make the partition BUG.
> 
> I've re-run scrub, and scrub now proceeds without error also, but it
> still leaves the inode 400 error from btrfsck.
> 
> I am beginning to suspect that the partition had another inconsistency
> that didn't have anything to do the the btrfsck reported error, but
> was causing btrfs to run into a BUG when running various operations on
> the disk.

Sounds plausible.

> The current Scrub results are:
> 
> # btrfs scrub start -B /mnt/gentoo/
> scrub done for 75b9f12c-7f3a-4bb2-abe4-dc3da29558ed
> 	scrub started at Tue Jan 17 10:52:26 2012 and finished after 57 seconds
> 	total bytes scrubbed: 2.91GB with 0 errors
> 
> Which still leaves the following btrfsck result:
> 
> # btrfsck /dev/sdb5
> root 5 inode 19772 errors 400
> found 3125092352 bytes used err is 1
> total csum bytes: 2476744
> total tree bytes: 588513280
> total fs tree bytes: 554622976
> btree space waste bytes: 146782986
> file data blocks allocated: 2536579072
>  referenced 5144166400
> Btrfs Btrfs v0.19-dirty

Alright, that's fine. Scrub isn't expected to find those.
(I_ERR_FILE_NBYTES_WRONG)

-Jan
