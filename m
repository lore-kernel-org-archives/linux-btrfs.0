Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932134AbeCABkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 20:40:32 -0500
Subject: Re: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
To: fdmanana@gmail.com, dsterba@suse.cz, peteryuchuang@gmail.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1519836220.1693.23.camel@gmail.com>
 <20180228175013.GG27791@twin.jikos.cz>
 <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6b63cb26-ffdb-fb60-da8b-acd8a00c3ca2@gmx.com>
Date: Thu, 1 Mar 2018 09:40:20 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3lZCmkruSr72PpxipgJOsEiqQ7CBleOEI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3lZCmkruSr72PpxipgJOsEiqQ7CBleOEI
Content-Type: multipart/mixed; boundary="J8a4aVfOHTUjTIZpQtT6uOr7bL2vuTiQq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, dsterba@suse.cz, peteryuchuang@gmail.com,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6b63cb26-ffdb-fb60-da8b-acd8a00c3ca2@gmx.com>
Subject: Re: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
References: <1519836220.1693.23.camel@gmail.com>
 <20180228175013.GG27791@twin.jikos.cz>
 <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
In-Reply-To: <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>

--J8a4aVfOHTUjTIZpQtT6uOr7bL2vuTiQq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 02:36, Filipe Manana wrote:
> On Wed, Feb 28, 2018 at 5:50 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Wed, Feb 28, 2018 at 05:43:40PM +0100, peteryuchuang@gmail.com wrot=
e:
>>> On my laptop, which has just been switched to BTRFS, the root partiti=
on
>>> (a BTRFS partition inside an encrypted LVM. The drive is an NVMe) is
>>> re-mounted as read-only few minutes after boot.
>>>
>>> Trace:
>>
>> By any chance, are there other messages from btrfs above the line?
>>>
>>> [  199.974591] ------------[ cut here ]------------
>>> [  199.974593] BTRFS: Transaction aborted (error -95)
>>
>> -95 is EOPNOTSUPP, ie operation not supported
>>
>>> [  199.974647] WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042 btrf=
s_finish_ordered_io+0x7ab/0x850 [btrfs]
>>
>> btrfs_finish_ordered_io::
>>
>>  3038         btrfs_ordered_update_i_size(inode, 0, ordered_extent);
>>  3039         ret =3D btrfs_update_inode_fallback(trans, root, inode);=

>>  3040         if (ret) {
>>  3041                 btrfs_abort_transaction(trans, ret);
>>  3042                 goto out;
>>  3043         }
>=20
> I don't know what's exactly in Arch's kernel, but looking at the
> 4.15.5 stable tag from kernel.org:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git=
/tree/fs/btrfs/inode.c?h=3Dv4.15.5#n3042
>=20
> The -EOPNOTSUPP error can come from btrfs_drop_extents() through the
> call to insert_reserved_file_extent().

__btrfs_drop_extents() will return -EOPNOTSUPP if we're dropping part of
an inline extent.

Could be something wrong with convert inline extent generator.


> We've had several reports of this kind of error in this location in
> the past and they happened to be on filesystems converted from extN to
> btrfs.
> I don't know however if this filesystem was from such a conversion nor
> if those old bugs in the conversion tool were fixed.

And since the user is using Arch and kernel is latest, it normally means
the btrfs-progs is also latest.

I need to double check about the convert inline extent code to ensure we
don't create too large inline extent.

Thanks,
Qu

>=20
>=20
>>
>> the return code is unexpected here. And seeing 'operation not supporte=
d'
>> after a inode size change looks strange but EOPNOTSUPP could be return=
ed
>> from some places.
>>
>> The transaction is aborted from a thread that finalizes some processin=
g
>> so we don't have enough information here to see how it started. I
>> suspect there's a file that gets modified short after boot and hits th=
e
>> problem. I don't think the EOPNOTSUPP is returned from the lower layer=
s
>> (lvm encryption or nvme), so at this point seems like a btrfs bug.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--J8a4aVfOHTUjTIZpQtT6uOr7bL2vuTiQq--

--3lZCmkruSr72PpxipgJOsEiqQ7CBleOEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqXWgQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg9VAf7BYdEh3PK0lB6Vnmmfsxhb5jk
I5EX51vdjMVAaNmYR2XBGH5vmqDa3cS2cSIELE5oosXmxe7gwA6F7XLtqNrQflfW
7zyyS6gop6+qCoHJSBo+dX1EYlQ2w2UDk+bHCED4GCQG9QlTZNL3MyJEt/VzQeXB
LEaXLel0BXwndPFyWJV00EMJdCn6bZc4kc8gDP6ngMqu7nAoE1PI6dZUeGLPEZVz
Il5xe0n7kuc+WhmWLu07pRrsZYoGhpAUkGqolOXSOgHkRMKoTEEwPmMzIGRG/o8i
KRwxLzXw+KTcij6rCk/r501oYoIQawFL/OBNg6GWVKWi85QHOGVlnQ+ld2J/Mw==
=NJ2e
-----END PGP SIGNATURE-----

--3lZCmkruSr72PpxipgJOsEiqQ7CBleOEI--
