Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53311 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab3D1I3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Apr 2013 04:29:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UWMz2-0001DQ-E6
	for linux-btrfs@vger.kernel.org; Sun, 28 Apr 2013 10:29:20 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 10:29:20 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 10:29:20 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: data DUP
Date: Sun, 28 Apr 2013 01:29:13 -0700
Message-ID: <klimkl$smn$1@ger.gmane.org>
References: <kkut3u$lp1$1@ger.gmane.org> <20130420204814.GN7639@carfax.org.uk> <kkv0gv$jpo$1@ger.gmane.org> <20130420212311.GO7639@carfax.org.uk> <kkv6o8$9f0$1@ger.gmane.org> <1367098836.14073.5.camel@ayu> <klhn0u$vcr$1@ger.gmane.org> <kli302$pit$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <kli302$pit$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/04/13 19:53, Alex Elsayed wrote:
> When using btrfs, run a recent kernel :P.

Every software developer says that of what they produce.  Newer is almost
always better in many different axes.

> Honestly, even leaving aside the lack of backporting, there are other 
> benefits to a recent kernel - things like cross-subvolume reflinks,
> btrfs device replace support being far more efficient than 
> add/balance/remove/balance, and a bunch more.

Those are all "features", none of which I use or have had to use yet.

If it will make you feel better I did upgrade some systems today to the
most recent Ubuntu release which meant going from kernel 3.5 to 3.8.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlF83dUACgkQmOOfHg372QQeDACgz0oBnrYeg6fO5tFxUy9qonE9
HYIAoJWjT8z2sJ356YAph1NAyLKhcEBz
=ySAg
-----END PGP SIGNATURE-----

