From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Create subvolume from a directory?
Date: Thu, 03 May 2012 15:26:20 +0200
Message-ID: <18314084.XgMbhzHaqD@bursa01>
References: <loom.20120327T190041-268@post.gmane.org> <8026880.aVIK1HJLHr@bursa01> <20120502163337.GH6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1376718.uVskBq5Uyb"; micalg="sha256"; protocol="application/pkcs7-signature"
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, kreijack@inwind.it,
	"Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502163337.GH6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1376718.uVskBq5Uyb
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday 02 of May 2012 18:33:37 David Sterba wrote:
> On Tue, May 01, 2012 at 07:09:21PM +0200, Hubert Kario wrote:
> > Let me rephrase it:
> >=20
> > People don't want to be able to do:
> >=20
> > mount /dev/lvm/btrfs /mnt/a -t btrfs -o subvol=3DvolA
> > mount /dev/lvm/btrfs /mnt/b -t btrfs -o subvol=3DvolB
> > cp --reflink=3Dalways /mnt/a/file /mnt/b
> >=20
> > Just like you can't do hardlinks over `mount --bind` mountpoints, y=
ou
> > shouldn't be able to cp reflink over mountpoints. That's expected a=
s this
> > *does* break VFS semantics.
>=20
> Proposed fix (incremental on top of the cross-subvol):

I'm a noob as far as kernel development is concerned so take my comment=
s for=20
what they're worth.
=20
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2321,6 +2321,10 @@ static noinline long btrfs_ioctl_clone(struct =
file
> *file, unsigned long srcfd, goto out_drop_write;
>         }
>=20
> +       ret =3D -EXDEV;
> +       if (src_file->f_path.mnt !=3D file->f_path.mnt)

I'm not sure about this comparision. Is the f_path struct member used j=
ust as=20
reference to some general kernel structure?

> +               goto out_fput;
> +
>         src =3D src_file->f_dentry->d_inode;
>=20
>         ret =3D -EINVAL;

Other that that, looks OK.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--nextPart1376718.uVskBq5Uyb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCBsow
ggbGMIIErqADAgECAghgRNYwzIbzHzANBgkqhkiG9w0BAQsFADBRMSowKAYDVQQLDCFRQlMgQ2xh
c3MgMyBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxFjAUBgNVBAoMDVFCUyBKYW4gS3ViYW4xCzAJBgNV
BAYTAlBMMB4XDTExMDUxNjEwMDUzMloXDTEyMDUxNjEwMDUzMlowgaYxHTAbBgkqhkiG9w0BCQEW
DmhrYUBxYnMuY29tLnBsMRUwEwYDVQQDDAxIdWJlcnQgS2FyaW8xDzANBgNVBCoMBkh1YmVydDEO
MAwGA1UEBAwFS2FyaW8xFzAVBgNVBAoMDlFCUyBKYW4gS3ViYcWEMREwDwYDVQQHDAhXYXJzemF3
YTEUMBIGA1UECAwLbWF6b3dpZWNraWUxCzAJBgNVBAYTAlBMMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAtmTUo4Y/Qnf6MzeQiOYc56cvVa1b3VJaZDGC3ZSj8rPlj68nHL/Tk9FCRI3S
YlJ1efskI4j8zVlxKTLetPCEUqE3PO2UQ0OaFCpdcbZQ9yvVXUbEVNAZ5quE856LmQzQ33/Kvsek
LEzfYfeLS1yjqrhqIUYblkycZT6wowsx70NfXtfSb6H9DDjX1u0WpU6jK8lLaphEA9vQB+zEfYQW
raCY1E0auEiGbPfPNi3x0if/ckVuUYCwr7IJaQg4hcYXFhUuKcbbFebUDOl8L1oi/2QwxC83U87p
an+2awtbCWD33Q+QwSRoHUuX6pQs0sPnZehh+PfdmAC9MkWAg8fXRwIDAQABo4ICSjCCAkYwUQYI
KwYBBQUHAQEERTBDMEEGCCsGAQUFBzABhjVodHRwOi8vY2EucWJzLmNvbS5wbDo4MDgwL2VqYmNh
L3B1YmxpY3dlYi9zdGF0dXMvb2NzcDAdBgNVHQ4EFgQUZ6aWItDHMTdc4y1LLdYvTB/kmhswDAYD
VR0TAQH/BAIwADAfBgNVHSMEGDAWgBRThM4WgbPV3Ji/Qgr6taX1RUTbLDCB/QYDVR0fBIH1MIHy
MIHvoIGVoIGShoGPaHR0cDovL2NhLnFicy5jb20ucGw6ODA4MC9lamJjYS9wdWJsaWN3ZWIvd2Vi
ZGlzdC9jZXJ0ZGlzdD9jbWQ9Y3JsJmlzc3Vlcj1vdT1RQlMlMjBDbGFzcyUyMDMlMjBDZXJ0aWZp
Y2F0ZSUyMEF1dGhvcml0eSxvPVFCUyUyMEphbiUyMEt1YmFuLGM9UEyiVaRTMFExKjAoBgNVBAsM
IVFCUyBDbGFzcyAzIENlcnRpZmljYXRlIEF1dGhvcml0eTEWMBQGA1UECgwNUUJTIEphbiBLdWJh
bjELMAkGA1UEBhMCUEwwDgYDVR0PAQH/BAQDAgSwMGIGA1UdJQRbMFkGCCsGAQUFBwMCBggrBgEF
BQcDAwYIKwYBBQUHAwQGCisGAQQBgjcUAgIGCisGAQQBgjcKAwwGCisGAQQBgjcCARUGCisGAQQB
gjcCARYGCSqGSIb3LwEBBTAvBgNVHREEKDAmgQ5oa2FAcWJzLmNvbS5wbIEUd2VibWFzdGVyQHFi
cy5jb20ucGwwDQYJKoZIhvcNAQELBQADggIBAE2d0JelbaaQJRuxZxndox3YC6JbOU+rG2wtQ0NG
rS2xtlqW3NnFrwj0Z9aCAJxFh1kD6HpeGqhx6QHILCIjjogJ4hJsge66B37oP+xd1SJVGHlpeyA/
hS2Fj6r0YnTT6umy0i6tDO9lvbPewalfklVCwkjqnJsFiMI4qew7HY/Gc/GxHABjE2W9NeXtDDfq
zxJ3LUXwuqVHF74EMO7N1mBgiGOM7yAVuOCGzpX86fgWFpLqRHKymuSj9VgIAa80eX3+LOZ3YYzc
SAbY2TJbN1BmU5kfGQMTIceXzB8Inub1PfUQ7mrLhheq3UIt+3MaUtgfhi2Um1RPtxway6JtUpu+
pDXHukM5vgYHRfIgfVE5jClLLeIv9ktjDpd5cGhhQjtzfeE+kaP8323xj2M+c2RJurcj2TGE48dj
e3aGLK4a7VSd8fsGNgdOYjua3f29kRGX/O1hug+bRAd0WYYEjIZL/eB8EAm6k75B9IyGvdyXP5xu
SxW4kRRj6cU22M8evhFJ6uM/Rljn3UESuob2m7hsloJVJbqDPUlvkqT8q26VLdiSoHY0vikw+oxq
dgmTm8dicjBi+ajvkonqDP3d2sm+yqpOld0+2HvEzYrPxCzg85H5WWCmTjR+bgbb04gFWi0e7P6X
hGysv5O7TJTFOkZ4WnKM6QqUrpSaM9PC4eR7MYICHjCCAhoCAQEwXTBRMSowKAYDVQQLDCFRQlMg
Q2xhc3MgMyBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxFjAUBgNVBAoMDVFCUyBKYW4gS3ViYW4xCzAJ
BgNVBAYTAlBMAghgRNYwzIbzHzANBglghkgBZQMEAgEFAKCBkzAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA1MDMxMzI2MjBaMCgGCSqGSIb3DQEJDzEbMBkwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMC8GCSqGSIb3DQEJBDEiBCDtFULqdEdFGzmCQZScamHRuS+g
DYaspfqzAdwqqKTszzANBgkqhkiG9w0BAQEFAASCAQAHg/WVlz+qCMp/7Fq7m+SWvKeh+rdp/a1e
XPHbSi2SZXpXKTgZqUQXYuq2GJye7TBQe1xzs+UfNdZbQyquKhrHaRcpTvcLZk+JB1dsABezgJV8
UlKJkSAGO2/grggpZNDjlcrkyHx2ZmdJwF2ZCyZ50n5DsAMo/KIrILZ6RTUNI0unkYclg/nCE1RQ
skFQiD98/feqQ2aeyhTQXLWO2WtO0eqqiI44bYlLUGeK6oExm82W/AlnQNrFWiBYe0Y08PL657mM
DuLbiuD/pwcBX0GF7e2VsDBAIj+cxQH0uNjTr8yoQg89xm/BISUH4zY9to/HJ+7XS8JPnOQ2QGAm
xfaLAAAAAAAA

--nextPart1376718.uVskBq5Uyb--

