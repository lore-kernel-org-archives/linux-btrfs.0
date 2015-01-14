Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:42995 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbbANAn3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:43:29 -0500
Message-ID: <54B5BB74.7060707@wizzup.org>
Date: Wed, 14 Jan 2015 01:42:28 +0100
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define __always_inline"
References: <1421187619-24936-1-git-send-email-jbacik@fb.com> <20150114001341.GP3685@twin.jikos.cz> <54B5B5FA.20904@wizzup.org> <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com> <alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box> <20150114004216.GR3685@twin.jikos.cz>
In-Reply-To: <20150114004216.GR3685@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xhgQtC3QHnN6m23SguL3BdPaxAak5FBGp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xhgQtC3QHnN6m23SguL3BdPaxAak5FBGp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 14/01/15 01:42, David Sterba wrote:
> On Wed, Jan 14, 2015 at 01:31:34AM +0100, Merlijn Wajer wrote:
>>> This only works if you include features.h and I don't know if other l=
ibcs provide that.  Thanks,
>>
>> musl provides /usr/include/features.h and glibc does so as well. (Chec=
ked
>> on musl and glibc systems) Searching the web seems to suggest that ucl=
ibc
>> supports it as well.
>=20
> I'd say that we care about these two right now.
>=20
>> Would you be in favour of including features.h and checking for __GLIB=
C__ ?
>=20
> Yes please.

Alright. I will send a patch tomorrow - it's definitely past bed time
here now. :-)

Sorry for the inconvenience.

Regards,
Merlijn


--xhgQtC3QHnN6m23SguL3BdPaxAak5FBGp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUtbt1AAoJEHmTPmZXIL578usQAMMJpSsVGQ6gCoqkhex1IJWa
/GklBuqcQytBsvt5l79ccjzm6DR7X1ZI4F1F0PXkH6+nNW2mFqvLtkgZni+tYyMe
sNy2Y/oBr//dWjxJUl8p6JQK97Gs6qPOeJvGHz9AnIfAL5vDGJu3RetiU9mXsgRP
Mo7LIz1Rj27uZ2P+706alBDIsLnIPKJdvdW/ngrjssUUbquae7KBaJheaOx5RXVl
OX/fK/hH7CLOsd3sPGpkJCa+/4A23XbG5IUvmlvj8N9/RXapujg2Is1Z1nrP0ZvH
FO961YyXcJJs6oUCOECoZL9X/PZ8AijTFEVILBSttLW1CTcqMD7TmE62tDqxxD5b
AoOCQ68HhQZiHWMqz4hKVNuOPxXBL9RBVbVMVnDIkZLNWxrmXEx9u12xdu3p57Bm
JWezzBdlJcxlbuJd0hnVbPvFkq55/K8CP2glCcG7UBQnvaLIqmIP93YSasLdLlwx
mpZ+0CY9Hht82TA8ElNTJTlYAq5l3QPuJZvWoIh2ZGMas8YJJDlbVmnx41+U7D4B
DYq0ksucE+4YFcVjzz2aBkIbUyCjRbPSflV+isL1NersKEY6VQs+EY+nGOUXSrKo
akMRdtb0d8lPGen+gJeLNUZWXlbosfiNG6OYxNvy+1N5xfck02+8URBw9qSVFh4P
lv61TQ7Y2tASKmSXUqmn
=GYfO
-----END PGP SIGNATURE-----

--xhgQtC3QHnN6m23SguL3BdPaxAak5FBGp--
