Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38383 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbLAM53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 07:57:29 -0500
Received: by wmec201 with SMTP id c201so12191943wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 04:57:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
Date: Tue, 1 Dec 2015 23:57:28 +1100
Message-ID: <CA+WRLO-1K5sRYiVQ0tEF+WUHJFSe++3fWHaqZ7ZvkhopFaWcbw@mail.gmail.com>
Subject: Re: utils version and convert crash
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Poking around I just noticed that btrfs de stats /data points out that
3 of my drives have some read_io_errors. I'm guessing that is a bad
thing. I assume this would indicate bad hardware and would be a likely
cause of system crashes.

:(

On Tue, Dec 1, 2015 at 11:38 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> I'm getting some crashes when converting from RAID1 to RAID5, I know
> that there was some issues recently but was lead to believe that there
> were fixes that should have been in 4.3. (I'm using the ubuntu kernel
> ppa teams 4.3 kernel)
>
> One of the first things I checked was that I was using an up to date
> btrfs util and it keeps reporting that I'm using version 4.0 (btrfs
> --version). This is after confirming that my git clone is up to date,
> the last commit to my master is talking about v4.3.1 and the
> version.sh tells me it is 4.3.1 as well. Why the different reported
> versions?
>
> i'm converting in small chunks so I can then do a balance to recover
> the partial blocks, the following command locks the pc up
> occassionally. Mostly the balance completes happily on next boot but
> I've seen it cause a reboot once.
>
> btrfs fi balance start -dprofiles=raid1,convert=raid5,limit=1 /data
>
> After running that several times I'm using the following to clean up
> the partial RAID5 chunks:
>
> btrfs fi balance start -dprofiles=raid5,usage=21 /data
>
> I haven't noticed that clean up balance ever crashing.  Is this a
> known bug or should I try and discover the cause better. Dmesg and
> syslog don't have anything obvious in them.
>
> --
> Gareth Pye - blog.cerberos.id.au
> Level 2 MTG Judge, Melbourne, Australia
> "Dear God, I would like to file a bug report"



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
