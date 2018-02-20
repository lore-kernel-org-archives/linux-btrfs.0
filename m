Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mtel-bg02.venev.name ([77.70.28.44]:49464 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbeBTQVU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 11:21:20 -0500
Received: from client0359.vpn.ox.ac.uk ([129.67.117.103] helo=[10.16.11.175])
        by mtel-bg02.venev.name with esmtpsa (TLSv1.2:ECDHE-ECDSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hristo@venev.name>)
        id 1eoAB0-0002rO-5g
        for linux-btrfs@vger.kernel.org; Tue, 20 Feb 2018 17:49:54 +0200
Message-ID: <1519141810.8586.4.camel@venev.name>
Subject: btrfs_clone_files and bind mounts
From: Hristo Venev <hristo@venev.name>
To: linux-btrfs@vger.kernel.org
Date: Tue, 20 Feb 2018 15:50:10 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-czW2JXDURt0zvPXqjBBE"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-czW2JXDURt0zvPXqjBBE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What is the problem with cloning files between different (vfs)mounts of
the same filesystem?
--=-czW2JXDURt0zvPXqjBBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEoyGBLUWLy7TrlT7Wydifi1CrK4gFAlqMQ7IACgkQydifi1Cr
K4gknQ/8C6PD05A8aVxDkatinDVROzuukSsBBHEH56TyFGLCUkgH5/clajj4SKe+
p8oQTPOtv+z0SxEGmdZcnY2Iza+rXSe0vFjOD7APsUbh1EqV5qY/FBQDFfwKtyRj
NurJx3fCkVQSV1iCj0/oUe8Pt+cSemf7/UHljVAoVs56rcXx2tMIzBiYijC/HyFz
uKa9U1R6HtUeVgMiw4CFpwy3hZfbPxmmSG1vSN85D+Z0uxv4Zg49+NgXu0d4V9Os
/tuKFtEQ5QQvfR/G6zb1+9wueo1Dq+dGPQkV5zCna+hPcWqmQ6OJX1x+f0R7jcUt
PtbA/mrpgsXPNN2erRmE5mdwGevDmth6nyrE1AkkTE3h/nSgzapp0Hz+9rL9KAI/
hdIHsNg1GNnIC8a+k8dCFbHw/VVgdM8MKnNuTpjIFZ7b5jHBICzE5Lv5SqjpUTEp
UoQbwzxirkMOGyG8x6S0mzzWhc0rK1FDymXHFpijzbCs1z/iyMZ/SFawkOxS5kUh
Su2lxd26wFRJ4ml1+3P0hWYl/CmBdQ/EAAmIPtw30KPvluGYRgkzquXQyMX+CiVF
2tCEZ5r+CIGXREr52SYFTV/guJpIvWFupuJVVThZpOt1GltJeTZoHgj5O2Rz6zQL
q+vhMOVpzdu0AzTjZX2lIhncye5xclAHx9KkmRtovxN7NwsaUvg=
=8+Ue
-----END PGP SIGNATURE-----

--=-czW2JXDURt0zvPXqjBBE--

