Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:55329 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbbEYD4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 May 2015 23:56:39 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: Did convert do anything?
From: Anthony Plack <tmy@plack.net>
In-Reply-To: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
Date: Sun, 24 May 2015 22:56:37 -0500
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <036B4518-F7BF-4C9A-8906-38550D7F125F@plack.net>
References: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
To: Gareth Pye <gareth@cerberos.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 24, 2015, at 8:02 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> 
> Just attempted to change the meta data of my 6 drive array to RAID6 with:
> 
> # btrfs balance start -mconvert=raid6 /data
> Done, had to relocate 12 out of 4548 chunks
> 
> Which looks pretty good. But:
> 
> # btrfs  fi df /data
> Data, RAID1: total=4.43TiB, used=4.41TiB
> System, RAID1: total=32.00MiB, used=772.00KiB
> Metadata, RAID1: total=11.00GiB, used=9.13GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> And some context:
> 
> # btrfs --version
> btrfs-progs v4.0
> 
> # uname -a
> Linux emile 4.0.1-040001-generic #201504290935 SMP Wed Apr 29 09:36:55
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> What am I missing here?
> 
> 
> 
> -- 
> Gareth Pye
> Level 2 MTG Judge, Melbourne, Australia
> "Dear God, I would like to file a bug report"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Two things:

1. What is the output of "btrfs fi sh /data”
2. There is not allot of free space on this volume.