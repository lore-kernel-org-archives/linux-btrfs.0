Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49841 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaEKMe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 08:34:56 -0400
Date: Sun, 11 May 2014 05:34:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140511123450.GC12513@merlins.org>
References: <20140508013440.GH11401@merlins.org>
 <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
 <20140508220242.GO11401@merlins.org>
 <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
 <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
 <20140509223659.GW11401@merlins.org>
 <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
 <20140510010902.GQ16185@carfax.org.uk>
 <CAKhhfD5c+poPPEYd=VLcU7m8xjORx9yc8TY7M3jZDRUapRX__w@mail.gmail.com>
 <pan$31216$3d0b94d7$92fede49$858a4a3e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$31216$3d0b94d7$92fede49$858a4a3e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, my apologies for the broken threads, I had one message where I
updated the subject line, but it got cut in two and sent part of the
headers in the body :(
(operator mistake, sorry)

On Sun, May 11, 2014 at 02:28:23AM +0000, Duncan wrote:
> > That's a fair point but I run scrub every day with errors if any, mailed
> > to me.
> > Can scrub miss latent corruption?
> 
> Depends on the type of corruption.  Scrub simply checks the checksums, 
> replacing any bad copies it finds with good copies if there's good copies 
> to do so with (thus my raid1 here, giving me an alternate to look at, too 
> bad I can't get N-way-mirroring yet and have a second alternate just in 
> case).  Bitflipping and random corruption, it should detect and if 
> possible fix, no problem.
 
So I was under the mistaken impression that scrub had to go through the
filesystem structure and would find corrupted files but also pointers
that went nowhere, or filesystems that had obvious damage.
It sounds like I was over optimistic on this one, so as per another
message, having an online btrfsck that tell me something is wrong, even
if it can't fix it, would indeed be a big plus.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
