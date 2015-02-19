Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:39385
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbbBSPnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 10:43:14 -0500
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 9014321B62
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 15:43:13 +0000 (GMT)
Message-ID: <54E60490.1000908@barrowhillfarm.org.uk>
Date: Thu, 19 Feb 2015 15:43:12 +0000
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Re-assembling a btrfs raid1 array
References: <54E5ACE0.7000709@barrowhillfarm.org.uk> <54E5B58C.50704@barrowhillfarm.org.uk>
In-Reply-To: <54E5B58C.50704@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 19/02/15 10:06, Bob Williams wrote:
> On 19/02/15 09:29, Bob Williams wrote:
>> My system comprises 2 x 3TB hard drives,
[...]
> 
> Whoops. I really meant to say:
> 
> # btrfs device add -f /dev/sdg2 / # btrfs balance start
> -dconvert=raid1 -mconvert=raid1 /
> 
Sorted. Sorry for the noise. ;-)

- -- 
Bob Williams
System:  Linux 3.16.7-7-desktop
Distro:  openSUSE 13.2 (x86_64) with KDE Development Platform: 4.14.3
Uptime:  06:00am up 7:55, 3 users, load average: 0.16, 0.05, 0.06
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTmBI8ACgkQ0Sr7eZJrmU79SQCfadZjwKoxdD24JVcfwDeHZDqw
nP4An0wF1wqlO/nD3YOkZuTCFzkX1166
=b3kc
-----END PGP SIGNATURE-----
