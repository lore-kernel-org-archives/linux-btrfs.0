Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:58184 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcE0FPG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 01:15:06 -0400
Date: Fri, 27 May 2016 10:14:57 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Diego Torres <diego.torres@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs stability
Message-ID: <20160527101457.2c560376@natsu>
In-Reply-To: <CAKg6aQzTx7NLjC6gZxKUKkuACo313N3ZqxQ0SXO4WXEwGPFNkg@mail.gmail.com>
References: <CAKg6aQzTx7NLjC6gZxKUKkuACo313N3ZqxQ0SXO4WXEwGPFNkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.=ADOPvtOod0pEbPYI/0oXC"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.=ADOPvtOod0pEbPYI/0oXC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 May 2016 00:42:07 +0200
Diego Torres <diego.torres@gmail.com> wrote:

> Btrfs is the only fs that can add drives one by one to an existing raid
> setup, and use the new space inmediately, without replacing all the drive=
s.

Ext4, XFS, JFS or pretty much any FS which can be resized upwards can also =
do
that, when placed on top of mdadm RAID5/6. It's not like you are absolutely
locked in to using Btrfs if you need that particular feature.

"Some of us" also prefer to use Btrfs on top of mdadm RAID, to benefit both
from Btrfs' advanced features such as snapshots, compression and checksum
verification (but not corruption resilience in this case), and from mdadm's
mature, well-tested and performant RAID implementations.

--
With respect,
Roman

--Sig_/.=ADOPvtOod0pEbPYI/0oXC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldH19MACgkQTLKSvz+PZwj9SACaA+XR+Qrag3bzDXch8KxfOvM1
6KwAn2pQuW1GOwyFYyo8nUjXvpaIq5Gl
=o+Ki
-----END PGP SIGNATURE-----

--Sig_/.=ADOPvtOod0pEbPYI/0oXC--
