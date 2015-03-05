Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57087 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbCEXsa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Mar 2015 18:48:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YTfVD-0000xH-Am
	for linux-btrfs@vger.kernel.org; Fri, 06 Mar 2015 00:48:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 00:48:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 00:48:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Occasional read error on idle USB attached disk
Date: Thu, 5 Mar 2015 23:48:22 +0000 (UTC)
Message-ID: <pan$56ae6$4c8d96dc$29b43325$31926dc2@cox.net>
References: <CAPs0BiibA5CmL8QOyUR67oLG_3Za+KfPT16eTo75u-L_z1k4VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur Jr posted on Thu, 05 Mar 2015 17:04:18 -0500 as excerpted:

> I have a btrfs filesystem that gets read errors that appear to only
> happen after a disk has been idle a while. I don't know if the error
> output below is BTRFS, USB, both or other related. I suspect it's timing
> related. If I should take this error report somewhere else,
> please point me in the right direction.
> 
> I have a large RAID1 btrfs filesystem (>13TB) that provides
> archive/backup space that is housed in a multi-drive USB enclosures
> comprising of WD Red drives. I noticed errors in dmesg, so I'd run a
> `btrfs scrub` and for two days it'd report zero errors. Within hours of
> the scrub completing I'd start seeing "csum failed ino" or other errors
> again. Not wanting to run a btrfs scrub 24/7 as it impacts load and
> available I/O I thought of a crude workaround...
> 
> My workaround is every minute cron runs the unfortunate script below
> which is my hack to create some minimal random activity and this has had
> the effect of eliminating btrfs errors in dmesg since I installed it ~5
> days ago.
> 
> #!/bin/bash
> for dev in /dev/disk/by-path/*-usb-*
> do
>  dd "if=$dev" skip=$RANDOM of=/dev/null bs=1k count=1 conv=noerror
>  sleep 1
> done
> 
> Also: I have used `idle3ctl -d` on every WD drive to configure them not
> to idle spin down.
> 
> I'd like to eliminate the need for script above but I don't know what to
> look into for more insight.
> 
> 
> Below are examples of errors in dmesg output that I believe to be from
> after an idle time.

[snip, but thanks for providing]

> # btrfs --version
> Btrfs v3.18.2
> 
> # uname -a
> Linux mcplex 3.18.4-gentoo #1 SMP Wed Jan 28 22:25:43 EST
> 2015 x86_64 Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel
> GNU/Linux

First, I'm not a dev, let alone a kernel/btrfs dev, just an admin and 
regular on the list.  And also a fellow gentooer. =:^)

Given the symptoms and the relatively modern and thus power-saving 
platform, I too suspect it's idle-timeout related.  Specifically, given 
that the drives are attached via USB, I strongly suspect that it's 
automatic USB device-idle power-down, as enabled by the kernel.  On old 
enough equipment (or for that matter kernels, but of course btrfs wasn't 
around or at least not reasonably usable then) you'd likely not see it, 
as power-saving to that degree is a relatively recent innovation.

I strongly suspect there's power-related sysfs files you can poke, to 
disable the power-saving for the USB, which should solve the problem.  
Tho not being a dev I'd have to do the same sysfs browsing you'll need to 
do to find them (unless someone else points you to them), so I might as 
well leave that for you (or them).

Alternatively, of course, since you mentioned an apparent timeout of 
hours and are obviously triggering it, you could configure your archiving/
backup scripts to reactivate the USB before access, and even power-down 
after access completes, until the next time.


Meanwhile, if you're going to run a script, might as well have it do 
something (semi-)useful. =:^)

I suspect that you don't actually have to do drive I/O to keep the USB 
from timing out, pretty much any activity should do.  And as it happens, 
while it's direct SATA connections not USB here and that might add a kink 
to things, I monitor and graph device temps, with the temp queries 
showing up as traffic on the device-activity LEDs as if it were I/O.  
Which it is, over the (SATA in my case) bus to the device logic, just not 
to the physical media.

What I'm suggesting, assuming it works over USB which I'd hope it can, is 
that you do device temperature monitoring.  If I'm not mistaken, that'll 
effectively kill two birds with one stone, giving you better device 
information and possibly warning if a device starts to overheat before it 
goes bad, /and/ providing bus activity, thus avoiding the idle-timeout 
power-downs.

As you're a gentooer as well, merge app-admin/hddtemp and read the 
manpage.  There's a daemon mode, which I believe would do the polling and 
avoid the idle timeouts by itself, and you can either have it log to 
syslog every N seconds, or listen on a tcp port (7634 by default), and 
run a script to query that port with net-analyzer/netcat or the like.  
Alternatively, simply run hddtemp and let it output to STDOUT, scripting 
that and logging/grabbing its output using whatever (superkaramba on my 
desktop, here), which is what I do.

Two minor doubts of the "I've not actually tried it here using USB as 
you're using" level, tho I suspect it'll work fine once setup:

1) Will hddtemp will work over USB?  It can handle SCSI, which is what USB 
storage connects with, so in theory it should work fine, tho you might 
have to specify type SCSI or whatever, if hddtemp's autodetect doesn't 
work.

2) Will it actually stop the idle-timeouts?  I strongly suspect it will 
as I see no reason why it should have to be physical media I/O, but since 
I've not actually tried it, that's still theory, which unfortunately 
doesn't always match reality.

[sig:]

> "No nation could preserve its freedom in the midst of continual
> warfare." - Letters and Other Writings of James Madison (1865), Vol. IV,
> p. 491

=:^)

You see my list sig below.  My general mail sig is Ben Franklin:
"They that can give up essential liberty to obtain a little temporary 
safety, deserve neither liberty nor safety."

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

