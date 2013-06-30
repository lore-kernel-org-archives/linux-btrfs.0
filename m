Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53972 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3F3XMY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 19:12:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UtQn9-0006sB-6p
	for linux-btrfs@vger.kernel.org; Mon, 01 Jul 2013 01:12:23 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 01:12:23 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 01:12:23 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: unclean shutdown and space cache rebuild
Date: Sun, 30 Jun 2013 16:12:12 -0700
Message-ID: <kqqe06$hg9$1@ger.gmane.org>
References: <11441914.sRzrmH57Vq@bheem> <4774295.3Q3X7zsTmb@vfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <4774295.3Q3X7zsTmb@vfr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 30/06/13 10:53, Garry T. Williams wrote:
> ~/.cache/chromium/Default/Cache ~/.cache/chromium/Default/Media\ Cache

I've taken to making ~/.cache be tmpfs and all the apps have been fine
with that.  It also meant I didn't have to worry about my btrfs snapshots
being full of transient web junk.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHQu0wACgkQmOOfHg372QRTMACg1YQx1B6liiLnVpOZLxnoHC+W
5ewAn1Z40V/52dongHBpg6OUdprUVqwo
=601F
-----END PGP SIGNATURE-----

