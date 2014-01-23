Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbaAWVra (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 16:47:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6S7V-0004Dp-7m
	for linux-btrfs@vger.kernel.org; Thu, 23 Jan 2014 22:47:29 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 22:47:29 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 22:47:29 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Working on Btrfs as topic for master thesis
Date: Thu, 23 Jan 2014 13:47:17 -0800
Message-ID: <lbs2kp$6km$1@ger.gmane.org>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local> <lbid3r$1ui$1@ger.gmane.org> <20140122121220.GF6498@twin.jikos.cz> <lbpb7v$7m2$1@ger.gmane.org> <20140123183624.GQ6498@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140123183624.GQ6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 23/01/14 10:36, David Sterba wrote:
> 'Theoretical best' seems too vaguely defined,

It seems like a good thing for someone to tackle as part of a master's
thesis :-)

> with compression it's always some trade-off and compromise

Which you can put in context against the theoretical best.  The links you
gave are a good example of trying to do that.

> This is a bit different usecase, defrag is triggered by user at the
> time he knows the resources are available

I'm a user and I use autodefrag :-)  As a developer you are more
interested in making users be aware of what they do, when they do it, and
carefully select the optimum conditions and configuration.

As a user I just want to point to a pile of storage and have btrfs do the
right thing, without me having to babysit it or play admin.  Computers
have billions of processor cycles per second, gigabytes of memory etc.
They should just figure this stuff out and not require me to be versed in
lots of intricate details!

> Keeping the dictionary implies more data to be read/written, with
> small chunks there's a low chance of actual dictionary reuse for other
> files.

I'm willing to bet that there is a good chance of reuse for files with the
same extension as an example.  And it is highly likely for Maildir files.

> Also, thinking about the implementaion, it would become too complex to 
> do in kernel for this particular usecase.

A thesis could study if it is worth doing first.  If it found that was a
good idea, then figuring out how to implement it is a second step.

> "To Zip or Not to Zip: Effective Resource Usage for Real-Time 
> Compression"

Except for systems that are 100% busy all the time, there is no need to
get perfect real time compression.  IMHO it is fine coming back later and
doing a better job of it.  Again this assumes that there is a sufficiently
large difference between what real time does and what a later
recompression does.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLhjeUACgkQmOOfHg372QTBKwCgxbWmfwr0MMfAo9bVwThmGTOq
F1EAoIsgVlzfeqPZS9zpKM1mJ3Cdw9LL
=IINU
-----END PGP SIGNATURE-----

