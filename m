Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbeFVH7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 03:59:07 -0400
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
To: cgxu519 <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20180622025816.29239-1-cgxu519@gmx.com>
 <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
 <869f200a-e214-2b2f-66a6-3fb58df3423d@gmx.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <38de74b6-e7df-f723-0e08-64cfba67d451@gmx.com>
Date: Fri, 22 Jun 2018 15:58:38 +0800
MIME-Version: 1.0
In-Reply-To: <869f200a-e214-2b2f-66a6-3fb58df3423d@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bNbQGzm4kjlfpsibIW1HAKOVnKVMOv9bl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bNbQGzm4kjlfpsibIW1HAKOVnKVMOv9bl
Content-Type: multipart/mixed; boundary="9LnlOChFF7t7nt6hwyqIsAVQWJrmX2jP5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: cgxu519 <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <38de74b6-e7df-f723-0e08-64cfba67d451@gmx.com>
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
References: <20180622025816.29239-1-cgxu519@gmx.com>
 <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
 <869f200a-e214-2b2f-66a6-3fb58df3423d@gmx.com>
In-Reply-To: <869f200a-e214-2b2f-66a6-3fb58df3423d@gmx.com>

--9LnlOChFF7t7nt6hwyqIsAVQWJrmX2jP5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8822=E6=97=A5 15:42, cgxu519 wrote:
> On 06/22/2018 01:59 PM, Qu Wenruo wrote:
>>
>> On 2018=E5=B9=B406=E6=9C=8822=E6=97=A5 10:58, Chengguang Xu wrote:
>>> Currently, when encoutering -ERANGE in btrfs_get_acl(),
>>> just set acl to NULL so that we cannot get proper
>>> acl information but the operation looks successful.
>>>
>>> This patch treats -ERANGE as an error case and meanwhile
>>> print real errno before translating errno to -EIO.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>>> ---
>>> =C2=A0 fs/btrfs/acl.c | 3 ++-
>>> =C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>>> index 15e1dfef56a5..7b3a83dd917c 100644
>>> --- a/fs/btrfs/acl.c
>>> +++ b/fs/btrfs/acl.c
>>> @@ -42,9 +42,10 @@ struct posix_acl *btrfs_get_acl(struct inode
>>> *inode, int type)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (size > 0) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 acl =3D posix_=
acl_from_xattr(&init_user_ns, value, size);
>>> -=C2=A0=C2=A0=C2=A0 } else if (size =3D=3D -ERANGE || size =3D=3D -EN=
ODATA || size =3D=3D 0) {
>>> +=C2=A0=C2=A0=C2=A0 } else if (size =3D=3D -ENODATA || size =3D=3D 0)=
 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 acl =3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err_ratelimited("BTRFS=
: get acl failed, err=3D%d\n", size);
>> Is there any special reason to output this message even it's rate
>> limited?
>> This looks much like a debug output, no to mention we have
>> btrfs_err/warn/info() wrapper to output with proper fs UUID.
> Yeah, it will be better replacing pr_err with btrfs_err. The motivation=
 to
> print error message here is for helping debug when failing into error c=
ase.
> As you know, most error code here will be override to -EIO, so I hope
> to record a hint to indicate what has happened.

If it's something went wrong searching the tree, the return value will
be -EIO and more useful error message would be output, like tree block
csum error.

If other case, like ENOMEM, returning the original errno will be much
better, and more obvious for end-user.

Or did you hit some special case where needs the extra handling?
If so, maybe btrfs_debug_rl() would be a better fit here.

>=20
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 acl =3D ERR_PT=
R(-EIO);
>> in fact we should let @acl to contain the correct error code from
>> btrfs_getxattr(), other than overriding it with -EIO.
> I'm also not so sure about the reason for overriding the errno with -EI=
O,
> maybe it's easy to understand for end-user?

Just some bad old practice.
Feel free to correct it.

Thanks,
Qu

>=20
> Thanks,
> Chengguang.
>=20
>=20


--9LnlOChFF7t7nt6hwyqIsAVQWJrmX2jP5--

--bNbQGzm4kjlfpsibIW1HAKOVnKVMOv9bl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlssrC4ACgkQwj2R86El
/qishwgAgQTpl/Hwga8elGyo20JkOCSZBhIS9oJBCv/XXyvd+hyRVIgweeP3/Xuv
43gCjm/ns1z1DhRm2aP/zvFPxNQTZzr1ax/nJSoN+AEM5e3VdVhaN7sYypmo/v4l
SZDYThLD3AhIBacMAvoNRq2kPj2c8hHO5vNacmFMPTFJ/kwAkDnvOUX5sRbXfEvh
aSb40Xn3FqvWo5VABo3RbnUDCHO2sOr2ov6O/4rSQqiawhi9Owj2V9XmcpP0meP2
eh94w2vMAKrW998D1dLADUnsCsfB+oaKC6SH7PPWM8ECFPKcKcghZKdLK/rGfU+U
ZU4XoZpzvwrZZbYwQ1I+QuMevtzsEQ==
=W15c
-----END PGP SIGNATURE-----

--bNbQGzm4kjlfpsibIW1HAKOVnKVMOv9bl--
