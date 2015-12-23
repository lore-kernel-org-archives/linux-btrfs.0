Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kaylee.flamingspork.com ([74.207.245.61]:32808 "EHLO
	kaylee.flamingspork.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965740AbbLWX2y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 18:28:54 -0500
From: Stewart Smith <stewart@flamingspork.com>
To: Eric Sandeen <sandeen@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        fsdevel <linux-fsdevel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: Ideas on unified real-ro mount option across all filesystems
In-Reply-To: <567228EF.80007@redhat.com>
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
Date: Thu, 24 Dec 2015 10:22:31 +1100
Message-ID: <87twn8vjgo.fsf@flamingspork.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Eric Sandeen <sandeen@redhat.com> writes:
>> 3) A lot of user even don't now mount ro can still modify device
>>    Yes, I didn't know this point until I checked the log replay code of
>>    btrfs.
>>    Adding such mount option alias may raise some attention of users.
>
> Given that nothing in the documentation implies that the block device its=
elf
> must remain unchanged on a read-only mount, I don't see any problem which
> needs fixing.  MS_RDONLY rejects user IO; that's all.
>
> If you want to be sure your block device rejects all IO for forensics or
> what have you, I'd suggest # blockdev --setro /dev/whatever prior to moun=
t,
> and take it out of the filesystem's control.  Or better yet, making an
> image and not touching the original.

What we do for the petitboot bootloader in POWER and OpenPower firmware
(a linux+initramfs that does kexec to boot) is that we use device mapper
to make a snapshot in memory where we run recovery (for some
filesystems, notably XFS is different due to journal not being endian
safe). We also have to have an option *not* to do that, just in case
there's a bug in journal replay... and we're lucky in the fact that we
probably do have enough memory to complete replay, this solution could
be completely impossible on lower memory machines.

As such, I believe we're the only bit of firmware/bootloader ever that
has correctly parsed a journalling filesystem.

=2D-=20
Stewart Smith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWeyy3AAoJEOeWNk/DvaDuf9MQANVmyHm1559u++pZu4e+EXv5
q+NolT7SBz/Pub4hMuo7DkS+NGt6zm/2tWAhQ4X5/6449LQpJAhGVyOkb9/RMHXU
NYaWs9mXMw3SpB8AwTLf6f9UBAaVYj5ayvlS2xKBICxtm0rXSTHy2MerhCLsMGrl
CO87v/qYddhZIJAFzUzn5s25n7y3H8MZKU+rIcirTyVI9UuQbC1lcTSE/Khrggbp
S/8wpLPlM8f6fJ9pXlEoJRLszdTTx8EA0JpQSp5LfA9WEr6Vp4/l+/92DY5C6V7Q
DZtFiv6FxU1rsnP4D0QF/v6ku8As0cLmiV/F8TwlfTuNEYPbvPiO+x/AVzDBWTER
UKiCstDo7HinSWnWbqYNlzskqdff20+pMY92CJ8AaFZdNQGMLWd0HO48DTz+EV2i
0HjU0ax4Fzg9AkcbMBaZxS8s7+W9a5g6O3+foh9dOOnYx8S5Dt7xq9HYjeTlMBkC
/+/WfkEceqrCOoKGkdH+KQhs4I5BWo0ytOO2DeXuuLm36qzI7HYwI3Dq2XgHF+1V
5HBi2hlXO+VyeglMCia4vJSj5U0zzR37+1EdFEE5LocsKAFfxghVqoFMUeZMsqci
5WUgP/exreGaULOrXpC0abknqB5d4nsoHiywXRrb2G8bsrTad7qY6sbNxuTE4kST
z4Bn86ecWWhZIOHPsDrR
=dU/8
-----END PGP SIGNATURE-----
--=-=-=--
