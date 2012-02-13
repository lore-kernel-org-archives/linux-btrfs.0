From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 14:09:21 +0600
Message-ID: <20120213140921.5a009404@natsu>
References: <4F38B8F0.5020506@yahoo.com>
	<4F38BE53.4080204@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P6HNOw6X9NNMNh44eMAu6st"; protocol="application/pgp-signature"
Cc: <linux-btrfs@vger.kernel.org>
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F38BE53.4080204@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/P6HNOw6X9NNMNh44eMAu6st
Content-Type: multipart/mixed; boundary="MP_//Q0Suku0qGINyzS3knMfxSz"

--MP_//Q0Suku0qGINyzS3knMfxSz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mon, 13 Feb 2012 16:40:03 +0900
dima <dolenin@parallels.com> wrote:

> Hello Ralf-Peter,
>=20
> Actually it is possible. Check out David's response to my question from=20
> some time ago:
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>=20
> The nocow.c script he attached does just the thing you want. The script=20
> is really working. I needed nocow for different purpose but it did not=20
> occur to me to try it on VM image and see if the performance would=20
> improve. Sounds like a great idea. If you get around to try it, pls.=20
> post your impressions here.

Thanks for the link, this is indeed interesting.

I made a couple of small changes, i.e. I wanted a way to unset nocow and to
check that changing flags really worked.

gcc -o /usr/local/bin/nocow nocow.c
ln -sf /usr/local/bin/nocow /usr/local/bin/cow

Perhaps the support for setting this flag should be added to the 'btrfs'
utility.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--MP_//Q0Suku0qGINyzS3knMfxSz
Content-Type: text/x-csrc
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=nocow.c

#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <string.h>

#include <linux/types.h>
#include <stdio.h>
#include <errno.h>

#ifndef FS_IOC_SETFLAGS
#define FS_IOC_SETFLAGS                 _IOW('f', 2, long)
#warning defining SETFLAGS locally
#endif

#ifndef FS_IOC_GETFLAGS
#define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
#warning defining GETFLAGS locally
#endif

#ifndef FS_NOCOW_FL
#define FS_NOCOW_FL                     0x00800000 /* Do not cow file */
#endif

int main(int argc, char **argv)
{
        int fd;
        int r;
  long flags;

  if (argc < 2) {
    printf("usage: %s file\n", argv[0]);
    exit(1);
  }

  fd =3D open(argv[1], O_RDONLY);
  if (fd =3D=3D -1) {
    perror("open()");
    return 1;
  }
  printf("GETFLAGS ioctl 0x%x\n", FS_IOC_GETFLAGS);
  printf("SETFLAGS ioctl 0x%x\n", FS_IOC_SETFLAGS);

  r =3D ioctl(fd, FS_IOC_GETFLAGS, &flags);
  if (r =3D=3D -1) {
    perror("ioctl(GETFLAGS)");
    return 1;
  } else {
    printf("file flags before: 0x%lx\n", flags);
  }

  if(strcmp(argv[0], "cow")=3D=3D0) {
    printf("Remove NOCOW flag for %s\n", argv[1]);
    flags ^=3D FS_NOCOW_FL;
  } else {
    printf("Set NOCOW flag for %s\n", argv[1]);   =20
    flags |=3D FS_NOCOW_FL;
  }
  r =3D ioctl(fd, FS_IOC_SETFLAGS, &flags);
  printf("ioctl returned: %d\n", r);
  if (r =3D=3D -1) {
    perror("ioctl()");
    return 1;
  }

  r =3D ioctl(fd, FS_IOC_GETFLAGS, &flags);
  if (r =3D=3D -1) {
    perror("ioctl(GETFLAGS)");
    return 1;
  } else {
    printf("file flags after:  0x%lx\n", flags);
  } =20

  return 0;
}

--MP_//Q0Suku0qGINyzS3knMfxSz--

--Sig_/P6HNOw6X9NNMNh44eMAu6st
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk84xTEACgkQTLKSvz+PZwh6uwCfeJD2jj7JMqBiCXLL66McMyA1
GjoAn2IrPfBeR3jAsNtbC0tP6irOKPxY
=KH4S
-----END PGP SIGNATURE-----

--Sig_/P6HNOw6X9NNMNh44eMAu6st--
