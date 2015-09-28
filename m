Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:57347 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbbI1Ij6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 04:39:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id BEC2922038
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 10:39:56 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EDTXSVL71CIu for <linux-btrfs@vger.kernel.org>;
	Mon, 28 Sep 2015 10:39:56 +0200 (CEST)
Received: from [192.168.2.2] (85-126-169-193.work.xdsl-line.inode.at [85.126.169.193])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 10:39:56 +0200 (CEST)
Message-ID: <5608FCD9.2000902@mur.at>
Date: Mon, 28 Sep 2015 10:39:53 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: strange i/o errors with btrfs on raid/lvm
References: <560409E7.5020500@mur.at>	<CAJCQCtQ3aSfHE3o4nyaKOJjDbxiw87GHW6_JdBC1vnDgQXgGKA@mail.gmail.com>	<CAJCQCtRMumq4=QqujuOxu6nC0W+6dv1tWzqe8fCzzEEa-D+1ZQ@mail.gmail.com>	<5605ADE4.5090800@mur.at> <CAJCQCtTaagpqurnjLeN7Mw8oBv59uWYtMbOb5REo8NgiP+UjjA@mail.gmail.com>
In-Reply-To: <CAJCQCtTaagpqurnjLeN7Mw8oBv59uWYtMbOb5REo8NgiP+UjjA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kxScw6e3D55Ta08DUW3x6P7hsWsxoCTH8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kxScw6e3D55Ta08DUW3x6P7hsWsxoCTH8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Chris, all,

Am 2015-09-25 um 22:47 schrieb Chris Murphy:
> On Fri, Sep 25, 2015 at 2:26 PM, Jogi Hofm=C3=BCller <jogi@mur.at> wrot=
e:
>=20
>> That was right while the RAID was in degraded state and rebuilding.
>=20
> On the guest:
>=20
> Aug 28 05:17:01 vm kernel: [140683.741688] BTRFS info (device vdc):
> disk space caching is enabled
> Aug 28 05:17:13 vm kernel: [140695.575896] BTRFS warning (device vdc):
> block group 13988003840 has wrong amount of free space

The device vdc is the backup device.  That's where we collect snapshots
of our mail spool.  I could fix that remounting with -o clear_cache as
you suggested.  However it is not directly related to the I/O error
problem.  The backup device sits on a different RAID than the mail spool.=


> On the host, there are no messages that correspond to this time index,
> but a bit over an hour and a half later are when there are sas error
> messages, and the first reported write error.
>=20
> I see the rebuild event starting:
>=20
> Aug 28 07:04:23 host mdadm[2751]: RebuildStarted event detected on md
> device /dev/md/0
>=20
> But there are subsequent sas errors still, including hard resetting of
> the link, and additional read errors. This continues more than once...

That is smartd still trying to read the failed device (sda).

> And then
>=20
> Aug 28 17:06:49 host mdadm[2751]: RebuildFinished event detected on md
> device /dev/md/0, component device  mismatches found: 2048 (on raid
> level 10)

Right.  I totally missed the 'mismatches found' part :(

> and also a number of SMART warnings about seek error on another device
>=20
> Aug 28 17:35:55 host smartd[3146]: Device: /dev/sda [SAT], SMART Usage
> Attribute: 7 Seek_Error_Rate changed from 180 to 179

Still the failed device.  These messages continue until we replaced the
disk with a new one.

> But 2048 mismatches found after a rebuild is a problem. So there's
> already some discrepancy in the mdadm raid10. And mdadm raid1 (or 10)
> cannot resolve mismatches because which block is correct is ambiguous.
> So that means something is definitely going to get corrupt. Btrfs, if
> the metadata profile is DUP can recover from that. But data can't.
> Normally this results in an explicit Btrfs message about a checksum
> mismatch and no ability to fix it, but will still report the path to
> affected file.  But I'm not finding that.

I ran checkarray on md0 and that reduced the mismatch_cnt to 384.

What I still don't understand is why it is possible to make a backup of
a file that is not accessible in the file system.  All files that
produce an I/O error upon access are fine on the backup drive.  It's
even possible to restore a file from the backup drive and then it is
read/writable again.

Another thing I cannot explain is why the only files affected are those
that get read/written lot's of times.

And finally the question is why does none of the other logical volumes
that reside on the same RAID experience any problems?  There are several
other logical volumes containing btrfs and ext4 file systems.

Anyhow, thanks for all the suggestions so far.

Cheers,

PS:  my messages with attached log files got forwarded to /dev/null
because they exceeded the 100000 char limit :(
--=20
j.hofm=C3=BCller

We are all idiots with deadlines.                       - Mike West


--kxScw6e3D55Ta08DUW3x6P7hsWsxoCTH8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlYI/NoACgkQkaXhaapqItlGQAEAnHcbrBFalb5gRDE3snR7Y3i3
zywOTRzUw/eJMaoZU6MA/irqHmWCgw3v0MipyCelFBsqHmoewE0Ky3ImMvuyMbX2
=jYN6
-----END PGP SIGNATURE-----

--kxScw6e3D55Ta08DUW3x6P7hsWsxoCTH8--
