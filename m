Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751985AbeCWLTy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 07:19:54 -0400
Subject: Re: Hard reset during balance - How to continue?
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn5E_Ybvka7MfLZkZs7gT44buB0K9n=6UPVZVX2M5YuEdw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <99731d92-5a18-441d-822c-b9de07a49606@gmx.com>
Date: Fri, 23 Mar 2018 19:19:41 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5E_Ybvka7MfLZkZs7gT44buB0K9n=6UPVZVX2M5YuEdw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eaxN1xDWo0SAN8HVBMwOKkDNMiqqZfF3z"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eaxN1xDWo0SAN8HVBMwOKkDNMiqqZfF3z
Content-Type: multipart/mixed; boundary="X9ifLwDJVxfTu1YpaaF8i8NbprmuGqnMA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <99731d92-5a18-441d-822c-b9de07a49606@gmx.com>
Subject: Re: Hard reset during balance - How to continue?
References: <CA+X5Wn5E_Ybvka7MfLZkZs7gT44buB0K9n=6UPVZVX2M5YuEdw@mail.gmail.com>
In-Reply-To: <CA+X5Wn5E_Ybvka7MfLZkZs7gT44buB0K9n=6UPVZVX2M5YuEdw@mail.gmail.com>

--X9ifLwDJVxfTu1YpaaF8i8NbprmuGqnMA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 19:04, james harvey wrote:
> If a system unexpectedly reboots during a balance, what's the best next=
 step?

Normally, nothing.
Btrfs CoW is pretty safe for most case.

>=20
> From an ISO, read-only operations/mounting looks fine.
>=20
> Didn't want to make any writes until I ask, because I see some reports
> of bad things happening with a reboot during a balance, and don't want
> to mis-step.

At least, with my test using balance and dm-log-writes (a tool can not
only emulate powerloss, but also be able to do a write-by-write
analyse), it shows some false alerts about btrfs check, but the result
looks pretty safe so far.
(Even for the false alert case, btrfs check --mode=3Dlowmem works just fi=
ne)

>=20
> btrfs check reports no errors.  mount -o ro,skip_balance works fine
> and directory entries seem correct.

Then nothing to worry about.

If you want more safety, run "btrfs check --check-data-csum" to double
check your data before RW mount.

Thanks,
Qu

>=20
> $ sudo btrfs balance status -v /mnt/tmp
> Balance on '/mnt/tmp' is paused
> 0 out of about 0 chunks balanced (0 considered), -nan% left
> Dumping filters: flags 0x17, state 0x0, force is off
>   DATA (flags 0x0): balancing
>   METADATA (flags 0x0): balancing
>   SYSTEM (flags 0x0): balancing
>=20
> This surprised me.  Not sure if it's expected for an interrupted or
> paused balance to show 0/0/0/nan.
>=20
> Do I re-mount without "ro,skip_balance" and see if it finishes the
> balance?  (If it doesn't, cancel and restart it?)
>=20
> Do I re-mount without "ro" but still with "skip_balance", and cancel
> the balance and restart it?  (Never trying to continue the interrupted
> balance?)
>=20
> Something else that I'm not aware of?
>=20
> ... System didn't reboot on its own, it became completely unresponsive
> for over 24 hours, and I had to perform a hard reset.  Active ssh
> sessions permanently hung, and local logins didn't get past asking for
> password.  Hoped I could get a btrfs balance cancel to run.
>=20
>=20
>=20
> $ uname -a
> Linux terra 4.15.8-1-ARCH #1 SMP PREEMPT Sat Mar 10 00:00:33 UTC 2018
> x86_64 GNU/Linux
>=20
> $ btrfs --version
> btrfs-progs v4.15.1
>=20
> $ sudo btrfs fi show /mnt/tmp
> Label: 'losable'  uuid: 9208dacc-8bb3-4303-9f71-124f0cecc7e7
>         Total devices 4 FS bytes used 6.92TiB
>         devid    1 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losab=
le1
>         devid    2 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losab=
le2
>         devid    3 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losab=
le3
>         devid    4 size 2.50TiB used 1.60TiB path /dev/mapper/lvm-losab=
le4
>=20
> $ sudo btrfs fi df /mnt/tmp
> Data, RAID0: total=3D6.92TiB, used=3D6.91TiB
> System, RAID1: total=3D8.00MiB, used=3D400.00KiB
> Metadata, RAID1: total=3D7.00GiB, used=3D5.77GiB
> GlobalReserve, single: total=3D368.09MiB, used=3D0.00B
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--X9ifLwDJVxfTu1YpaaF8i8NbprmuGqnMA--

--eaxN1xDWo0SAN8HVBMwOKkDNMiqqZfF3z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq04s0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhfeAf/QnbWePR0kZKbJYn0PzP+W6OI
Ve9zyO0J5Ixzbv3aSCZtw+5X1yJ8E2ZlofmDmcn3FLR60gBGFV2WraBTJ/eR9kST
vZWnd7V4Nbg3yr4iC9PXvuvGrkp3X6Fhc5A/vJmfyo3KZ6Fy5mxPuRyW6OvaYpF9
6erhVSx00vA3tccJX4uwkzwm7Bql7lur+ltN8IYAzedYTn+HnvkPQuDNU/Ko/+cN
mRxiHFLxXeV86Xcbv3sogJPPGUFYKDIlBuOe97gqT0fS43o8Zu+rufcPTQ3Li/e5
R5e/UV1tUahNczx7VqGtgViC+0LgLC/n2l3BnfB5yF795bFYoi48hXtYUf1oAA==
=GBW9
-----END PGP SIGNATURE-----

--eaxN1xDWo0SAN8HVBMwOKkDNMiqqZfF3z--
