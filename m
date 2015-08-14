Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:33980 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbbHNQfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 12:35:41 -0400
Received: by qgeg42 with SMTP id g42so55318488qge.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 09:35:40 -0700 (PDT)
Message-ID: <1439570139.25646.13.camel@kepstin.ca>
Subject: Re: The performance is not as expected when used several disks on
 raid0.
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Eduardo Bach <hellbach@gmail.com>, linux-btrfs@vger.kernel.org
Date: Fri, 14 Aug 2015 12:35:39 -0400
In-Reply-To: <1439569823.25646.11.camel@kepstin.ca>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	 <1439569823.25646.11.camel@kepstin.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2015-08-14 at 12:30 -0400, Calvin Walton wrote:
> On Fri, 2015-08-14 at 12:16 -0300, Eduardo Bach wrote:
> > Hi all,
> > 
> > This is my first email to this list, so please excuse any gaffe.
> > 
> > I am in the evaluation early stages of a new storage, an SGI MIS,
> > currently with two HBAs LSI and 32 disks.
> > The hba controllers are LSI 9207-8i and the disks are Seagate 6TB,
> > model ST6000NM0004-1FT17Z.
> > 
> > To evaluate the performance I am using IOzone over a raid0 using
> > all
> > the 32 disks, with the parameters: iozone -i0 -i1 -t5 -s 20G  -P0.
> > 
> > With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
> > result reaches 6gb/s, which is the expected value when compared
> > with
> > parallel dd made on discs.
> > When used btrfs with only half of the disc the result is about
> > 3GB/s.
> 
> There's two things in particular to pay attention with on btrfs  with
> this sort of setup right now:

Umm, Ok, I made a mistake. You can ignore paragraph #1 - I got some
details about the btrfs raid1 and raid0 modes mixed up!
Btrfs RAID0 is n-way striping across all available drives which have
room for allocations.

>    1. btrfs's "raid0" is not an n-way stripe; it's a 2-way stripe
> only. (n
>       -way stripe is a long requested feature, but there is no
> timeline on
>       its completion) A single-threaded disk write will only ever be
>       writing to two disks at the same time. The total throughput you
> get
>       for multithreaded writes is up to which blocks the allocator
> happens
>       to pick; it will probably often happen that multiple threads
> will
>       both be using the same chunk, sharing IO from only 2 disks.
>    2. Btrfs development is currently primarily focused on
> functionality
>       over performance. There's several places where placeholder or
>       untuned algorithms are used (e.g. the multi-mirror io read
>       scheduling just does pid % number_of_mirrors to pick a mirror).
> 
> This kind of a performance difference on large performance-oriented
> RAID systems between btrfs's built-in raid and mdadm is interesting
> to
> see, but for the moment I'd say it's mostly expected.
> 
> One of the developers here might have some more precise information
> on
> exactly why you're seeing such a performance difference.
> 
> As an aside, you have 192TB in RAID0? That's certainly pretty
> impressive, but as soon as one disk dies, you're going to lose a
> *lot*
> of data.
> 

-- 
Calvin Walton <calvin.walton@kepstin.ca>

