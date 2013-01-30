Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57594 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3A3UGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:06:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U0dvv-0002ZT-T8
	for linux-btrfs@vger.kernel.org; Wed, 30 Jan 2013 21:06:59 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 21:06:59 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 21:06:59 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: RAID 0 across SSD and HDD
Date: Wed, 30 Jan 2013 12:06:32 -0800
Message-ID: <kebug6$in6$1@ger.gmane.org>
References: <keap27$oqb$1@ger.gmane.org> <20130130100201.GN16285@carfax.org.uk> <keatr3$65q$1@ger.gmane.org> <20130130120155.GA20862@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130130120155.GA20862@panda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 30/01/13 04:01, Sander wrote:
> Do you know about bcache and EnhanceIO ?

Yes, but there are two reasons I don't use them.  One is that the capacity
of your cache is not included in the filesystem - ie with a 250GB SSD and
500GB the filesystem capacity will be 500GB not 750GB.

The second is that I use btrfs for my root filesystem so I'd have to get
bcache/EnhanceIO integrated into the distributor's initramfs build
mechanism, as well as worry about livecd/network boots without it.  This
is a lot of unnecessary work and worry.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlEJfUgACgkQmOOfHg372QR42wCfUV9MK6luScTtu59g4p9BsTdf
6/8AoLlumP6NeEsSv/pmgd+857m/2LUF
=Eigx
-----END PGP SIGNATURE-----

