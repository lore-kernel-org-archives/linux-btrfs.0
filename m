Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752210AbcLTSKZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 13:10:25 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A74EAAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 18:10:23 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix error handling when run_delayed_extent_op
 fails
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbbf1064-dc95-b1e2-94d9-b3b2879913d8@suse.com>
 <20161220180045.GR3620@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5e8524e0-8c29-ad01-2b44-c68b42755fc4@suse.com>
Date: Tue, 20 Dec 2016 13:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <20161220180045.GR3620@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dDqed3s3rh4xHA4Psp57mJLfW3a9dBgAb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dDqed3s3rh4xHA4Psp57mJLfW3a9dBgAb
Content-Type: multipart/mixed; boundary="9BfPpRaNObBP6j3lqHRpn58W7XebQU82P";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5e8524e0-8c29-ad01-2b44-c68b42755fc4@suse.com>
Subject: Re: [PATCH] btrfs: fix error handling when run_delayed_extent_op
 fails
References: <cbbf1064-dc95-b1e2-94d9-b3b2879913d8@suse.com>
 <20161220180045.GR3620@twin.jikos.cz>
In-Reply-To: <20161220180045.GR3620@twin.jikos.cz>

--9BfPpRaNObBP6j3lqHRpn58W7XebQU82P
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/20/16 1:00 PM, David Sterba wrote:
> On Tue, Dec 13, 2016 at 02:33:33PM -0500, Jeff Mahoney wrote:
>> In __btrfs_run_delayed_refs, the error path when run_delayed_extent_op=

>> fails sets locked_ref->processing =3D 0 but doesn't re-increment
>> delayed_refs->num_heads_ready.  As a result, we can end up triggering
>> the WARN_ON in btrfs_select_ref_head since the head remains in the tre=
e
>> with ->processing =3D 0 and the ready count is off.
>>
>> Fixes: d7df2c796d7 (Btrfs: attach delayed ref updates to delayed ref h=
eads)
>> Reported-by: Jon Nelson <jnelson-suse@jamponi.net>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4607af3..73a8d31 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2588,6 +2588,7 @@ static noinline int __btrfs_run_delayed_refs(str=
uct btrfs_trans_handle *trans,
>>  					if (must_insert_reserved)
>>  						locked_ref->must_insert_reserved =3D 1;
>>  					locked_ref->processing =3D 0;
>> +					delayed_refs->num_heads_ready++;
>=20
> I think this requires spin lock/unlock around the increment, as do othe=
r
> similar places that fixup num_heads_ready after previous error.
>=20

Thanks, I'll fix that.  It looks like the locking for the next block up
is also broken -- we unlock the locked_ref and then set ->processing =3D
0.  I'll send a patch for that as well.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--9BfPpRaNObBP6j3lqHRpn58W7XebQU82P--

--dDqed3s3rh4xHA4Psp57mJLfW3a9dBgAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYWXQNAAoJEB57S2MheeWyizgQALCTcGOJdMHC6zi5GgxZNj7c
mc5AdaAlwKUdCP7LiPg3/FoIL3WgagwObHrFj4zOGnpRlcYvOVKCEMONKHk5/hd+
a56KWZUZHIZJHI2Rd1RZTqVmtZchDtwM6T0DZUrLO399vPTkbrq4jZSWUp9gO6CF
HtPvg54cJ2gDHQvYQDYhmO/UWjfKEYHdk5SwWuY0uv26ckOx5kqz7PZrn/5O7Lq+
faUSMRjTkRNmQBK+hQ5Rh03t6om/sCODHGiLyCwPW/ZWZQL81RrN0ZwjkIT8ykbE
wPAfB1CpNqkyM8mz50Crs7o5guhWiHA4XLi68H2CbM9p4Gp6Rg//zuTvhr3i8kRQ
j4HCe3je8sTV2Y/APY4QLr7hFYoRB+l7MsWR8GeHZbzPyyha55BPU5+ugyWP1EmQ
H7Cv/qNs65O7u5++wHgX96P4hnbQmASn1gk8Tr3k8P6GPGjzR6eknQDMqPXb5ci9
XRD5wSe/uTmp7HOjGkucazwMAnS9sSB/jFcWRpkklrkSu6BpDwDgvigYGK5WmjqX
9bB2gFKlDobCzq9wIyE/uRzpfbSUXSh17COQ83X2OAiAjX5amotcVqMeklcME2ht
QyyjICuQ0nPw/vXOr03vGJ05FSBhRL9j42d5s2vsIQfbqEDVOTwB6VnL2WHk/8KB
cvS0qRx3zPkq3Kytsgpp
=w/yy
-----END PGP SIGNATURE-----

--dDqed3s3rh4xHA4Psp57mJLfW3a9dBgAb--
