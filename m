Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63892 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751727AbeADBjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Jan 2018 20:39:31 -0500
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171031060816.683-1-wqu@suse.com>
 <20180103143708.GC3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <88f114b2-5b45-7228-a612-51042a3ca2a8@gmx.com>
Date: Thu, 4 Jan 2018 09:38:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180103143708.GC3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NJ61lepd4tGOEZdrjRsSaQF6kCV6HQcOc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NJ61lepd4tGOEZdrjRsSaQF6kCV6HQcOc
Content-Type: multipart/mixed; boundary="jqwmI9CLz9fc4bbUDauQnFwJ9jh7mx00r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <88f114b2-5b45-7228-a612-51042a3ca2a8@gmx.com>
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
References: <20171031060816.683-1-wqu@suse.com>
 <20180103143708.GC3553@twin.jikos.cz>
In-Reply-To: <20180103143708.GC3553@twin.jikos.cz>

--jqwmI9CLz9fc4bbUDauQnFwJ9jh7mx00r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8803=E6=97=A5 22:37, David Sterba wrote:
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
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index dfdab849037b..d85e04a675fe 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1403,7 +1403,7 @@ struct btrfs_root *btrfs_create_tree(struct btrf=
s_trans_handle *trans,
>>  	struct btrfs_root *root;
>>  	struct btrfs_key key;
>>  	int ret =3D 0;
>> -	uuid_le uuid;
>> +	uuid_le uuid =3D { 0 };
>=20
> I get a warning with gcc 4.8.5
>=20
> fs/btrfs/disk-io.c:1236:2: warning: missing braces around initializer [=
-Wmissing-braces]
>=20
> but no warning with gcc 7.2.1 (built as 'make ccflags-y=3D-Wmissing-bra=
ces
> and checking that the option is really there). I think we should use
> NULL_UUID_LE.

Do I need to resend the whole patch or a new delta patch?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--jqwmI9CLz9fc4bbUDauQnFwJ9jh7mx00r--

--NJ61lepd4tGOEZdrjRsSaQF6kCV6HQcOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpNhaYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh+Lgf9EbUDJZcM90oBIGIIWWuHvOe8
AAgktrYXZtSJgw20nLr71nRILh/TI0SLgNMXb0zc4zyO+0sd8NPOFu9K5ACkUCsM
9XV3m5ndf5+8E+KwBBIgvlYVUTXCc8umQwM3iy7qPX+aliPdNVUkGdIb4misBHWg
OIBhbnMF9vIEvqEShdFYwqfr4UqkHH//Gk6KW7Y79F7VYx4CP4DvEQZNznPU0WZy
IC5DlPlP4nR85fnHr5LMUrSwrLAebynryodC96v82uyksijxKj+jQCAzcmixraV7
H3oABPdsp/l6WKOIaYvk6N9LUybdEGPwCIMvc/4P1bCQF8sipzb7vKesPDfpLw==
=vBd/
-----END PGP SIGNATURE-----

--NJ61lepd4tGOEZdrjRsSaQF6kCV6HQcOc--
