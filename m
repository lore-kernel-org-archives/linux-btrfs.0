Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:41491 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeDUCoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 22:44:16 -0400
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
 <20180420151504.GR21272@twin.jikos.cz>
 <a5e4bc54-460e-7db7-ebaa-98e1d9aaee5e@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <999a862f-a50b-9d21-94de-53463b6f3387@gmx.com>
Date: Sat, 21 Apr 2018 10:43:59 +0800
MIME-Version: 1.0
In-Reply-To: <a5e4bc54-460e-7db7-ebaa-98e1d9aaee5e@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CPnbGJ0afHsk42s1RO4mNlKZEQVKb54NE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CPnbGJ0afHsk42s1RO4mNlKZEQVKb54NE
Content-Type: multipart/mixed; boundary="H119o3bOow7OlBkYTbRr43PTf5pfgz1DR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <999a862f-a50b-9d21-94de-53463b6f3387@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
References: <20180419093816.888-1-wqu@suse.com>
 <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
 <20180420151504.GR21272@twin.jikos.cz>
 <a5e4bc54-460e-7db7-ebaa-98e1d9aaee5e@oracle.com>
In-Reply-To: <a5e4bc54-460e-7db7-ebaa-98e1d9aaee5e@oracle.com>

--H119o3bOow7OlBkYTbRr43PTf5pfgz1DR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8821=E6=97=A5 10:38, Anand Jain wrote:
>=20
>=20
> On 04/20/2018 11:15 PM, David Sterba wrote:
>> On Fri, Apr 20, 2018 at 10:32:03PM +0800, Anand Jain wrote:
>>>
>>>
>>> On 04/19/2018 05:38 PM, Qu Wenruo wrote:
>>>> Although we have already checked incompat flags manually before real=
ly
>>>> mounting it, we could still enhance btrfs_check_super_valid() to che=
ck
>>>> incompat flags for later write time super block validation check.
>>>>
>>>> This patch adds such incompat flags check for
>>>> btrfs_check_super_valid(),
>>>> currently it won't be triggered, but provides the basis for later wr=
ite
>>>> time check.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> =C2=A0=C2=A0 fs/btrfs/disk-io.c | 13 +++++++++++++
>>>> =C2=A0=C2=A0 1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 60caa68c3618..ec123158f051 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct
>>>> btrfs_fs_info *fs_info)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -EINVAL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Before calling btrfs_check_super_valid()=
 we have already
>>>> checked
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * incompat flags. So if we developr new in=
compat flags, it's
>>>> must be
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * some corruption.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_incompat_flags(sb) &
>>>> ~BTRFS_FEATURE_INCOMPAT_SUPP) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "corrupted incompat flag=
s detected 0x%llx, supported 0x%llx",
>>
>>> 2707=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 features =3D btr=
fs_super_incompat_flags(disk_super) &
>>> 2708=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ~BTRFS_FEATURE_INCOMPAT_SUPP;
>>> 2709=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (features) {
>>> 2710=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>> 2711=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "cannot mount beca=
use of unsupported
>>> optional features (%llx)",
>>> 2712=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 features);
>>> 2713=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -EINVAL;
>>> 2714=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail_alloc;
>>> 2715=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> So there's a "user experience" change, now that you pointed out the
>> other check.=20
>=20
> =C2=A0Its a regression.
>=20
>> If a filesystem with incompat bits set will be mounted,
>> this will say 'you have corrupted filesystem', which is not IMO what w=
e
>> want to tell.
>>
>> Tough the extended btrfs_check_super_valid could catch the corrupted
>> incompat bits, what we need at mount time is wording from the 2nd
>> message ("cannot mount unsuppported features").
>>
>> I think that there should be a separate function that does the
>> pre-commit checks, calls btrfs_check_super_valid and also validates th=
e
>> incompat bit.
>=20
> =C2=A0We can still print it as 'unsupported optional features', which w=
ould
> =C2=A0imply corruption in the non-mount context.

In that case such wording is not obvious enough to info it's super block
corruption.

So I still prefer current way of checking incompact flags and csum types
manually at mount time before btrfs_validate_super().

David's idea of a separate function to do mount time check and gives
better prompt is pretty good.
Especially for incompat features, as incompat features will increase in
the future and for older kernel info such feature as corruption is not
acceptable.

But currently, there are only 2 members we need to check at mount time
(csum_type and incompat features), and only one caller, current code
looks good enough for its purpose.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--H119o3bOow7OlBkYTbRr43PTf5pfgz1DR--

--CPnbGJ0afHsk42s1RO4mNlKZEQVKb54NE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrapW8ACgkQwj2R86El
/qhVKgf7B98xX7Jd8FmjxAEboFTcXRpnRmKKtdMX7c4S13TIGt4CYwDBYwi0M5Ve
AAdzWiGX3NnYUxpX52JMpxFJW5g82+TBncmkyhaf1oBlU83GLIB0SSi4W13fOUVy
P1dDryLydsOMYQifNWUVvJQPuILQsXpniCCGJysnGgzpn3DNDWknaMDxJiim1HUj
6ceVBZzVjKUnV2iKuVTYeJBEi6AVjSQzgrnTtRoYBk1rPTIkZb3dQYF9kx8Ms8Gz
ip8CwD0nuhbjwoKssbDF6rnUR2qY+AYhYU0Q0tBZHEADWG1PUNNWEbx3nxuqUDiy
uiTV6Wc81OliA+dY/ZDsTj+aqG//uQ==
=GEja
-----END PGP SIGNATURE-----

--CPnbGJ0afHsk42s1RO4mNlKZEQVKb54NE--
