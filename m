From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 09:19:28 +0700
Message-ID: <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com>
References: <4EEA4124.20907@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEA4124.20907@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2011 at 1:49 AM, Tobias <tracer@robotech.de> wrote:
> Hi all!
>
> My BTRFS-FS ist getting really slow. Reading is ok, writing is slow and
> deleting is horrible slow.
>
> There are many files and many links on the FS.
>
> # btrfs filesystem df /srv/storage
> Data: total=3.09TB, used=3.07TB

this is ... what, over 99% full?
The slow down is normal, somewhat. Same thing happens on zfs, which
became slower when usage is above 80-90%.

> Maybe it's because there is so much Metadata and it needs so many seeks on
> the discs when deleting?

I doubt it.

> I'd like to delete some of the old Files but its so horrible slow that i
> think its maybe faster to copy all needed Data to a different Disc, killing
> the FS and move the Files back...
>
> The machine is a QuadCore with 8GB RAM. Kernel is "3.1+for-linus".
>
> Any hints how i could speed it up?

Try:
- mounting it with nodatacow:
https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#Can_copy-on-write_be_turned_off_for_data_blocks.3F
- clobbering a big file:
https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#if_your_device_is_large_.28.3E16gb.29

... until you have at least 20% free space available.

-- 
Fajar
