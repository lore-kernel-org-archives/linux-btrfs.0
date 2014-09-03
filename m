Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33244 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbaICOLb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 10:11:31 -0400
Received: by mail-la0-f44.google.com with SMTP id hz20so9904919lab.17
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 07:11:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54070B5F.20100@fb.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
	<CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com>
	<54062424.9040508@fb.com>
	<CANg_oxy5p8mxeHtjGjVRvvntE9JY_yXxRFRDjbSny=XGa1ZGfg@mail.gmail.com>
	<CANg_oxzq3CAbj8iL1zK-_KFxSX7h2Z__9Yj1v-19EPwd-ijr=g@mail.gmail.com>
	<CANg_oxxn-4LXnG5t_wgX=ZvkLHc2tT8+TY-WEsn2awUTBsHSfA@mail.gmail.com>
	<54070B5F.20100@fb.com>
Date: Wed, 3 Sep 2014 16:11:29 +0200
Message-ID: <CANg_oxziMWqfWZsykPSx+LcYzXJEfbopw0RyNR78WXWkSno3sg@mail.gmail.com>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wasn't sure what you meant with <wherever you mkfs btrfs> so I dd'd
all the three possible cases:

1) here's the dmcrypt device on which I mkfs.btrfs

   2097152000 bytes (2.1 GB) copied, 487.265 s, 4.3 MB/s

2) here's the partition of the usb stick (which has another partition
containing /boot) on top of which the dmcrypt device is created

  2097152000 bytes (2.1 GB) copied, 449.693 s, 4.7 MB/s

3) here's the whole usb stick device

  2097152000 bytes (2.1 GB) copied, 448.003 s, 4.7 MB/s

It's a usb2 device but doesn't it seem kind of slow?

Thanks
John


On Wed, Sep 3, 2014 at 2:36 PM, Chris Mason <clm@fb.com> wrote:
> On 09/02/2014 09:31 PM, john terragon wrote:
>> Rsync finished. FWIW in the end it reported an average speed of about
>>  900K/sec. Without autodefrag there have been no messages about hung
>> kworkers even though rsync seemingly keeps getting hung for several
>> minutes throughout the whole execution.
>
> So lets take a step back and figure out how fast the usb stick actually is.
> This will erase your usb stick, but give us an idea of its performance:
>
> dd if=/dev/zero of=/dev/<wherever you mkfs btrfs> bs=20M oflag=direct count=100
>
> Note again, the above command will erase your usb stick ;)  Use whatever device name
> you've been sending to mkfs.btrfs
>
> The kernel will allow a pretty significant amount of ram to be dirtied before
> forcing writeback, which is why you're seeing rsync stall at seemingly strange
> intervals.  In the base of btrfs with compression, we add some worker threads between
> rsync and the device, and these may be turning the writeback into a somewhat
> more bursty operation.
>
> -chris
