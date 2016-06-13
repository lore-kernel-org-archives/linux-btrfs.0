Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbcFMUTY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 16:19:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 67E3BAAAD
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 20:19:22 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: prefix fsid to all trace events
To: dsterba@suse.cz, Btrfs Development List <linux-btrfs@vger.kernel.org>
References: <1465516081-26045-1-git-send-email-jeffm@suse.com>
 <1465516081-26045-2-git-send-email-jeffm@suse.com>
 <20160613154814.GC6205@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b9e6442b-a75b-6e65-d280-f1624feed4d7@suse.com>
Date: Mon, 13 Jun 2016 16:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <20160613154814.GC6205@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VjsoJpQIa5gaxqlPER8sFtSuxRhFP9wG6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VjsoJpQIa5gaxqlPER8sFtSuxRhFP9wG6
Content-Type: multipart/mixed; boundary="G2UOAuVE3fIC2gF3LkXEg7w5Qdi1Dtbws"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Btrfs Development List <linux-btrfs@vger.kernel.org>
Message-ID: <b9e6442b-a75b-6e65-d280-f1624feed4d7@suse.com>
Subject: Re: [PATCH 2/2] btrfs: prefix fsid to all trace events
References: <1465516081-26045-1-git-send-email-jeffm@suse.com>
 <1465516081-26045-2-git-send-email-jeffm@suse.com>
 <20160613154814.GC6205@twin.jikos.cz>
In-Reply-To: <20160613154814.GC6205@twin.jikos.cz>

--G2UOAuVE3fIC2gF3LkXEg7w5Qdi1Dtbws
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/13/16 11:48 AM, David Sterba wrote:
> On Thu, Jun 09, 2016 at 07:48:01PM -0400, jeffm@suse.com wrote:
>> +#define TP_printk_btrfs(fmt, args...) \
>> +	TP_printk("%pU: " fmt, __entry->fsid, args)
>=20
> So it's identified by the UUID. As there's no previous format of the
> filesystem identifier (unlike the syslog messages), I'm ok with using
> the UUID.

Buried in the patch is actually the single use of a previous format for
trace events that I've converted to use the macros.  It's the
btrfs_space_reservation that Josef added in 2012[1].

I wouldn't have minded a shorter identifier but given how prevalent its
usage is internal to the FS, its exported interfaces, and tools
surrounding it, it seems like it's the only real choice.

-Jeff

[1] 8c2a3ca20f6 (Btrfs: space leak tracepoints)

--=20
Jeff Mahoney
SUSE Labs


--G2UOAuVE3fIC2gF3LkXEg7w5Qdi1Dtbws--

--VjsoJpQIa5gaxqlPER8sFtSuxRhFP9wG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXXxVGAAoJEB57S2MheeWyFiAP/ixw+BElHz6Abf8kymN9eHs2
uQFL7g1r8zHd8wQr4RrP90stsVft4G5NVevVq6M2xIXF2EN+RbW84Pt9QsXl8a6k
P2XC4zL7fLVELWRIzyk1bHCc4q3yKl/6xqCybFQY3rvjvULWEHFO+fx3AwDd3BLw
Hl5ie7kC32+LV3a4LHyZ/B4IOIlWrocgwBeoEKWK7btGnWb5RloDFPFFQ4yrhaHH
+NIfV4yObAAR23lGjfHlScvx3XpW2fvVi8KC3RJZXzI7Fnf5cEnqx08zeaP/Howb
pqiiP1iPc1pUmdf89ParcO0rH+aLUOsGsqcY0qVEUMq3QQr2dQ3DOLXP/W0BtrZv
syaHVKTQMXl3XDhMmQzIR0kvIvHQt3snRupKnRoWD04H4PQL7jB1Q+Lk2Sf2mQYZ
KOhJ1p8IjX/LIDVEKycgp+qxlf9SnPB1gmAqtdnhiKEDy0Ww3iwFKpUTmDCjDpIi
oPlV3cbNZlZRqXc2Tx8F0xnmI+4XxB0nLPHB8hX6fJ2v8Bum9B3mipd4cbebvKBA
PcABeS4f+kuEZvg0pQdY8AEigycUobXc/v6+a41VRoUK21nzOpo7FRL/bY8tFTAG
HZXIdvHOHvn2VDf7Iuh2coPL8HtIDTqx5QmkfQegjiRKZeMVY7qFUdb5W0VnlUx/
1+qHmJz5pRxh8KR/yZW4
=QqGG
-----END PGP SIGNATURE-----

--VjsoJpQIa5gaxqlPER8sFtSuxRhFP9wG6--
