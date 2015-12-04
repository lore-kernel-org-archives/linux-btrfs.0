Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51451 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbLDNmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 08:42:35 -0500
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: 3.16.0 Debian kernel hang
Date: Sat, 5 Dec 2015 00:42:32 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201512042100.58127.russell@coker.com.au> <5661906A.50309@gmail.com>
In-Reply-To: <5661906A.50309@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201512050042.32497.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 5 Dec 2015 12:08:58 AM Austin S Hemmelgarn wrote:
> > I know that there are no plans to backport things to 3.16 and I don't
> > think the Debian people are going to be very interested in this.  So
> > this message is a FYI for users, maybe consider not using the
> > Debian/Jessie kernel for BTRFS systems.
> 
> I'd suggest extending that suggestion to:
> If you're not using an Enterprise distro (RHEL, SLES, CentOS, OEL), then 
> you should probably be building your own kernel, ideally using upstream 
> sources.

There are lots of ways of dealing with this.

Debian development doesn't stop.  Anyone who is running a Jessie system can 
easily run a kernel from Testing or Unstable (which really isn't particularly 
unstable).  It's generally expected that Debian user-space will work with a 
kernel from +- one release of Debian.  Also every time I've tried it Debian 
has worked well with a CentOS kernel of a similar version.

The only reason I'm not running Unstable kernels on my Debian systems is 
because I run some Xen servers and upgrading Xen is problemmatic.  Linode is 
moving from Xen to KVM so I guess I should consider doing the same.  If I 
migrate my Xen servers to KVM I can use newer kernels with less risk.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
