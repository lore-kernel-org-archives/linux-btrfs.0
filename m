Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55511 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752700AbeGCNgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 09:36:35 -0400
Subject: Re: A list of bugs in btrfs found by fuzzing
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
 <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
 <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <802fb262-8204-1639-9a8d-0829881a2270@gmx.com>
Date: Tue, 3 Jul 2018 21:36:25 +0800
MIME-Version: 1.0
In-Reply-To: <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MYtHmCYagkaY6Mt7caKrfZZqry8DoFG2i"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MYtHmCYagkaY6Mt7caKrfZZqry8DoFG2i
Content-Type: multipart/mixed; boundary="JxN4ZeJGlmJCa5dQhlwLyTMqPrIQPxb0R";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <802fb262-8204-1639-9a8d-0829881a2270@gmx.com>
Subject: Re: A list of bugs in btrfs found by fuzzing
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
 <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
 <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
In-Reply-To: <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>

--JxN4ZeJGlmJCa5dQhlwLyTMqPrIQPxb0R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8803=E6=97=A5 20:37, Xu, Wen wrote:
> Sure, thanks for your efforts! So as I suppose, 199833 and 199835 are i=
mplicitly fixed by these patches as well?
>=20
> -Wen

Yep.

Kernel can know detect all related chunk <-> block group mapping problem
in all 6 images and exit gracefully with error message showing what's
going wrong.

You could also test using this branch:
https://github.com/adam900710/linux/tree/tree_checker_enhance

Thanks,
Qu


>=20
>> On Jul 3, 2018, at 4:32 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 08:06, Xu, Wen wrote:
>>> Dear BTRFS developers,
>>>
>>> I would like to know if these issues are fixed or handled? Thanks.
>>>
>>> -Wen
>>
>> All these images should be addressed by the following patches now:
>> https://patchwork.kernel.org/patch/10503415/
>> https://patchwork.kernel.org/patch/10503413/
>> https://patchwork.kernel.org/patch/10503403/
>> https://patchwork.kernel.org/patch/10503147/
>> https://patchwork.kernel.org/patch/10503099/
>>
>> Some of them may need extra cosmetic updates, but the basic fix should=

>> not change much.
>>
>> If you have any newer fuzzed image which could pass kernel mount and
>> cause unexpected behavior, feel free to submit them to btrfs maillist
>> and kernel bugzilla.
>>
>> Thanks,
>> Qu
>>
>>>
>>>> On Jun 3, 2018, at 6:22 PM, Wen Xu <xuwen.sjtu@gmail.com> wrote:
>>>>
>>>> Hi btrfs maintainers and developers,
>>>>
>>>> Here are a list of bugs found in upstream kernel recently. Please ch=
eck:
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199833
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199835
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199837
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199839
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199849
>>>>
>>>> Thanks,
>>>> Wen
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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


--JxN4ZeJGlmJCa5dQhlwLyTMqPrIQPxb0R--

--MYtHmCYagkaY6Mt7caKrfZZqry8DoFG2i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls7e9oACgkQwj2R86El
/qgQwAf+PTI1LiMLXTg9qoCSjgSk0f3wzY59Id6vcU2z/DN6sGBhO+xOJZ/hbCK7
xiNF97ZdztM95D0+A6PmiYJlMLZu0jDHK5gDKpNTuD1Q9U78UYG0Xrh+FAUONdbg
LhV9SndQ73F2uYgdxbeNWdZId8CAJYHLtkjhEiaWKdxP9KN4gEOpiw6VedbWWybz
vL6INvJiF6bwtFwqr+uAQw5NNygXVWv5TwmWHUjlm30GeDzFp77EhxOcPe2hnPYD
aZR4BD6c0JKld77RKp4tA7ZsFj+w05xYr3FN79yaAgldkvRS8buRT8ZC3dLP7v0/
ucJF8M2OYu+GZa7c2IcztpRDuDjTfg==
=riIJ
-----END PGP SIGNATURE-----

--MYtHmCYagkaY6Mt7caKrfZZqry8DoFG2i--
