Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:51016 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaAWR6N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 12:58:13 -0500
Message-ID: <52E1582F.9080308@friendlyvirus.org>
Date: Thu, 23 Jan 2014 17:58:07 +0000
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send 3.11 vs 3.12
References: <52E0DF6B.2080200@friendlyvirus.org> <52E124E0.4040702@fb.com>
In-Reply-To: <52E124E0.4040702@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5sb0c4gkeK4wLHtG2F4F0uFWgJOgBnu0o"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5sb0c4gkeK4wLHtG2F4F0uFWgJOgBnu0o
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Em 23-01-2014 14:19, Josef Bacik escreveu:
>=20
> On 01/23/2014 04:22 AM, Miguel Negr=E3o wrote:
>> Hi
>>
>> Sending snapshots incrementally started to fail on the 3.11 kernel on =
my
>> system after I once booted with 3.12 and did the incremental send of a=

>> snapshot. After when I booted back to 3.11 I can no longer send the
>> snapshots incrementally based on the last one sent (I could still send=

>> based on the last one sent from 3.11), although booting again to 3.12 =
I
>> can send me fine again.
>>
>> It this intenteded ?
> This is definitely not intended, I will look into why this is
> happening.  Thanks,

Great, thanks.  The error:

> miguel@miguel-MacBookPro:~$ sudo btrfs send -p /mnt/ssd/backups/@-2014-=
01-22-11\:29/ /mnt/ssd/backups/@-2014-01-23-17\:51/ | sudo btrfs receive =
/media/miguel/backup/backups/@=20
> At subvol /mnt/ssd/backups/@-2014-01-23-17:51/
> At snapshot @-2014-01-23-17:51
> ERROR: could not find parent subvolume

> miguel@miguel-MacBookPro:~$ ls -l /media/miguel/backup/backups/@
> total 0
=2E..
> drwxr-xr-x 1 root root 358 Jan 22 11:31 @-2014-01-22-11:29

Don't know if it's relevant, but I'm already mounting the filesystem
with subvolid=3D5 since was an issue too:

> sudo mount -o subvolid=3D5 -U f2e4e4d3-2d8e-4764-a818-de9176405c4b /mnt=
/ssd

best,
Miguel






--=20
Miguel Negr=E3o
http://www.friendlyvirus.org/miguelnegrao


--5sb0c4gkeK4wLHtG2F4F0uFWgJOgBnu0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS4Vg0AAoJEPo6SjfPe12DnnUH/0U9gIwCAZVtKFD0f+XgaHRA
ri1xWHbw8Hkk1iCaEZnsDAt1X6RSsURnRpJRbzc9maD4z2o5+n6b+tsL+aaa9hSG
NwfwX/Ex2VwtGVv6d9XQ441+gD2UBIvnRl8ZDlWL0X+mnjXDvhCAaceA0xDg111s
RJokIANg0+x7b2JjUhSmpGn3Y8Szmm/msKh0PT1FVjdGIuvrH/nmPMp9qiKjv76o
HOR9qDxkaTV9whf6PhHzWHzUDaQ+4lz5QfrF3D1ddze4WB43hLf07wDChL9Gs/Gt
bW06u79KWHqz7fM+oYxqLYt09PVHc+nEtBD2NqA+hgfrR6FukxKxiEPQGERMlWY=
=HvaQ
-----END PGP SIGNATURE-----

--5sb0c4gkeK4wLHtG2F4F0uFWgJOgBnu0o--
