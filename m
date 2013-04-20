Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54754 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab3DTURP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 16:17:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UTeDi-0003aE-BQ
	for linux-btrfs@vger.kernel.org; Sat, 20 Apr 2013 22:17:14 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 22:17:14 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 22:17:14 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: data DUP
Date: Sat, 20 Apr 2013 13:17:06 -0700
Message-ID: <kkut3u$lp1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Is there any particular reason why I can't use DUP for data?

When I try to set it with balance there is a kernel message:

  btrfs: dup for data is not allowed

The glossary at https://btrfs.wiki.kernel.org/index.php/Glossary says:

  Regular data cannot be assigned DUP level.

It is somewhat baffling that code and documentation exists to prevent this!

My current use case is an older hard drive I am putting backups on.  Since
my data fits in less than half of the drive, and drives get bad sectors
(this has had several it has reallocated) using DUP would be useful.

(I realise making two partitions and RAID-1 with them would work, which
makes the DUP restriction even sillier.)

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFy978ACgkQmOOfHg372QTCXwCdGuWbRFY8cZoWNFZb1k3mFeZM
nrkAoK9c5KddsJ1R57pAR1Lk89fPSo9Q
=ENfT
-----END PGP SIGNATURE-----

