Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3A3Jtv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 04:49:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U0UIt-00017P-PQ
	for linux-btrfs@vger.kernel.org; Wed, 30 Jan 2013 10:50:03 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:50:03 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:50:03 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: RAID 0 across SSD and HDD
Date: Wed, 30 Jan 2013 01:27:37 -0800
Message-ID: <keap27$oqb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've been unable to find anything definitive about what happens if I use
RAID0 to join an SSD and HDD together with respect to performance
(latency, throughput).  The future is obvious (hot data tracking, using
most appropriate device for the data, data migration).

In my specific case I have a 250GB SSD and a 500GB HDD, and about 250GB of
files (constantly growing).  One message I saw said that new blocks are
allocated on the device with the most free space which implies the SSD
would be virtually unused in my case, except for metadata which would only
be used half the time.

At the moment I have two independent filesystems (one per device) and
manually move data files between them using symlinks to keep pathnames the
same.  This requires keeping lots of slop free space on the SSD as well as
administration whenever it runs out of space.

My hope would be overall performance between that of the two devices, and
closer to that of the SSD.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlEI54kACgkQmOOfHg372QR1HwCfROJ10FAC51V0wuLSRwPq0LSL
2GwAmQF1F2k3cthGThEbf67Xn3usKS1K
=HFi8
-----END PGP SIGNATURE-----

