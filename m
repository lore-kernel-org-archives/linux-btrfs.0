Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32721 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab3LPSdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 13:33:39 -0500
From: Chris Mason <clm@fb.com>
To: "hkbakke@gmail.com" <hkbakke@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Blocket for more than 120 seconds
Date: Mon, 16 Dec 2013 18:33:33 +0000
Message-ID: <1387218823.18897.16.camel@ret.masoncoding.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	 <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	 <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	 <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	 <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	 <840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	 <CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	 <1387207097.18897.6.camel@ret.masoncoding.com>
	 <CAD_cGvGjkqPXp8guiBR4UsGCQti6rFgRN4Qg+fXLgfE-WkTtEg@mail.gmail.com>
	 <1387217823.18897.14.camel@ret.masoncoding.com>
	 <CAD_cGvH0p9jOB3Bm-A0Kv-b8aS=GB7DQQO9-uCa9v0ZHZgYRsQ@mail.gmail.com>
In-Reply-To: <CAD_cGvH0p9jOB3Bm-A0Kv-b8aS=GB7DQQO9-uCa9v0ZHZgYRsQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-16 at 19:22 +0100, Hans-Kristian Bakke wrote:
> I have explicitly set compression=lzo, and later noatime just to test
> now, else it's just default 3.12.4 options (or 3.13-rc2 when I tested
> that).
> 
> To make sure, here is my btrfs mounts from /proc/mounts:
> /dev/sdl /btrfs btrfs rw,noatime,compress=lzo,space_cache 0 0
> /dev/sdl /storage/storage-vol0 btrfs rw,noatime,compress=lzo,space_cache 0 0
> 
> /etc/fstab:
> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /btrfs  btrfs
> defaults,compress=lzo,noatime           0   2
> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /storage/storage-vol0
> btrfs   defaults,subvol=storage-vol0,noatime    0   2
> 
> Hardware:
> CPU: Intel Xeon X3430 (Quad Core)
> MB: Supermicro X8SI6-F
> RAM: 16GB (4x4GB) Samsung ECC/Unbuffered DDR3 1333mhz CL9 (MEM-DR340L-SL01-EU13)
> HDDs in btrfs RAID10: 8 x Western Digital Se 4TB 64MB 7200RPM SATA
> 6Gb/s (WD4000F9YZ)
> HBAs: LSI SAS 9211-8i, LSI SAS 9201-16i
> 

Ok, could you please capture the dmesg output after a sysrq-w during one
of the stalls during rsync writing?  We want to see all the stack traces
of all the waiting procs.

Defrag is a slightly different use case, so I want to address that
separately.

-chris

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
