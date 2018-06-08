Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:34359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752607AbeFHDkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 23:40:04 -0400
Subject: Re: Bad superblock when mounting rw, ro mount works
To: Daniel Underwood <daniel.underwood13@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8b545b93-0494-df60-0641-e13bbf94a63a@gmx.com>
Date: Fri, 8 Jun 2018 11:39:57 +0800
MIME-Version: 1.0
In-Reply-To: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CZ4lMGDDv1QNAYn1mBAJS97ieczaaSSmS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CZ4lMGDDv1QNAYn1mBAJS97ieczaaSSmS
Content-Type: multipart/mixed; boundary="NbtQ2RWXMnlzgF28Q6CysflpKc8qNxBhg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Underwood <daniel.underwood13@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <8b545b93-0494-df60-0641-e13bbf94a63a@gmx.com>
Subject: Re: Bad superblock when mounting rw, ro mount works
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
In-Reply-To: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>

--NbtQ2RWXMnlzgF28Q6CysflpKc8qNxBhg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8808=E6=97=A5 01:07, Daniel Underwood wrote:
> Hi,
>=20
> I have a raid10-like setup that is failing to mount in rw mode with the=
 error
>=20
>=20
> mount: /mnt/media: wrong fs type, bad option, bad superblock on
> /dev/mapper/em1, missing codepage or helper program, or other error
>=20
> read-only mounts seem to work and the files seem to be there.
>=20
> I started having issues after a system crash during the process of
> deleting a number of large files. After this (Ubuntu 16.04/Kernel
> 4.4), any attempt to mount the array in rw mode would cause a similar
> crash. I did an upgrade to Ubuntu 18.04/Kernel 4.15 and now get the
> error above.
>=20
> I have looked through a variety of posts on the mailing list, but
> couldn't find anything with the same issue. I have done a scrub on the
> array that resulted in 6 verify errors with dmesg showing something
> about extent trees. It didn't list them as uncorrectable errors, but
> couldn't correct them either as I can't mount in rw. I also tried
> `btrfs rescue zero-log /dev/mapper/em1`, which changes the above to
> (say) em5, but then zero-log on em5 causes it to go back to em1.

The problem is, your extent tree is corrupted.

And normally, it indicates your whole filesystem has more or less extra
errors.

In this case, btrfs check could help you to know how badly your fs is
corrupted.
(don't run --repair).

Optionally, btrfs check --mode=3Dlowmem is pretty a good try, as it would=

provide better error message.
(And help us enhance btrfs-progs)

>=20
> Any direction would be appreciated. From what I could tell, my next
> steps would be a check with --repair or --init-extent-tree, though I'm
> reluctant to try those without being explicitly told to do so.

Never run this two, unless you're 100% sure about:
1) What's the problem
2) What --repair can fix

Personally speaking, and also stated in man page, unless you're a
btrfs-progs developer or has enough experience, don't do any write
operation with btrfs check.

Thanks,
Qu

>=20
> I have attached a dmesg.log file and hope I haven't greped out
> anything important.
>=20
> Thanks,
> Daniel
>=20


--NbtQ2RWXMnlzgF28Q6CysflpKc8qNxBhg--

--CZ4lMGDDv1QNAYn1mBAJS97ieczaaSSmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsZ+o4ACgkQwj2R86El
/qiJmQf/bRI222VDq9ROTYvsCpqZK6nKjcwbZwUsfLsbDl4nqPtJp/dZw77UAfL0
/l643K+B7dVMfIaX97UyDkXgTj0/rxVJQzaoGL196K8DPQYhbg8+gK3CF5n4p4Dh
fcSy/RE3qcEoXoTozGpowG5YkAJkPMAd0uB6YpSdZiqoOAWv1LEHvqMM0yaite+p
EDtk7v50SDQLzUYAI5lc8jU8AZH6OeGek4/jTaJPZmHQwDV8mHZsm1B406rY07w4
47Bz7dEqTcmLwpwgJFiS/P6MfeckEFwYn/6wGD9yY6hjrLXR6XhxQmdsmIUDb+ns
eJf69hP5TVBle0GTyhdlH+PPjXeCJQ==
=zEyE
-----END PGP SIGNATURE-----

--CZ4lMGDDv1QNAYn1mBAJS97ieczaaSSmS--
