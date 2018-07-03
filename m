Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:35325 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932079AbeGCWgp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 18:36:45 -0400
Subject: Re: A list of bugs in btrfs found by fuzzing
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
 <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
 <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
 <802fb262-8204-1639-9a8d-0829881a2270@gmx.com>
 <D1C443C6-9EBD-4F4D-B60E-5CC7D22BC3C0@gatech.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6408ed6e-12c0-c34c-a940-c559e238a212@gmx.com>
Date: Wed, 4 Jul 2018 06:36:34 +0800
MIME-Version: 1.0
In-Reply-To: <D1C443C6-9EBD-4F4D-B60E-5CC7D22BC3C0@gatech.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oPiDyDcKNh9E8btQRbKTxHIcjNK8GGWSc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oPiDyDcKNh9E8btQRbKTxHIcjNK8GGWSc
Content-Type: multipart/mixed; boundary="wFZ0LiTag4Mw00KSw0RGOLlbVMdvTwslC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <6408ed6e-12c0-c34c-a940-c559e238a212@gmx.com>
Subject: Re: A list of bugs in btrfs found by fuzzing
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
 <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
 <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
 <802fb262-8204-1639-9a8d-0829881a2270@gmx.com>
 <D1C443C6-9EBD-4F4D-B60E-5CC7D22BC3C0@gatech.edu>
In-Reply-To: <D1C443C6-9EBD-4F4D-B60E-5CC7D22BC3C0@gatech.edu>

--wFZ0LiTag4Mw00KSw0RGOLlbVMdvTwslC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8804=E6=97=A5 00:27, Xu, Wen wrote:
> So this is the dev branch of btrfs?=E2=80=A6

Just my branch of all the related fixes.

Thanks,
Qu

>=20
> Thanks,
> -Wen
>=20
>> On Jul 3, 2018, at 9:36 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8803=E6=97=A5 20:37, Xu, Wen wrote:
>>> Sure, thanks for your efforts! So as I suppose, 199833 and 199835 are=
 implicitly fixed by these patches as well?
>>>
>>> -Wen
>>
>> Yep.
>>
>> Kernel can know detect all related chunk <-> block group mapping probl=
em
>> in all 6 images and exit gracefully with error message showing what's
>> going wrong.
>>
>> You could also test using this branch:
>> https://github.com/adam900710/linux/tree/tree_checker_enhance
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>> On Jul 3, 2018, at 4:32 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>>>
>>>>
>>>>
>>>> On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 08:06, Xu, Wen wrote:
>>>>> Dear BTRFS developers,
>>>>>
>>>>> I would like to know if these issues are fixed or handled? Thanks.
>>>>>
>>>>> -Wen
>>>>
>>>> All these images should be addressed by the following patches now:
>>>> https://patchwork.kernel.org/patch/10503415/
>>>> https://patchwork.kernel.org/patch/10503413/
>>>> https://patchwork.kernel.org/patch/10503403/
>>>> https://patchwork.kernel.org/patch/10503147/
>>>> https://patchwork.kernel.org/patch/10503099/
>>>>
>>>> Some of them may need extra cosmetic updates, but the basic fix shou=
ld
>>>> not change much.
>>>>
>>>> If you have any newer fuzzed image which could pass kernel mount and=

>>>> cause unexpected behavior, feel free to submit them to btrfs maillis=
t
>>>> and kernel bugzilla.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>> On Jun 3, 2018, at 6:22 PM, Wen Xu <xuwen.sjtu@gmail.com> wrote:
>>>>>>
>>>>>> Hi btrfs maintainers and developers,
>>>>>>
>>>>>> Here are a list of bugs found in upstream kernel recently. Please =
check:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199833
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199835
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199837
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199839
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199849
>>>>>>
>>>>>> Thanks,
>>>>>> Wen
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BDn=
=EF=BF=BD=DF=B2)=EF=BF=BD=EF=BF=BD=EF=BF=BDw*=1Fjg=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=1E=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j/=EF=BF=BD=EF=BF=
=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD2=EF=BF=BD=DE=99=EF=BF=BD=EF=
=BF=BD=EF=BF=BD&=EF=BF=BD)=DF=A1=EF=BF=BDa=EF=BF=BD=EF=BF=BD=7F=EF=BF=BD=EF=
=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=0F=EF=BF=BDj:+v=EF=
=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BD=D9=A5
>=20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=
=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=
=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BDn=EF=
=BF=BD=DF=B2)=EF=BF=BD=EF=BF=BD=EF=BF=BDw*=1Fjg=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=1E=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j/=EF=BF=BD=EF=BF=BD=
=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD2=EF=BF=BD=DE=99=EF=BF=BD=EF=BF=
=BD=EF=BF=BD&=EF=BF=BD)=DF=A1=EF=BF=BDa=EF=BF=BD=EF=BF=BD=7F=EF=BF=BD=EF=BF=
=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=0F=EF=BF=BDj:+v=EF=BF=
=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BD=D9=A5
>=20


--wFZ0LiTag4Mw00KSw0RGOLlbVMdvTwslC--

--oPiDyDcKNh9E8btQRbKTxHIcjNK8GGWSc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls7+nIACgkQwj2R86El
/qibYgf9FAIsBuFmd6650G6g0ec6sJ2Wa3N9Avo0+7+pW4CdK2yc3/QI6XEUMP+p
lIbrhjNXJ/Pz/EaBTo5cmLLlgkvsi4jDQho4SeLQCU4wBeYD5Cdk62jpk8pFpkf4
XF9kVfevEGVxzjp+l/KiskeLE2htrLsERRl9sT6JprIY2287bxorssyd2v0ewm1C
1g30+AV623KvzNCguoww4Ge+5xw0AUVcIXFyj9rPYJyNCyLZJX1Jc4GZ/qcIbTQx
0iOAoiOiMPR2Puw9n4AUY0yFYuGDdyVFe+Gd9Gc7s8Q7Fc8+QYgEQBsyJe42w1d5
eWVy1Zo3OfwVAjelSnfeakG9BZCbvQ==
=ho+w
-----END PGP SIGNATURE-----

--oPiDyDcKNh9E8btQRbKTxHIcjNK8GGWSc--
