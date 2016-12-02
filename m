Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:44180 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbcLBTs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 14:48:28 -0500
Subject: Re: missing checksums on reboot
To: Blake Lewis <blake@portworx.com>, linux-btrfs@vger.kernel.org
References: <CAFuzrVeWdz2Lup-x1OiJjVcknQRysiiZVYG1doxNdGKiHB+Jaw@mail.gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <4533be53-6c95-11a4-e101-6df9ca88410f@bouton.name>
Date: Fri, 2 Dec 2016 20:47:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAFuzrVeWdz2Lup-x1OiJjVcknQRysiiZVYG1doxNdGKiHB+Jaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 02/12/2016 à 20:07, Blake Lewis a écrit :
> Hi, all, this is my first posting to the mailing list.  I am a
> long-time file system guy who is just starting to take a serious
> interest in btrfs.
>
> My company's product uses btrfs for its backing storage.  We
> maintain a log file to let us synchronize after reboots.  In
> testing, we find that when the system panics and we read the
> file after coming back up, we intermittently (but fairly often)
> get "no csum found for inode X start Y" messages and from our
> point of view, the log is corrupt.
>
> Here are a few pertinent details:
>
> 1) When we see this, the device is always an SSD.
> 2) We reproduce it easily with 3.10 kernels 

Wow. That's ancient and certainly full of various bugs fixed since its
release.

> but we have not
> been able to reproduce it in 4.8.
> 3) The log file is opened with O_SYNC|O_DIRECT; its size is 128MB
> and we are appending to it.
> 4) No other activity in the file system except a generated sequential
> write workload
> 5) Panics are induced with "echo c > /proc/sysrq-trigger".
>
> We filed a bug (https://bugzilla.kernel.org/show_bug.cgi?id=188051)
> but I wanted to see if anyone here recognized these symptoms and
> could point me in the right direction, especially since the problem
> seems to have gone away in more recent releases.  We can't realistically
> make our customers run newer kernels,

Why ? If the kernel has a bug they have to update it to get the fix,
there's no way around it. Unless they use exotic software (proprietary
kernel modules typically) which won't work with later kernels, updating
to a simple patch or a much newer kernel doesn't make much of a
difference (it may be hard to package a recent kernel for an ancient
distribution, but it's definitely doable and usually transparent for its
users).

Btrfs and old kernels don't mix *at all*. I wouldn't advise using it in
any environment where updating the kernel to the latest mainline isn't
possible.

AFAIK from my reading of this mailing list :
- btrfs developers don't backport patches, at least not to anything but
the latest stable kernel version (currently 4.4.x).
- distributions aren't known to backport patches either (you should ask
your distribution support for specifics to make sure). Note : I'm not
sure why they compile btrfs support making users think it's OK to use it
as-is but don't actually support it.

I think 3.10 is pretty much unmaintained btrfs-wise. So much work as
been done on btrfs the last 3 years (3.10 is more than 3 years old) that
applying patches to a 3.10 distribution kernel is probably orders of
magnitude more complex than packaging a recent kernel for an old
distribution.

Best regards,

Lionel
