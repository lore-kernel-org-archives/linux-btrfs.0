Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:52173
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbbBTVDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 16:03:40 -0500
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id C77F021FB9
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 21:03:36 +0000 (GMT)
Message-ID: <54E7A128.1060603@barrowhillfarm.org.uk>
Date: Fri, 20 Feb 2015 21:03:36 +0000
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: scrub problem
References: <CABgvyo__OdS8N=Gwf-n58FTViyOi5ZWOcchud+Hmt1JfD8pNpw@mail.gmail.com>
In-Reply-To: <CABgvyo__OdS8N=Gwf-n58FTViyOi5ZWOcchud+Hmt1JfD8pNpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 20/02/15 19:59, Johan Kröckel wrote:
> The scrub is neither cancelable not stoppable. What is the 
> problem?
> 
> [root@host ]# btrfs scrub status ./ scrub status for 
> XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX scrub started at Thu Feb 19 
> 12:41:22 2015, running for 16964 seconds total bytes scrubbed: 
> 1.56TiB with 0 errors [root@host ]# btrfs scrub cancel ./ ERROR: 
> scrub cancel failed on ./: not running [root@host ]# btrfs scrub 
> start ./ ERROR: scrub is already running. To cancel use 'btrfs 
> scrub cancel ./'. To see the status use 'btrfs scrub status [-d] 
> ./'. --

If the local state file used to track scrub history has become
desynchronized, fix it by editing the file

/var/lib/btrfs/scrub.status.0b07b829-9a0e-44ab-89ee-14b36a45199e

(the last bit of the filename is the filesystem uuid)

Look for a line that ends with "finished:0" and change it to say
"finished:1"

Bob
- -- 
Bob Williams
System:  Linux 3.16.7-7-desktop
Distro:  openSUSE 13.2 (x86_64) with KDE Development Platform: 4.14.3
Uptime:  06:00am up 7:55, 3 users, load average: 0.16, 0.05, 0.06
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTnoSUACgkQ0Sr7eZJrmU75sQCcDTJvEufEFVaO8hgHp5SC81Lr
DUwAn2rKiCiyu7k0/6svdfhmlbFpn12B
=/2xH
-----END PGP SIGNATURE-----
