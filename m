Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46328 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdDJCjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 22:39:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxPEO-0003SC-NM
        for linux-btrfs@vger.kernel.org; Mon, 10 Apr 2017 04:39:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS not mountable, recover won't work
Date: Mon, 10 Apr 2017 02:38:59 +0000 (UTC)
Message-ID: <pan$7c27b$c263c2d$90d3ff1f$9c677070@cox.net>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
        <CAJCQCtRqidKACy7SAEzpEGLK1PbWQZgbesaLhLEVntMPz9aG5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 09 Apr 2017 15:25:18 -0600 as excerpted:

> On Sun, Apr 9, 2017 at 11:17 AM, Malte Eggers
> <m.eggers@campus.tu-berlin.de> wrote:
>> Hi,
>>
>> After suspending and waking up my laptop with the external hard drive
>> connected, I could no longer access the files on it. So I unmounted and
>> remounted it, only to discover that I could no longer mount it.

This is the only message from the thread I'm seeing ATM, so I'll reply 
here.  Agreed with C Murphy on the btrfs stuff, but my reply is on a 
different tangent.

If your external hard drive is USB (not ESATA or other non-USB, couldn't 
tell from the context CM quoted, which may or may not have been the 
entire post), you are likely running into a known issue... with an 
available solution. =:^)

FWIW I found out about this when I had a laptop with two USB-connected 
CompactFlash slots, one of which was designed for effectively permanent 
installation (the CF didn't stick out when inserted), the other for 
temporary use (it stuck out and was thus easier to remove, but also easy 
to damage either it or the slot if it was left inserted during 
transport).  But the permanent one wouldn't stay mounted over suspend... 
until I found out about this and changed the kernel option.  Looks like 
you might be hitting the same issue.

The official Linux kernel documentation describing the problem and 
optional solution is:

$KERNEL_DIR/Documentation/usb/persist.txt 

Read that first.  But that only explains the problem and gives you a way 
to deal with it on a per-USB-device basis by writing to the appropriate 
sysfs file.  There's also a kernel option that lets you change the 
default:

CONFIG_USB_DEFAULT_PERSIST

In the kernel config that's found under:

Device Drivers
	USB support
		Support for Host-side USB
			Enable USB persist by default

If you use a distro-built kernel, you may want to at least check whether 
they enabled that option or not.

If you build your own kernel, you may of course set that option as you 
wish. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

