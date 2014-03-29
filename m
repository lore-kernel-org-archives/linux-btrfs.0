Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:33038 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaC2Q2J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 12:28:09 -0400
Message-ID: <5336F2D9.4090602@automatix.de>
Date: Sat, 29 Mar 2014 17:20:41 +0100
From: Juergen Sauer <juergen.sauer@automatix.de>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9oYW4gS3LDtmNrZWw=?= <johan.kroeckel@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RHEL/CentOS or Debian for stable deployment
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
In-Reply-To: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 28.03.2014 13:29, schrieb Johan Kröckel:
> Hello,
> I am not sure whether this is the correct list, but I will try...
> I am on the way to deploy new server and already am using
> btrfs-volumes. At this point not for root, but in case a stable setup
> is possible, this would be cool, too.
> 
> I don't want to use vanilla kernel because I like it when someone else
> is watching security issues for me.
> So the question is:
> Which source for the kernel binaries would you use, to get stable
> btrfs support together with mentioned service?
> I am asking, because I don't know how Red Hat and Debian (Backports
> channel) are dealing with backporting new btrfs code to their
> distributed kernels.

None is really usable for development,  IMHO.

For Development we prefer "Arch Linux", it somewhat more "Bare Linux",
mostly all packages made from unpatched and unmodified "vanilla" sources.

Debian and CentOS are for Development mucht "to matrue", or harder
spoken, much too old.
If a product is ready for deployment, the other Debian / Ubuntu / SuSE /
Fedora / RedHat / CentOS got the Level of the system, which Arch had on
start time of development.

Then we enter package stage and depoy the product to the "stable"
Distributions.

On stable Setup/Server we prefer Debian or Ubuntu.

The Enterprise Distributions (aka. RHEL, SELS, CentOS) are looking to us
sometimes like "software achrchelogy ...


mit freundlichen Grüßen
Jürgen Sauer
- -- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM28tkACgkQW7UKI9EqarH/UgCeM/rQ2wKUjXC0az3UuCaSCW0O
ceMAoLGBXtYoqN5gi1CWvG7RHQbyF/r0
=4gue
-----END PGP SIGNATURE-----
