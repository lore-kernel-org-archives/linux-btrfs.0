Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51332 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752082AbaKCRLU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 12:11:20 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: filesystem corruption
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141103034337.GM17395@hungrycats.org>
Date: Mon, 3 Nov 2014 10:11:18 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com> <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com> <20141103034337.GM17395@hungrycats.org>
To: Zygo Blaxell <zblaxell@furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 2, 2014, at 8:43 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:

> On Sun, Nov 02, 2014 at 02:57:22PM -0700, Chris Murphy wrote:
>> 
>> For example if I have a two device Btrfs raid1 for both data and
>> metadata, and one device is removed and I mount -o degraded,rw one
>> of them and make some small changes, unmount, then reconnect the
>> missing device and mount NOT degraded - what happens?  I haven't tried
>> this. 
> 
> I have.  It's a filesystem-destroying disaster.  Never do it, never let
> it happen accidentally.  Make sure that if a disk gets temporarily
> disconnected, you either never mount it degraded, or never let it come
> back (i.e. take the disk to another machine and wipefs it).  Don't ever,
> ever put 'degraded' in /etc/fstab mount options.  Nope.  No.

Well I guess I now see why opensuse's plan for Btrfs by default proscribes multiple device Btrfs volumes. The described scenario is really common with users, I see it often on linux-raid@. And md doesn't have this problem. The worst case scenario is if devices don't have bitmaps, and then a whole device rebuild has to happen rather than just a quick "catchup".



> 
> btrfs seems to assume the data is correct on both disks (the generation
> numbers and checksums are OK) but gets confused by equally plausible but
> different metadata on each disk.  It doesn't take long before the
> filesystem becomes data soup or crashes the kernel.

This is a pretty significant problem to still be present, honestly. I can understand the "catchup" mechanism is probably not built yet, but clearly the two devices don't have the same generation. The lower generation device should probably be booted/ignored or declared missing in the meantime to prevent trashing the file system.


Chris Murphy

