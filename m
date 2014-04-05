Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62137 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaDEJC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 05:02:58 -0400
Received: by mail-qa0-f42.google.com with SMTP id k15so4149337qaq.29
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 02:02:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANOdGizDdNvBjFu+LSGpUdpbO+PeuRLE=Qa-3eQRXhzDtpyFDw@mail.gmail.com>
References: <CANOdGizDdNvBjFu+LSGpUdpbO+PeuRLE=Qa-3eQRXhzDtpyFDw@mail.gmail.com>
From: Anders Aagaard <aagaande@gmail.com>
Date: Sat, 5 Apr 2014 11:02:37 +0200
Message-ID: <CANOdGixTCJ91HVmxOvdWj_3hp+MDnt7_cmtqE0Yb_UVQXOSCuQ@mail.gmail.com>
Subject: Re: dm-crypt + btrfs preformance - long lockups during io
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I should point out this as well:

# hdparm -tT /dev/sda

/dev/sda:
 Timing cached reads:   21408 MB in  1.99 seconds = 10762.26 MB/sec
 Timing buffered disk reads: 1156 MB in  3.00 seconds = 385.28 MB/sec

# hdparm -tT /dev/mapper/sda4_crypt

/dev/mapper/sda4_crypt:
 Timing cached reads:   21212 MB in  1.99 seconds = 10663.44 MB/sec
 Timing buffered disk reads: 1218 MB in  3.00 seconds = 405.66 MB/sec

So it doesn't seem to be an ssd performance issue.


On Sat, Apr 5, 2014 at 10:54 AM, Anders Aagaard <aagaande@gmail.com> wrote:
> Hi
>
> I just recently repartitioned my harddrive, and in the process switched from
> ext4+ecryptfs to dm-crypt and btrfs. I'm on ubuntu 14.04, using kernel
> 3.14.0-031400-generic. I'm using a intel ssd, which btrfs detects (ssd mode
> enabled according to dmesg).
>
> On IO access I'm occasionally experiencing huge hangs, I can do something as
> simple as installing a small package using dpkg and get what appears to be a
> 30 second complete hardlock, and then the system continuous fine. Nothing
> interesting shows up in dmesg, but I tried using latencytop to figure out
> what was going on.
>
> Target "chrome":
> Opening file - 6000ms
> fsync on file - 5500ms
> synchronous write - 4000ms
>
> Target "btrfs-endio-wri" (of wihch there are 3):
> wait_current_trans.isra.34 - 5800ms (for the other 2 it's 5800 and 3000ms).
>
> Target "kworker/u16:7)"
> wait.current.trans.isra34 - 1100ms
>
> Target "btrfs-transaction":
> sleep_on_page - 370ms
>
> Some info:
> # btrfs subvolume list /
> ID 257 gen 8282 top level 5 path @
> ID 258 gen 8282 top level 5 path @home
>
> # mount
> /dev/mapper/sda4_crypt on /home type btrfs (rw,noatime,subvol=@home)
> /dev/mapper/sda4_crypt on / type btrfs (rw,noatime,subvol=@)
>
> # cat /sys/block/sda/queue/scheduler
> noop [deadline] cfq
>
> Any ideas on what could be going on here, and what I can do to fix and or
> debug the problem?
>
> Best regards
> Anders



-- 
Weeks of coding can save you hours of planning.
- http://www.codebox.no
- http://code.google.com/p/aagaande/
