Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751807AbdJ3AUF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 20:20:05 -0400
Message-ID: <1509322782.2721.74.camel@decadent.org.uk>
Subject: Re: [stable] btrfs name length fixes
From: Ben Hutchings <ben@decadent.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
Date: Mon, 30 Oct 2017 00:19:42 +0000
In-Reply-To: <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
References: <1509297309.2721.73.camel@decadent.org.uk>
         <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-MP+s9ghpCG7VdheKnmJT"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-MP+s9ghpCG7VdheKnmJT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-30 at 07:59 +0800, Qu Wenruo wrote:
>=20
> On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 01:15, Ben Hutchings wrote:
> > You recently made a number of fixes to validation and use of name
> > lengths in btrfs:
> >=20
> > 286b92f43c0d btrfs: tree-log.c: Wrong printk information about namelen
> > 19c6dcbfa746 btrfs: Introduce btrfs_is_name_len_valid to avoid reading =
beyond boundary
> > e79a33270d05 btrfs: Check name_len with boundary in verify dir_item
> > 26a836cec2ea btrfs: Check name_len on add_inode_ref call path
> > 8ee8c2d62d5f btrfs: Verify dir_item in replay_xattr_deletes
> > 3c1d41844896 btrfs: Check name_len in btrfs_check_ref_name_override
> > 59b0a7f2c7c1 btrfs: Check name_len before read in iterate_dir_item
> > 488d7c456653 btrfs: Check name_len before reading btrfs_get_name
> > 64c7b01446f4 btrfs: Check name_len before in btrfs_del_root_ref
> > fbc326159a01 btrfs: Verify dir_item in iterate_object_props
> >=20
> > The bugs these are fixing probably should also be fixed on the affected
> > stable branches.  Do you agree?  Can you provide any guidance about how
> > far back these fixes would be needed?
>=20
> These fixes will soon be replace by centralized tree-checker facilities.

Is that likely to be a small enough change to be reasonably backport-
able?

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.


--=-MP+s9ghpCG7VdheKnmJT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAln2cB4ACgkQ57/I7JWG
EQkwAg/+IXf/RheBapLchgGdszCtYKbHMImnhTLB4jHfFi8a2SYjgiK3xLjnmRgt
zK+uocP9C93iBu5XfymzVKyqqKbRQULRboJ0gRobhDP8XQzPixtFpvE3uZaEP6xi
dV7zjMgMGjQ7a8NoyUHPULabo7A2nDtHkR6AMdPug1o5FKxX5/KcWnlntr8vm/mT
zBZfthi5NrVobvY75czUlIW6mN/4UN27+AVkktXv9ro2e3X8yh539xIRR/Djvq/U
FFhLnxtcKDmL3uMPPTJPLibHnrUOKFEvazgQK7LB+jJ9u66qDJR1f+KTfndjnMm1
LC0gB6x6psg5sdmBFi2VkJu+TzqBv+mv0TUUZ+Gg5WqVD4C/JN4wKCtFbbuG1KHm
HJJzUG+08ldEeA4S4+zqHz3YxUYTMNEI6tqhtdnWOKKXBa3tycnuRfH7Y6bIm1qy
lN2Egoxvj9Gg6VxDekZq8bbd0EbivQ5ac5/5Bq9GWUjE0iT+e+vqs4guY9aLpXVJ
gK6sW9tdyQ7+YdQPathveLPmUYsh8PBaSqOUsnQhVcE0xRv7ld6R4UFVHYKHsA6V
ME21SA9eDeriwnKW1GNiq/F05kwnDPyYSJoa59BrbNwqAfaIz7nSkqIEPQS2t4qL
hUbMCuwU7m5dQCxgBp5ahXrDmPeNSJ9FrSrftuo5XZ2B7QSpXZ8=
=elp/
-----END PGP SIGNATURE-----

--=-MP+s9ghpCG7VdheKnmJT--
