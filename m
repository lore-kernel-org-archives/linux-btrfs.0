From: =?utf-8?b?0KTQuNC70LjQvyDQkdGA0YfQuNGb?= <brcha@gna.org>
Subject: Btrfs on Ubuntu
Date: Mon, 2 Mar 2009 16:58:57 +0100
Message-ID: <200903021658.59890.brcha@gna.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just wanted to inform you all that I've built btrfs packages for ubun=
tu=20
(intrepid). You can find them in my PPA=20
(http://launchpad.net/~brcha/+archive/ppa) and install them in the foll=
owing=20
way:

=46irst add the following lines to your /etc/apt/sources.list:

  deb http://ppa.launchpad.net/brcha/ppa/ubuntu intrepid main
  deb-src http://ppa.launchpad.net/brcha/ppa/ubuntu intrepid main

Then import my PPA signing key:

$ sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com=20
17f547c39c5c4071e254d0a7313d312748a22a95

update your package list:

$ sudo apt-get update

install btrfs-source and btrfs programs:

$ sudo apt-get install btrfs-source btrfs-progs module-assistant

and tell module assistant to build the btrfs module

$ sudo module-assistant prepare btrfs
$ sudo module-assistant auto-install btrfs

The packages include the latest "stable" versions of btrfs and btrfs pr=
ogs=20
(with a patched compat.h in btrfs module so that it can compile with 2.=
6.27.*=20
kernel).

Cheers & happy hacking :)

Brcha

--=20
=46ilip Br=C4=8Di=C4=87 <brcha@gna.org>
WWWeb: http://www.brcha.iz.rs
Jabber: brcha@kdetalk.net

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
