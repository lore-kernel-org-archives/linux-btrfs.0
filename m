Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34622 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab2ITNob (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 09:44:31 -0400
Date: Thu, 20 Sep 2012 15:44:28 +0200
From: David Sterba <dave@jikos.cz>
To: =?iso-8859-1?Q?S=E9bastien?= Kalt <skalt@throka.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: open_ctree failed on external usb drive
Message-ID: <20120920134428.GN17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAN64BFbykhT6FqnW9i8j=t0nUTxXXfb9vjJeA3fUOFptsUpQVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAN64BFbykhT6FqnW9i8j=t0nUTxXXfb9vjJeA3fUOFptsUpQVw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2012 at 03:24:53PM +0200, Sébastien Kalt wrote:
> I'm running Debian Sid, 3.2.0-3-amd64 kernel and Btrfs v0.19

> (0.19+20120328-8 according to dpkg), using XFCE4 and dolphin as a file
> manager. The usb drive is auto-mounting, and I'm accessing it with
> dolphin or console. I always use the "remove device safely" feature
> from dolphin before disconnecting the drive or shutting down my
> laptop.

What does the 'remove safely' actually do?

eg.
sync, blockdev --flushbufs, echo 1 > /sys/block/sdX/device/delete ?

> [75447.624772] device label DD_SEB devid 1 transid 390 /dev/sdc1
> [75447.626348] btrfs: disk space caching is enabled
> [75447.666150] parent transid verify failed on 464265216 wanted 390 found 392

This has been fixed in 3.2 already, so it's possible that some
blocks were not written in the way the filesystem expects.

> btrfsck shows lots or problems (see
> https://dl.dropbox.com/u/747851/btrfsck.txt.gz 257K)
> 
> I've looked at my logfiles from thurday, and I didn't see any error
> concerning btrfs.

ie. not caused by crash.

> So I have three questions :
> 
> 1) did I do something wrong ?
> 2) is there a way to recover the data on this disk ?

Data from a 'parent transid verify' broken filesystem can be retrieved
by Josef's restore utility.

> 3) is btrfs a good choice for an external usb drive ?

If the drive unplugs unexpectedly, kernels < 3.4 do not handle this well.

david
