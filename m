Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaADUs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 15:48:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzY9P-0002rM-Kb
	for linux-btrfs@vger.kernel.org; Sat, 04 Jan 2014 21:48:55 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 21:48:55 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 21:48:55 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Sat, 04 Jan 2014 12:48:44 -0800
Message-ID: <la9s31$v5b$1@ger.gmane.org>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <20140103172506.GA10021@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140103172506.GA10021@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/01/14 09:25, Marc MERLIN wrote:
> Is there even a reason for this not to become a default mount option
> in newer kernels?

autodefrag can go insane because it is unbounded.  For example I have a
4GB RAM system (3.12, no gui) that kept hanging.  I eventually managed to
work out the cause being a MySQL database (about 750MB of data only being
used by tt-rss refreshing RSS feeds every 4 hours).

autodefrag would eventually consume all the RAM and 20GB of swap kicking
off the OOM killer and with so little RAM left for anything else that the
only recourse was sysrq keys.

What I'd love to see is some sort of background worker that does sensible
things.  For example it could defragment files, but pick the ones that
need it the most, and I'd love to see extra copies of (meta)data in
currently unused space that is freed as needed.  deduping is another
worthwhile option.  So is recompressing data that hasn't changed recently
but using larger block sizes to get more effective ratios.  Some of these
happen at the moment but they are independent and you have to be aware of
the caveats.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLIc6wACgkQmOOfHg372QQgjgCeJp1sZQ0+Y7WRGE+U+IFljiDY
MgQAnjEBspyJZvTC2caEn1Qkn942vPQ2
=rhNY
-----END PGP SIGNATURE-----

