Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34292 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcAGV4A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 16:56:00 -0500
Received: by mail-io0-f182.google.com with SMTP id 1so220592209ion.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jan 2016 13:56:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
	<CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
	<CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
	<CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
	<CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
Date: Thu, 7 Jan 2016 14:55:59 -0700
Message-ID: <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
From: Chris Murphy <lists@colorremedies.com>
To: "cheater00 ." <cheater00@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not finding much about this.

http://www.spinics.net/lists/linux-btrfs/msg46537.html
http://www.spinics.net/lists/linux-btrfs/msg46279.html

The last one Anand Jain (developer) replied:
http://www.spinics.net/lists/linux-btrfs/msg46303.html

So I'm not sure if this problem is the same, and if the cause is
known. Best I can suggest is to try a newer kernel. Even 4.4.0rc8 is
stable enough to try; but there were quite a few btrfs patches for
4.3.3 as well. I would try 4.4.0 first to see if it reproduces. If
not, then try 4.3.3.

>4.3.0-040300rc7-generic #201510260712 SMP Mon Oct 26
>11:27:59 UTC 2015 i686 i686 i686 GNU/Linux

I think the other two cases are x86-64 so I don't think i686 is related.

There are quite a few messages:
swapper/6: page allocation failure: order:0, mode:0x20
[1129393.648245] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G        W  OE
  4.3.0-040300rc7-generic #201510260712

So the kernel is in a tainted state, I can't tell if that's related.

And also
usb 4-1.2: reset high-speed USB device number 7 using ehci-pci

One happens less than a minute before the first btrfs call trace. I've
had these messages also with USB drives, and they usually don't cause
a problem, and in my research it seems they can usually be ignored
except when there's subsequent problems. I ended up getting a powered
hub to put all the USB drives on and now I don't get these messages
anymore (so far anyway) and I also haven't had any Btrfs errors, which
I did rarely have happen prior to moving to the USB 3 powered hub;
even though the power shouldn't have been a factor since the drives
want 900mA at most (usually just spinning up), and standard USB 3
supplies 900mA.

Anyway, easiest is to move to a newer kernel to try to reproduce and
then start looking at hardware issues. What specific drive is
/dev/sdd? I'd make a note of that particular drive and see if it's the
same drive (not drive letter) if the problem happens again.


---
Chris Murphy
