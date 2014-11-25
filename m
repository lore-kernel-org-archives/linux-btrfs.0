Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaKYKac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 05:30:32 -0500
Date: Tue, 25 Nov 2014 18:30:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: John Williams <jwilliams4200@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125103024.GC23574@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <pan.2014.11.24.08.23.25@googlemail.com>
 <pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
 <CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 11:34:46AM -0800, John Williams wrote:
> On Mon, Nov 24, 2014 at 12:23 AM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
> 
> > Would there be room for a compromise with e.g. 128 bits?
> 
> For example, Spooky V2 hash is 128 bits and is very fast. It is
> noncryptographic, but it is more than adequate for data checksums.
> 
> http://burtleburtle.net/bob/hash/spooky.html
> 
> SnapRAID uses this hash, and it runs at about 15 GB/sec on my machine
> (Xeon E3-1270 V2 @ 3.50Ghz)

Thanks for the suggestion, I'll take a look.

Btw, it's not in kernel yet, is it?

thanks,
-liubo
