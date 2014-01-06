Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50234 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAFAZ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 19:25:56 -0500
Received: from [192.168.0.2] ([91.115.176.179]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LoEwL-1VSX4V37ZR-00gD3N for
 <linux-btrfs@vger.kernel.org>; Mon, 06 Jan 2014 01:25:54 +0100
Message-ID: <52C9F80F.4080500@gmx.at>
Date: Mon, 06 Jan 2014 01:25:51 +0100
From: Sulla <Sulla@gmx.at>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at> <846FC885-56B5-422B-9366-D690D4258139@colorremedies.com> <06E20869-27B1-4868-8F0E-F78A154E76F0@colorremedies.com>
In-Reply-To: <06E20869-27B1-4868-8F0E-F78A154E76F0@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thanks Chris!

Thanks for your support.

>> echo 120 >/sys/block/sdX/device/timeout
timeout is 30 for my HDDs. I'm well aware that the WD green HDDs are not
the perfect ones for servers, but they were cheaper - and quieter - than
the black ones for servers. I'll get the red ones next, though. ;-)

>> You also need to schedule regular scrubs at the md level as well.

Ubuntu does that once a month.

>> cat /sys/block/mdX/mismatch_cnt
this resides in cat /sys/devices/virtual/block/md1/md/mismatch_cnt on my
machine.
the count is zero.

>> The workload is presumably small file sizes, like a mail server?
Yes. It serves as a mailserver (maildir-format), but also as a samba file
server with quite big files...

btrfs ran fine for more than a year, so I'm not sure how reproducible the
problem is...

I don't really wish to install or compile cumstom kernels, to be honest.
Not sure how problematic they might be during the next do-release-upgrade...

Sulla


- -- 
Russian Roulette is not the same without a gun
and baby when it's love, if it's not rough, it isn't fun, fun.
   Lady GaGa, "Pokerface"












-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLJ+A8ACgkQR6b2EdogPFuFwwCffSjZpDJvIj70Ag+CPbClCVuc
viEAnjqnxcEdhKR2Gq84eGYEXfjfb23F
=pmTS
-----END PGP SIGNATURE-----
