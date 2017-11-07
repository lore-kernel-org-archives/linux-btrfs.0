Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755543AbdKGAny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 19:43:54 -0500
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171031060816.683-1-wqu@suse.com>
 <20171106152823.GJ28789@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e396a78d-9d0d-b895-1801-8b5739e79559@gmx.com>
Date: Tue, 7 Nov 2017 08:43:40 +0800
MIME-Version: 1.0
In-Reply-To: <20171106152823.GJ28789@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CsNUX3NS6SrX5Ra2jtnpM4gBl1326Q6dN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CsNUX3NS6SrX5Ra2jtnpM4gBl1326Q6dN
Content-Type: multipart/mixed; boundary="jkINo4RCGPPos3ehNK4PfjRUFrQqqjAo8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e396a78d-9d0d-b895-1801-8b5739e79559@gmx.com>
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
References: <20171031060816.683-1-wqu@suse.com>
 <20171106152823.GJ28789@twin.jikos.cz>
In-Reply-To: <20171106152823.GJ28789@twin.jikos.cz>

--jkINo4RCGPPos3ehNK4PfjRUFrQqqjAo8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8806=E6=97=A5 23:28, David Sterba wrote:
> On Tue, Oct 31, 2017 at 02:08:16PM +0800, Qu Wenruo wrote:
>> btrfs_create_tree() will unconditionally generate UUID for any root.
>> So for quota tree and data reloc tree created by kernel, they will hav=
e
>> unique UUIDs.
>>
>> However UUID in root item is only referred by UUID tree, which only
>> records UUID for fs trees.
>> This makes unique UUIDs for quota/data reloc tree meaningless.
>>
>> Leave the UUID as zero for non-fs tree, making btrfs-debug-tree output=

>> less confusing.
>>
>> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>=20
> Can you please point me to the report?

Here it is:

https://marc.info/?l=3Dlinux-btrfs&m=3D150941856508074&w=3D2

Thanks,
Qu
>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--jkINo4RCGPPos3ehNK4PfjRUFrQqqjAo8--

--CsNUX3NS6SrX5Ra2jtnpM4gBl1326Q6dN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloBAbwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjKbQf9HmLnfay8vRUhgr+1A4P9Ez+g
XTn6hq6ASkLuMZeUyJwX/IXxwQZ+nRvk03N8+jfQDxV9CMkka1NfH7HCYuvIN6wa
gAMb5k2tvRHSmzvJPi3Ed0T2y6gfDaBl139C75tqlSays86tvwn5/oMuJVNaD3l/
1JVmQMGgWULsbYOI+H5FAkgFS9F749DUR7WtsPuRwlzkh3K5lEKwvq3oqnV7uYNL
c3Yx5AUGUEreAOFqWvAMko0CzDLiNMW7ibZGzPdICLOuw1ffK5Mz+xZqPWlkZGPE
Hbv2ZbIyt5H0Ecuis+dkgDRb52kdipkgCLbNU6Fs5WfMaPszwYiZBKHzTsDE6A==
=Jy59
-----END PGP SIGNATURE-----

--CsNUX3NS6SrX5Ra2jtnpM4gBl1326Q6dN--
