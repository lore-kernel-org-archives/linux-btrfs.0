Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:41609 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbbANAUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:20:14 -0500
Message-ID: <54B5B5FA.20904@wizzup.org>
Date: Wed, 14 Jan 2015 01:19:06 +0100
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define __always_inline"
References: <1421187619-24936-1-git-send-email-jbacik@fb.com> <20150114001341.GP3685@twin.jikos.cz>
In-Reply-To: <20150114001341.GP3685@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="W5RGcM85ASB3KFG6T7qPobb1PU26Bj8wu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W5RGcM85ASB3KFG6T7qPobb1PU26Bj8wu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 14/01/15 01:13, David Sterba wrote:
> On Tue, Jan 13, 2015 at 05:20:19PM -0500, Josef Bacik wrote:
>> This reverts commit c2691f807ddd2c6b261c5707f6838a45d9275390 as it bre=
aks
>> backtracing on actual glibc environments.
>=20
> This is to support musl libc. If it does not work then the test is wron=
g
> and should be fixed. CCed the author.

Thanks for letting me know. It unfortunately seems like I made a
mistake: it should be __GLIBC__ and not __glibc__.

Sorry about that. Would you like me to create a patch?

Regards,
Merlijn


--W5RGcM85ASB3KFG6T7qPobb1PU26Bj8wu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUtbYBAAoJEHmTPmZXIL57grAP/0K9CJuWtID1MMy3BiH5Pphf
Rf4DGVGiC/Rkk+FzgIBzYn72gxAyAQHbJKmdfa6GD4DjUvCvoPCnhnDUff0p9yw9
gqPLXM2J0pARjz03NuvVFC44pN9Wkc0SMxktqIQuLtpCsFmN4dwijfFkgRm55XsM
mbqa+soerEfuNGJU4WDZPJaQyxMhSN7yAuKKqUgrkVNLtustccs/rDm670gRwVE/
RKHbySo1dtjq2xqcJ6YOm0STgBB67tGFLjjngtctnBYONJd93GtFxYWr5irN1O1d
ujq9PHbeNU3ezyDPhCj98/NdfV5y31kb7JhXFBNGPqaiaWGKkVt28Arjo3bHI4M8
k/7sFlsnF914bgUKef/38vbD0tPrYnSufSrD2/ETRu+arI+Kd6b61rnLbCHMYS2S
ay4YZf5+FS1wEmzWIuHI/JZbFQVPK/1fVY54Wfw8s+7bPYrKn8xnaL4uD8tHfMzg
nnc+c0o2oXvQjO2xlCmO8+7LYFLEp9gtmYt4ve8nuy6/9cF325+i+zqR2kvSKew7
+FQE6st8s0jc0vudbuYtiAqMoyIoO17DPpb6hzR4FFKbitEvrTpR5uiifl98c8D+
MOoTbTPqzstefw2pG1gJrpxYjBwtDnraAaW+HhDzQ1f25PYPp4pc3MTvGjq2bXdz
D2765nAocWNsSyw0KhH1
=zluF
-----END PGP SIGNATURE-----

--W5RGcM85ASB3KFG6T7qPobb1PU26Bj8wu--
