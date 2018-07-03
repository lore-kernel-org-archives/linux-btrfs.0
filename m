Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:48317 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933660AbeGCIdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 04:33:12 -0400
Subject: Re: A list of bugs in btrfs found by fuzzing
To: "Xu, Wen" <wen.xu@gatech.edu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "clm@fb.com" <clm@fb.com>
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
Date: Tue, 3 Jul 2018 16:32:49 +0800
MIME-Version: 1.0
In-Reply-To: <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SipqkPutKGbuNKX7Oqza0Yk5nQwUgKArk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SipqkPutKGbuNKX7Oqza0Yk5nQwUgKArk
Content-Type: multipart/mixed; boundary="GFSbeRMHujGzmRB12XzQfbT6F8x17KxxG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Xu, Wen" <wen.xu@gatech.edu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "clm@fb.com" <clm@fb.com>
Message-ID: <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
Subject: Re: A list of bugs in btrfs found by fuzzing
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
In-Reply-To: <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>

--GFSbeRMHujGzmRB12XzQfbT6F8x17KxxG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 08:06, Xu, Wen wrote:
> Dear BTRFS developers,
>=20
> I would like to know if these issues are fixed or handled? Thanks.
>=20
> -Wen

All these images should be addressed by the following patches now:
https://patchwork.kernel.org/patch/10503415/
https://patchwork.kernel.org/patch/10503413/
https://patchwork.kernel.org/patch/10503403/
https://patchwork.kernel.org/patch/10503147/
https://patchwork.kernel.org/patch/10503099/

Some of them may need extra cosmetic updates, but the basic fix should
not change much.

If you have any newer fuzzed image which could pass kernel mount and
cause unexpected behavior, feel free to submit them to btrfs maillist
and kernel bugzilla.

Thanks,
Qu

>=20
>> On Jun 3, 2018, at 6:22 PM, Wen Xu <xuwen.sjtu@gmail.com> wrote:
>>
>> Hi btrfs maintainers and developers,
>>
>> Here are a list of bugs found in upstream kernel recently. Please chec=
k:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199833
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199835
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199837
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199839
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199847
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D199849
>>
>> Thanks,
>> Wen
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--GFSbeRMHujGzmRB12XzQfbT6F8x17KxxG--

--SipqkPutKGbuNKX7Oqza0Yk5nQwUgKArk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls7NLEACgkQwj2R86El
/qidtwf+NxhU7KiVmx2AA9e5qY5v4cdlessc4U/OoWc6KY2clFn9JBIrD9UF3egL
UXi8XuT2sWZgcMALtIVBoKI1INRAAxlekGypSwUwOHh5t+b4Hvq96MSaFxJ7TU7J
VmFKOk8heq66fc+9OxcBR64YxIBI+4k1NHevlkEY/YneNBpZ5121fIPxyVn3G3qL
uN64ItYd8rtidEyWCvkbKzfvw7fTJaCXTOLOs/VoNd+a6tlB6drNlh2SfB7h0nlb
P6e17GwYEVhBx7vhTDCd76g2eUUidI7IUkdgg0R0tvVv7RAK6jklUdjFt6dGiVnj
QYVEdlE9Hnxx/sH5hGgjv8Raz1QEIw==
=toXM
-----END PGP SIGNATURE-----

--SipqkPutKGbuNKX7Oqza0Yk5nQwUgKArk--
