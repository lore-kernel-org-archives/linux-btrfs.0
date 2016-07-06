Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51591 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbcGFQcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 12:32:11 -0400
Date: Wed, 6 Jul 2016 15:56:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
Message-ID: <20160706155633.GN10223@carfax.org.uk>
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
 <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
 <20160706152027.GM10223@carfax.org.uk>
 <577D26E9.50607@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TUrtqMIkCP4YtJm"
In-Reply-To: <577D26E9.50607@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/TUrtqMIkCP4YtJm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2016 at 05:42:33PM +0200, Holger Hoffst=E4tte wrote:
> On 07/06/16 17:20, Hugo Mills wrote:
> > On Thu, Jul 07, 2016 at 12:16:01AM +0900, Wang Shilong wrote:
> >> On Wed, Jul 6, 2016 at 10:35 PM, Holger Hoffst=E4tte
> >> <holger@applied-asynchrony.com> wrote:
> >>> On 07/06/16 14:25, Wang Shilong wrote:
> >>>> 'btrfs file du' is a very useful tool to watch my system
> >>>> file usage with snapshot aware.
> >>>>
> >>>> when trying to run following commands:
> >>>> [root@localhost btrfs-progs]# btrfs file du /
> >>>>      Total   Exclusive  Set shared  Filename
> >>>> ERROR: Failed to lookup root id - Inappropriate ioctl for device
> >>>> ERROR: cannot check space of '/': Unknown error -1
> >>>>
> >>>> and My Filesystem looks like this:
> >>>> [root@localhost btrfs-progs]# df -Th
> >>>> Filesystem     Type      Size  Used Avail Use% Mounted on
> >>>> devtmpfs       devtmpfs   16G     0   16G   0% /dev
> >>>> tmpfs          tmpfs      16G  368K   16G   1% /dev/shm
> >>>> tmpfs          tmpfs      16G  1.4M   16G   1% /run
> >>>> tmpfs          tmpfs      16G     0   16G   0% /sys/fs/cgroup
> >>>> /dev/sda3      btrfs      60G   19G   40G  33% /
> >>>> tmpfs          tmpfs      16G  332K   16G   1% /tmp
> >>>> /dev/sdc       btrfs     2.8T  166G  1.7T   9% /data
> >>>> /dev/sda2      xfs       2.0G  452M  1.6G  23% /boot
> >>>> /dev/sda1      vfat      1.9G   11M  1.9G   1% /boot/efi
> >>>> tmpfs          tmpfs     3.2G   24K  3.2G   1% /run/user/1000
> >>>>
> >>>> So I installed Btrfs as my root partition, but boot partition
> >>>> can be other fs.
> >>>>
> >>>> We can Let btrfs tool aware of this is not a btrfs file or
> >>>> directory and skip those files, so that someone like me
> >>>> could just run 'btrfs file du /' to scan all btrfs filesystems.
> >>>>
> >>>> After patch, it will look like:
> >>>>    Total   Exclusive  Set shared  Filename
> >>>> skipping not btrfs dir/file: boot
> >>>> skipping not btrfs dir/file: dev
> >>>> skipping not btrfs dir/file: proc
> >>>> skipping not btrfs dir/file: run
> >>>> skipping not btrfs dir/file: sys
> >>>>      0.00B       0.00B           -  //root/.bash_logout
> >>>>      0.00B       0.00B           -  //root/.bash_profile
> >>>>      0.00B       0.00B           -  //root/.bashrc
> >>>>      0.00B       0.00B           -  //root/.cshrc
> >>>>      0.00B       0.00B           -  //root/.tcshrc
> >>>>
> >>>> This works for me to analysis system usage and analysis
> >>>> performaces.
> >>>
> >>> This is great, but can we please skip the "skipping .." messages?
> >>> Maybe it's just me but I really don't see the value of printing them
> >>> when they don't contribute to the result.
> >>> They also mess up the display. :)
> >>
> >> I don't have a taste whether it needed or not, because it is somehow
> >> useful to let users know some files/directories skipped....
>=20
> When you run "find /path -type d" you don't get messages for all the
> things you just didn't want to find either.

   No, but you do get messages about unreadable directories from find.

   Your example above would be "You asked for X and <thing> isn't an
X". That's not what these messages are about -- what we're seeing here
is "I tried to do what you asked to <thing>, but couldn't".

   Hugo.

> >    At the absolute minimum, I think that these messages should go to
> > stderr (like du does when it deosn't have permissions), and should go
> > away with -q. They're still irritating, but at least you can get rid
> > of them easily.
>=20
> If anything this should require a --verbose, not the other way
> around. Maybe instead of breaking the output just indicate the
> special status via "-- --" values, or default to 0.00?
> Still, we're explicitly only interested in btrfs stuff and not
> anything else, so printing non-information can only yield noise.
>=20
> This is very much orthogonal to not printing anything after an
> otherwise successful command execution.
>=20
> -h
>=20
>=20




--=20
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Stephen Franklin, Babylo=
n 5

--/TUrtqMIkCP4YtJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXfSoxAAoJEFheFHXiqx3k0aMP/i+F8HLoYyTU1CWZZk09EMEp
dFr3GJKU16tfm4ZuhQ4zX/xaPpYo47U4YW4gfM9N/Qo8Kb5Xmn5KiYWA2ecA1bMx
d7mTlFKd3yCDcbglJb0cAnDrn+rJe2zD2lHgog83Fasgz2hofF46NMXKm66jcI5o
sGhiMBi596GFyaf3tR8prWYENG5idpk48xhh3f66IbDAnPCtgIJkroEubdHw3Y74
5vSvY6Khdml0XMcdm0EN28pQvgR5ZWFhF9Ac8itqYSbF+QVLPJfC6JpskabEQgfU
gcCxC/yVHs834kRT5xB5xbzTyzfx2EbUNlIhd73CiFUyuDnyelv8n760JMAeKh5N
WnFt+TPZfL5RRp5fyBgHDxiLFq3T6fzi2jAiG5tL4aX1lefqyrrLAuoAg4iLiN61
0B8AE1rRjyDswMri8QpL0I5PMzmb2k+LwZxAVjcIcM3Ul0fF/C3mW/6lTsP4WlbU
kISyLFWdzR4phL1rlma7I1AQDkhRTm8zd9fnhGQ+R0E/iWaGYREwOn6QGsJSa7A/
W4uXvgMvPW4iKDJHCGaJkAYzt0GfvfjUNYufjwcPePWUxq1e4tDsHeeoD4pRFs2v
7nu517I//UYHDD2SuAocKPCRKWEO0DMfTT/JPoiCNDOu/P5ypKUXsZhcN6WK7tKF
6hgZ+wz8pPPWsoNYwXJo
=YqFK
-----END PGP SIGNATURE-----

--/TUrtqMIkCP4YtJm--
