Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44829 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3LPSln (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 13:41:43 -0500
Received: by mail-vc0-f171.google.com with SMTP id ik5so3440668vcb.16
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 10:41:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387218823.18897.16.camel@ret.masoncoding.com>
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
	<1387218823.18897.16.camel@ret.masoncoding.com>
Date: Mon, 16 Dec 2013 19:41:42 +0100
Message-ID: <CAD_cGvFfJSfZmWfGT945JQe29it8hy2_jF=7TPqT-nysTH3viw@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No problem. You have to wait a bit though, as the volume is currently
going through a reduction in the number of drives from 8 to 7 and I do
not feel comfortable stalling the volume while that is happening. I
will report back with the logs later on.

Mvh

Hans-Kristian Bakke


On 16 December 2013 19:33, Chris Mason <clm@fb.com> wrote:
> On Mon, 2013-12-16 at 19:22 +0100, Hans-Kristian Bakke wrote:
>> I have explicitly set compression=lzo, and later noatime just to test
>> now, else it's just default 3.12.4 options (or 3.13-rc2 when I tested
>> that).
>>
>> To make sure, here is my btrfs mounts from /proc/mounts:
>> /dev/sdl /btrfs btrfs rw,noatime,compress=lzo,space_cache 0 0
>> /dev/sdl /storage/storage-vol0 btrfs rw,noatime,compress=lzo,space_cache 0 0
>>
>> /etc/fstab:
>> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /btrfs  btrfs
>> defaults,compress=lzo,noatime           0   2
>> UUID=9302fc8f-15c6-46e9-9217-951d7423927c   /storage/storage-vol0
>> btrfs   defaults,subvol=storage-vol0,noatime    0   2
>>
>> Hardware:
>> CPU: Intel Xeon X3430 (Quad Core)
>> MB: Supermicro X8SI6-F
>> RAM: 16GB (4x4GB) Samsung ECC/Unbuffered DDR3 1333mhz CL9 (MEM-DR340L-SL01-EU13)
>> HDDs in btrfs RAID10: 8 x Western Digital Se 4TB 64MB 7200RPM SATA
>> 6Gb/s (WD4000F9YZ)
>> HBAs: LSI SAS 9211-8i, LSI SAS 9201-16i
>>
>
> Ok, could you please capture the dmesg output after a sysrq-w during one
> of the stalls during rsync writing?  We want to see all the stack traces
> of all the waiting procs.
>
> Defrag is a slightly different use case, so I want to address that
> separately.
>
> -chris
>
