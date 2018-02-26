Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtel-bg02.venev.name ([77.70.28.44]:40760 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbeBZMBP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 07:01:15 -0500
Message-ID: <1519646493.12248.7.camel@venev.name>
Subject: Re: btrfs_clone_files and bind mounts
From: Hristo Venev <hristo@venev.name>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Date: Mon, 26 Feb 2018 12:01:33 +0000
In-Reply-To: <2ce8eab1-8951-a1c7-d4fa-5f4f3201923d@suse.com>
References: <1519141810.8586.4.camel@venev.name>
         <2ce8eab1-8951-a1c7-d4fa-5f4f3201923d@suse.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Ds3MvA/U3oyw2M42ov21"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-Ds3MvA/U3oyw2M42ov21
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-02-20 at 18:41 +0200, Nikolay Borisov wrote:
>=20
> On 20.02.2018 17:50, Hristo Venev wrote:
> > What is the problem with cloning files between different
> > (vfs)mounts of
> > the same filesystem?
> >=20
>=20
> The "problem" is not really a problem, but rather a well-imposed
> restriction:
>=20
> From  http://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
>=20
> "Both files must reside within the same filesystem."
>=20
> And as a matter of fact this is enforced in the generic
> vfs_clone_file_range. Of course if we were to do this across
> filesystem
> then we'd have all the problems associated with not being able to
> ensure
> atomicity of operations.

My question was about doing this within the same filesystem. In my case
(and I think it's relatively common), subvolumes of the same filesystem
are mounted separately, and I can't think of a good reason why
FICLONERANGE can't be made to work (it works if the subvolumes are
accessed within the same mount point).
--=-Ds3MvA/U3oyw2M42ov21
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEoyGBLUWLy7TrlT7Wydifi1CrK4gFAlqT9x0ACgkQydifi1Cr
K4i4fQ//c1MRcVRGl79YS9xq/Wu9fKao7YTEfQfQDyeoM3L4viKAwVQlmSVvZXB9
BxQ5qvwcW914KGNFBDTI5awVS1YhPPPcNvj3VfvXSpKBNZ/EITnbxPaVGJlTnXYh
A48SO1/EpsyLfRPcOcvhOJdqi+tYSoZ+GqNE3wXGrk7jUJgZ5k+l3yq+NS2I7RR0
ykWtTZ6ypWV1JxTQ8tRjOoMiiuJEku+CvdNzzUelQrtDfPxAHp2GTkJnvBre9LGX
tLl5j46DIQt9iQoaCNugHiqaVhAR8tkLERgTslbXj5VUjw+0Z30zHdJqIjg0ztUQ
NxZ2R+V3iYP1HeAl49/s19fIMqRwI/1tH5kGSooo5E3szElq80PmT+5oAvr9GQaj
5Le/l5FDBqsPfBOVH/09Db3USbpxyZLiDRW3qvKILWt9IKGZUISqMNIE5IMntrVY
TEqJvDYCq0mh758dI0aul5ARjbuAwY2pcw0gn/3Qxya03S1l8j2YumDd0UMyURZ8
rZmZCd4j6xLnvzPvS+aSGEdQfosWqeU+o5E4k6ZK7WR2/Djx99xYpY5Jc9gm2zIk
xyzXVjy+NdOKN3iSR+D5lulBsXT/PqPfOz1gj3arJTxHGIgbq6n4Ksd1hDxJgity
EePH/vTa7RFrnMWT1ju+RdF2vY8D7cdVMmkX2uYrLsa8IfpOMJc=
=jvwH
-----END PGP SIGNATURE-----

--=-Ds3MvA/U3oyw2M42ov21--

