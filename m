Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51453 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcGFPUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 11:20:30 -0400
Date: Wed, 6 Jul 2016 15:20:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
Message-ID: <20160706152027.GM10223@carfax.org.uk>
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
 <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVCoas+krw6dou6l"
In-Reply-To: <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HVCoas+krw6dou6l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 12:16:01AM +0900, Wang Shilong wrote:
> On Wed, Jul 6, 2016 at 10:35 PM, Holger Hoffst=E4tte
> <holger@applied-asynchrony.com> wrote:
> > On 07/06/16 14:25, Wang Shilong wrote:
> >> 'btrfs file du' is a very useful tool to watch my system
> >> file usage with snapshot aware.
> >>
> >> when trying to run following commands:
> >> [root@localhost btrfs-progs]# btrfs file du /
> >>      Total   Exclusive  Set shared  Filename
> >> ERROR: Failed to lookup root id - Inappropriate ioctl for device
> >> ERROR: cannot check space of '/': Unknown error -1
> >>
> >> and My Filesystem looks like this:
> >> [root@localhost btrfs-progs]# df -Th
> >> Filesystem     Type      Size  Used Avail Use% Mounted on
> >> devtmpfs       devtmpfs   16G     0   16G   0% /dev
> >> tmpfs          tmpfs      16G  368K   16G   1% /dev/shm
> >> tmpfs          tmpfs      16G  1.4M   16G   1% /run
> >> tmpfs          tmpfs      16G     0   16G   0% /sys/fs/cgroup
> >> /dev/sda3      btrfs      60G   19G   40G  33% /
> >> tmpfs          tmpfs      16G  332K   16G   1% /tmp
> >> /dev/sdc       btrfs     2.8T  166G  1.7T   9% /data
> >> /dev/sda2      xfs       2.0G  452M  1.6G  23% /boot
> >> /dev/sda1      vfat      1.9G   11M  1.9G   1% /boot/efi
> >> tmpfs          tmpfs     3.2G   24K  3.2G   1% /run/user/1000
> >>
> >> So I installed Btrfs as my root partition, but boot partition
> >> can be other fs.
> >>
> >> We can Let btrfs tool aware of this is not a btrfs file or
> >> directory and skip those files, so that someone like me
> >> could just run 'btrfs file du /' to scan all btrfs filesystems.
> >>
> >> After patch, it will look like:
> >>    Total   Exclusive  Set shared  Filename
> >> skipping not btrfs dir/file: boot
> >> skipping not btrfs dir/file: dev
> >> skipping not btrfs dir/file: proc
> >> skipping not btrfs dir/file: run
> >> skipping not btrfs dir/file: sys
> >>      0.00B       0.00B           -  //root/.bash_logout
> >>      0.00B       0.00B           -  //root/.bash_profile
> >>      0.00B       0.00B           -  //root/.bashrc
> >>      0.00B       0.00B           -  //root/.cshrc
> >>      0.00B       0.00B           -  //root/.tcshrc
> >>
> >> This works for me to analysis system usage and analysis
> >> performaces.
> >
> > This is great, but can we please skip the "skipping .." messages?
> > Maybe it's just me but I really don't see the value of printing them
> > when they don't contribute to the result.
> > They also mess up the display. :)
>=20
> I don't have a taste whether it needed or not, because it is somehow
> useful to let users know some files/directories skipped....

   At the absolute minimum, I think that these messages should go to
stderr (like du does when it deosn't have permissions), and should go
away with -q. They're still irritating, but at least you can get rid
of them easily.

   Hugo.

> Wait some other guys opinion for this...
>=20
> thanks,
> Shilong
>=20
> >
> > thanks,
> > Holger
> >

--=20
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Stephen Franklin, Babylo=
n 5

--HVCoas+krw6dou6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXfSG6AAoJEFheFHXiqx3kbWEP+wYAsiLoK0vIohFn+RuCQG43
1N89W/3ONbXxANuCya2yLMrCn0tdqV5P1LJjFU4Ar05r9R+xq3XlbqR5Sia8c4BA
hBIhBMqItpUxwbTc7lk4jkGduqO+8O9GJiqBN3HxLvGM/OtBoiDQqcgTthiZJ5OA
Q9ndIVGq9r8WlEVymJiaShXklET9yQIEJ4SFUHOpd57Gb2szll3mmv4PvQPzZXJA
IgWLr+xRrQrWhOuXbY0Hi72aFS5O17hfxq5dxi9KRymDZa8tB3FuZzOFsIEzMmnl
KPDQNG0vtpqkLrBJeLsVWq1XBwN0XUFgxsx6u5HyydZ/NyO2A2EUe2Yv9hfExvZX
5GUHjVIOCbxcib6+Uabi///9CMcKRMaltBijvrfKVx6OVlpqdN+OP/IVYp168nBh
aBcuuPUYQM1Kzuwm4ADY+VgbJWtFX8aDRfWJB7gu22p4u11Ln2nPHvVysI5+773e
OB7Q04mZuOoIVHg8zUD5vkicwdPD3tJ+UvHHysPKm4CW1kYNSL2D2f53NCyBsOdx
n+R3NimyuJqbcILygrhzu4SITapKSMTaRBnNJUgO5T47CLL6vKM6cD375tYuPYGm
3VLOK/3lhHiB2OqduWnHBQ44CURhXS/l4KTGkgXA+oorDlblZFGMtFsPfEnH149t
4bMVidSaYaJ/KMtx7MVe
=OB1R
-----END PGP SIGNATURE-----

--HVCoas+krw6dou6l--
