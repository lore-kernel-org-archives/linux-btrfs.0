Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbcCaTKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 15:10:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F0009AC64
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 19:10:14 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: <linux/btrfs.h> contents incomplete (?)
Message-ID: <56FD75FF.1070209@suse.com>
Date: Thu, 31 Mar 2016 15:09:51 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vHMboXA3NrCEPu2uCsKhRO5XRLCP7D5iS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vHMboXA3NrCEPu2uCsKhRO5XRLCP7D5iS
Content-Type: multipart/mixed; boundary="txiMRaqT2fbsUEAtHSFNTGWSdvMKWMX0l"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <56FD75FF.1070209@suse.com>
Subject: <linux/btrfs.h> contents incomplete (?)

--txiMRaqT2fbsUEAtHSFNTGWSdvMKWMX0l
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all -

I recently spent some time writing up btrfs ioctl decoding for strace to
be used in debugging various third party tools (e.g. snapper) in their
interactions with btrfs.[1]  In doing so, I found that substantial parts
of the tree interface haven't been exported via <linux/btrfs.h>.  For my
purposes, it was mostly flags and two structures passed in as ioctl
arguments. All things that are intended to be part of the API.  But as I
started to write up a patch to remedy that, I realized that we've
basically exported most of the file system internals via the SEARCH_TREE
ioctl.  In fact, the SEARCH_TREE ioctl is the intended interface for a
number of features (e.g. qgroup status).  As a result, pretty much every
item type, objectid values, etc are part of the API and should be
published via <linux/btrfs.h> for consumers.

I'm happy to do the lifting to move things around to make this happen,
but before I do, I wanted to ask:

Is it expected that consumers of the interface at this low a level will
provide their own copies of the structures, flags, types, and objectid
values they want to consume?  If so, why?  These are all on-disk format
values and effectively set in stone.  At least the ones that are already
defined.  Wouldn't things like new flags and reserved values being
claimed cause API drift pretty quickly and put the maintenance burden on
the third party developer?

-Jeff

[1] It's also pretty neat in that you can just write a quick program to
run an ioctl and not have to bother decoding most of it -- just look at
the strace output.  I do provide symbolic names for tree ids and key
types, but don't decode the item contents.

--=20
Jeff Mahoney
SUSE Labs


--txiMRaqT2fbsUEAtHSFNTGWSdvMKWMX0l--

--vHMboXA3NrCEPu2uCsKhRO5XRLCP7D5iS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJW/XYDAAoJEB57S2MheeWy+owP/RbFVwoOrhMB/yTuoQvImSIK
wHc6hXqogHyqoMPbZRVNZMbuzqBzpMI3AM1CzRYXA61RK0uYOYHrgwPyt4VN1fYR
LbVXi59pa/4R74MQujRwSX7jWmF5Wpi5Ng64GEElxH78LaRAY/oJbFwkn33A9uCF
Yrgn5+83gnIL14pIBG8Pfc96CoQ8hkNHQyTLRwd6qo++MFg8D/9uiziQqwEO0D1N
JF1r+GJUPRygP2V2CTkiJvVy1KiTjA1XoRL9agxuMP2qPqc054hlfc8fHHLlcWB5
pngorO1D/xvENTP2wxqicK6fKgzzbGI+zlr37htHO2LBk+4FQgdnNO1FbV6DXDNH
DmPEl1wLsIUQ/JUm0n0kGQ4Y6M4488I2iKLRfWDQqwbrS7SAj1wo5DpFejt+0F2p
YZi4RbpfT/ntAThnQstVv2g91ivBioJbQ4z08QbrAYuko8aj75Bu4twXy+xA6P81
KsxXV90WHsAC2dPEgDv8aLsM+dbVmkwIdroXQrPg8LrPDq6Qy1SRSl7JwUaaxY9K
b9KzlTTLntx4qdBXYO8MSn9b7Eic9U7k6OE7hxmvZUZOOhWs9wio0hPPzESVDy9Q
GB71CMms7X3ghNK8h5FJ2UVTeSojQactwuqL5KevU8Ejs25ZBXd1qKvlnRIyGo8l
Rznr5CmYXwOvFPlyldYI
=9zXg
-----END PGP SIGNATURE-----

--vHMboXA3NrCEPu2uCsKhRO5XRLCP7D5iS--
