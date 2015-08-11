Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36283 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbbHKUcC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 16:32:02 -0400
Received: by ioeg141 with SMTP id g141so214641558ioe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 13:32:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ2L=s2KP8ttLkeA+pnOqePvToK-evsc9nA43Ewv3GgEw@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAK7bmU_xV=2Mh0zj6c3Wj54HDi0vCWmon-Z9E6h14hGws2-YAg@mail.gmail.com>
	<CAJCQCtQ2L=s2KP8ttLkeA+pnOqePvToK-evsc9nA43Ewv3GgEw@mail.gmail.com>
Date: Tue, 11 Aug 2015 16:32:01 -0400
Message-ID: <CAK7bmU8wyeX6THM=UB4_D3u-9j8hSuaZAY0uSASBXgcfkjfSTg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 3:57 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Aug 11, 2015 at 12:04 PM, Timothy Normand Miller
> <theosib@gmail.com> wrote:
>
>> https://bugzilla.kernel.org/show_bug.cgi?id=102691
>
> [    7.729124] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
> devid 2 transid 226237 /dev/sdd
> [    7.746115] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
> devid 4 transid 226237 /dev/sdb
> [    7.826493] BTRFS: device fsid ecdff84d-b4a2-4286-a1c1-cd7e5396901c
> devid 3 transid 226237 /dev/sdc
>
> What do you get for 'btrfs fi show'

# btrfs fi show
Label: none  uuid: 49ac9ad2-b529-4e6e-aef9-1c5b9e8a72f8
Total devices 1 FS bytes used 28.33GiB
devid    1 size 79.69GiB used 41.03GiB path /dev/sda3

Label: none  uuid: ecdff84d-b4a2-4286-a1c1-cd7e5396901c
Total devices 4 FS bytes used 1.46TiB
devid    2 size 931.51GiB used 767.00GiB path /dev/sdd
devid    3 size 931.51GiB used 760.03GiB path /dev/sdc
devid    4 size 931.51GiB used 767.00GiB path /dev/sdb
*** Some devices missing

Label: none  uuid: f9331766-e50a-43d5-98dc-fabf5c68321d
Total devices 1 FS bytes used 2.99TiB
devid    1 size 3.64TiB used 3.01TiB path /dev/sde1

btrfs-progs v4.1.2

>
> I see devid 2, 3, 4 only for this volume UUID. So you definitely
> appear to have a failed device and that's why it doesn't mount
> automatically at boot time. You just need to use -o degraded, and that
> should work assuming no problems with the other three devices. If it
> does work, 'btrfs replace start...' is the ideal way to replace the
> failed drive.

It's missing because I physically disconnected it.  Someone on IRC
suggested I try this in case the drive with the bad sector was
interfering.  Of course, now that I've done this and mounted
read/write, we can't reintegrate the failing drive.

If I lose the array, I won't cry.  The backup appears to be complete.
But it would be convenient to avoid having to restore from scratch,
and I'm hoping this might help you guys too in some way.  I really
like btrfs, and I would like provide you with whatever info might
contribute something.

>
> Maybe someone else can say whether nodatacow as a subvolume mount
> option will apply this to the entire volume.

At the moment, I'm only trying to mount the whole volume, just so I
could recover and scrub it, although as I mentioned in my earlier
email, the scrub aborts with no report of why and with "0 errors."



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
