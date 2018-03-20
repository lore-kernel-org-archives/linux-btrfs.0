Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60265 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbeCTFTi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 01:19:38 -0400
Subject: Re: [PATCH] btrfs-progs: inspect-dump-tree: add '-f|--follow' options
 to print all children tree blocks for '-b'
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180314010538.29292-1-wqu@suse.com>
 <20180319184418.GO6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d37c8bd2-995c-8a19-c2ba-be32e9313bd8@gmx.com>
Date: Tue, 20 Mar 2018 13:19:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180319184418.GO6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Loc8DHjbAIeS9X5qMWTmL5HO6GVYj7i4J"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Loc8DHjbAIeS9X5qMWTmL5HO6GVYj7i4J
Content-Type: multipart/mixed; boundary="Z53GoSRN15hKmnSz7mHqvqSHj8AEPxLxT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d37c8bd2-995c-8a19-c2ba-be32e9313bd8@gmx.com>
Subject: Re: [PATCH] btrfs-progs: inspect-dump-tree: add '-f|--follow' options
 to print all children tree blocks for '-b'
References: <20180314010538.29292-1-wqu@suse.com>
 <20180319184418.GO6955@twin.jikos.cz>
In-Reply-To: <20180319184418.GO6955@twin.jikos.cz>

--Z53GoSRN15hKmnSz7mHqvqSHj8AEPxLxT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8820=E6=97=A5 02:44, David Sterba wrote:
> On Wed, Mar 14, 2018 at 09:05:38AM +0800, Qu Wenruo wrote:
>> When debuging with "btrfs inspect dump-tree", it's not that handy if w=
e
>> want to iterate all child tree blocks starting from a specified block.=

>>
>> -b can only print a single block, while without -b "btrfs inspect dump=
-tree"
>> will need extra tree roots fulfilled to continue, which is not possibl=
e
>> for some damaged filesystem.
>>
>> Add a new option '-f|--follow' to iterate a sub-tree starting from blo=
ck
>> specified by '-b|--block', so we would have less limitation.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> I've dropped the shot option for now and updated the changelog. While
> '-f' is probably a good choice, I'd postpone adding that if we want to
> use it for other purposes.

I'm fine with this.

Just curious if this means we should also double check the short option
usage or this is just for "-f"?

Thanks,
Qu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Z53GoSRN15hKmnSz7mHqvqSHj8AEPxLxT--

--Loc8DHjbAIeS9X5qMWTmL5HO6GVYj7i4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqwmdkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj87AgArM7U8PO8wZ8Cqx+Rx7Pvfkgh
QzoZXk2Y1xC58LXQb28+7lgE159bsqOOcH5mJfCAY4h/EOHdVZ5LusUk62RT3SDs
mu4SEvw44xs9TJn/SSJ8Ch89Q+4gYsZ4dT/Vz1088/ISAwNnaJc/2stdcbifsZAR
HPzNe/pbwSMXTDSNRmFV8+Xg0aUlmHQtXfbCEmySq725yfe9hQ5gY06o6A/jpBRT
aV1mGGXQrHnf9Uk6rQbfImI8YJI7XdXZa0e6bZ86wvld+z7/QM663+GkqphcckPy
O67W2MixfByWUZ4b7DzbQ7eXSVFnf48g+eG58PssZ9gEbHR14koZsbAfkk12ug==
=EVEx
-----END PGP SIGNATURE-----

--Loc8DHjbAIeS9X5qMWTmL5HO6GVYj7i4J--
