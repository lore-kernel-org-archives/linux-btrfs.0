Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51473 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATDq3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 22:46:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W55oi-0001RH-PK
	for linux-btrfs@vger.kernel.org; Mon, 20 Jan 2014 04:46:28 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 04:46:28 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 04:46:28 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: btrfs-convert destroyed my system
Date: Sun, 19 Jan 2014 19:46:18 -0800
Message-ID: <lbi65u$33i$1@ger.gmane.org>
References: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com> <20140119011311.GC20097@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140119011311.GC20097@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 18/01/14 17:13, Marc MERLIN wrote:
> For what it's worth I also tried a btrfs convert on ubuntu precise
> with their stock kernel and old btrfs-tools and it mostly destroyed
> the filesystem too,

Just in case some folks think btrfs-convert never works, I had no problems
at all on two filesystems - a 128GB OS install & home directory on SSD and
a 2TB media disk (mainly ~7GB ISO files) on HDD.

The system was also Ubuntu 12.04 (Precise) running kernel 3.2.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLcnAYACgkQmOOfHg372QRMnQCePTWBDwI8iEdw67KpIbqAuHCw
xp4Anjcp1lbHdcP4ZR8ThfdOPH1EkiXS
=msAu
-----END PGP SIGNATURE-----

