Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44969 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbbABXzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Jan 2015 18:55:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7C3g-0000A7-4d
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 00:55:08 +0100
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 00:55:08 +0100
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 00:55:08 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: scrub wedged (both running and not running at the same time)
Date: Fri, 02 Jan 2015 15:54:55 -0800
Message-ID: <m87b4g$v19$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I can't start a scrub because it is running, and can't cancel it
because it isn't running!  How do I get out of this state?  OS is
Ubuntu 14.10.

$ uname -r
3.16.0-28-generic

# btrfs scrub start .
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel .'.
To see the status use 'btrfs scrub status [-d] .'.
# btrfs scrub cancel .
ERROR: scrub cancel failed on .: not running
# btrfs scrub status .
scrub status for b02cc605-dd78-40bc-98a5-8f5543d83b66
	scrub started at Mon Nov 17 20:27:17 2014, running for 64491 seconds
	total bytes scrubbed: 3.43GiB with 1 errors
	error details: read=1
	corrected errors: 1, uncorrectable errors: 0, unverified errors: 0

Even a reboot doesn't make this go away.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSnL88ACgkQmOOfHg372QTpogCgvOpEAjIQI5dq+QPtRPty1gB/
3q0An0llPrQkIeDprwiH4pRBzuZdWdRg
=NXGR
-----END PGP SIGNATURE-----

