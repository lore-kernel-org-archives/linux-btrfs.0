Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44783 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752921AbaICDcm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 23:32:42 -0400
Date: Tue, 2 Sep 2014 23:32:41 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120
 seconds
Message-ID: <20140903033239.GA10133@hungrycats.org>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
 <540498AF.6030109@fb.com>
 <CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
 <pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
In-Reply-To: <pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2014 at 05:20:29AM +0000, Duncan wrote:
> suspect your firmware is SERIOUSLY out of space and shuffling, as that'll=
=20
> slow the balance down too, and again after), try running fstrim on the=20
> device.  It may or may not work on that device, but if it does and the=20
> firmware /was/ out of space and having to shuffle hard, it could improve=
=20
> performance *DRAMATICALLY*.  The reason being that on devices where it=20
> works, fstrim will tell the firmware what blocks are free, allowing it=20
> more flexibility in erase-block shuffling.
>=20
> If that makes a big difference, you can /try/ the discard mount option. =
=20
> Tho doing the trim/discard as part of normal operations can slow them=20
> down some too.  The alternative would be to simply run fstrim=20
> periodically, perhaps every Nth rsync or some such.  Note that as the=20
> fstrim manpage says, the output of fstrim run repeatedly will be the=20
> same, since it only knows what areas are candidates to trim, not which=20
> ones are already trimmed, but it shouldn't hurt the device any to=20
> repeatedly fstrim it, and if you do it every N rsyncs, it should keep=20
> things from getting too bad again.

Note that dm-crypt does not pass discards to the underlying block device
by default for security reasons (john didn't mention the dm-crypt options
he was using).  cryptsetup has the --allow-discards option, /etc/crypttab
has the discard option to enable this.


I've seen hung task timeouts on several filesystems under 3.14.17 and
3.15.8-9 (mostly on spinning disks with dm-crypt and lvm2 underneath,
but sometimes without either).  I adjusted kernel.hung_task_timeout_secs
=66rom 120 to 960 and started running balances regularly, which helps
mitigate this problem, but not eliminate it (ironically, when a balance
is resumed at boot, it's usually one of the hung tasks in the kernel log).

A fairly good way to see this is to run 'btrfs fi defrag' on large files,
'btrfs balance' with large extents on the filesystem, or write a big
file quickly (1GB+ in <30 sec).  If a filesystem is more than 90% full
and free space is heavily fragmented (especially by rolling snapshots),
allocating large contiguous areas seems to take a long time, and it
seems to block some or all other allocations at the same time (I haven't
rigorously identified these, but it seems to include everything that calls
fsync() or performs certain metadata operations).  The writes usually do
finish in a few minutes, but write latency (measured by timing a 'mkdir'
call at regular intervals) can spike as high as 9+ hours.  Most people
(and watchdog robots) are reaching for the RESET button in less than
five minutes.  :-/


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlQGi9cACgkQgfmLGlazG5yBsACgt5RhelaX0z6LqJ9d8XtwTEEB
I1sAoN+N84rgOwXMb0xI72dcCjQlhXAc
=e/d5
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
