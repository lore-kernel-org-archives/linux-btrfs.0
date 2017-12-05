Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54398 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLEI5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:57:35 -0500
Subject: Re: [PATCH 1/7] btrfs-progs: Explictly state test.sh must be
 executable
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ebf9a8d1-fc87-37ce-fb1a-e735e473c6fb@gmx.com>
Date: Tue, 5 Dec 2017 16:57:23 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NDvI1e0w6Buw23ll5JHRWu5rKbwAiMbpC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NDvI1e0w6Buw23ll5JHRWu5rKbwAiMbpC
Content-Type: multipart/mixed; boundary="aNMbuVCqijq2jxkPS5fnigTPkcAK62H3Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ebf9a8d1-fc87-37ce-fb1a-e735e473c6fb@gmx.com>
Subject: Re: [PATCH 1/7] btrfs-progs: Explictly state test.sh must be
 executable
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-2-git-send-email-nborisov@suse.com>

--aNMbuVCqijq2jxkPS5fnigTPkcAK62H3Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  tests/README.md | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/tests/README.md b/tests/README.md
> index 04d2ce2ab40d..c456018554cc 100644
> --- a/tests/README.md
> +++ b/tests/README.md
> @@ -164,7 +164,9 @@ how to do mkfs, mount, unmount, check, etc.
>  and join by dashes `-`. This will become the directory name, eg. `012-=
subvolume-sync-must-wait`.
> =20
>  3. Write a short description of the bug and how it's tested to the com=
ment at the
> -begining of `test.sh`. You don't need to add the file to git yet.
> +begining of `test.sh`. You don't need to add the file to git yet. Don'=
t forget
> +to make the file executable, otherwise it's not going to be executed b=
y the
> +infrastructure.

This comment is really needed, as myself also sometimes forget to do that=
=2E

Reviewed-by: <wqu@suse.com>

Thanks,
Qu

> =20
>  4. Write the test commands, comment anything that's not obvious.
> =20
>=20


--aNMbuVCqijq2jxkPS5fnigTPkcAK62H3Q--

--NDvI1e0w6Buw23ll5JHRWu5rKbwAiMbpC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomX3MXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgynQf8DLMO6v3kfluq6SWvGsW5wJY0
jZgUiXpijwHUXWeCoC23Gd7UiN2QgpkCmk3PqsLKip+icMMWS7SU1zDqROERjVhk
L56lXQK5e7M9p7XWMfe169HbYUT35oLz9TTNZ5hOdb5QqO3O8ynU0Xh8kOaatZRP
6Fd2rx2zewBoaojV91O2x9OIesP1LP/89oGgE+MekPCr+QBAcr7RN7U4DLRltlDv
ZxtyzGo4+ZCSaXGH8X2rZdJFFbuzb/OlffmIwycGMc/Ezx9Qhr2SyEa0vtOKb9YI
Jz/Y+XqwmFOlQLOM6bpyESGQq83o8TPorO5Js8h4IwxzbsJdeXAOWZgtWJRrMg==
=e+p2
-----END PGP SIGNATURE-----

--NDvI1e0w6Buw23ll5JHRWu5rKbwAiMbpC--
