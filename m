Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51636 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbLDO0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 09:26:12 -0500
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: 3.16.0 Debian kernel hang
Date: Sat, 5 Dec 2015 01:26:09 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201512042100.58127.russell@coker.com.au> <201512050042.32497.russell@coker.com.au> <56619AC3.5000309@gmail.com>
In-Reply-To: <56619AC3.5000309@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201512050126.09510.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 5 Dec 2015 12:53:07 AM Austin S Hemmelgarn wrote:
> > The only reason I'm not running Unstable kernels on my Debian systems is
> > because I run some Xen servers and upgrading Xen is problemmatic.  Linode
> > is moving from Xen to KVM so I guess I should consider doing the
> > same.  If I migrate my Xen servers to KVM I can use newer kernels with
> > less risk.
> 
> That's interesting, that must be something with how they do kernel 
> development in Debian, because I've never had any issues upgrading 
> either Xen or Linux on any of the systems I've run Xen on, and I 
> directly track mainline (with a small number of patches) for Linux, and 
> stay relatively close to mainline with Xen (Gentoo doesn't have all that 
> many patches on top of the regular release for Xen, aside from XSA
> patches).

I don't think that Debian does anything wrong in this regard.  It's just that 
my experience of Xen is that it is fragile at the best of times.  The fact 
that Red Hat packaged the Xen kernel in the Linux kernel package is a major 
indication of Xen problems IMHO, the concept of Xen is that it shouldn't be 
tied to a Linux kernel.

If you haven't had Xen issues then I think you have been lucky.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
