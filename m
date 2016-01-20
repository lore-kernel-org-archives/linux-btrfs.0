Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:56836 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbcATFI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 00:08:58 -0500
Date: Wed, 20 Jan 2016 10:08:52 +0500
From: Roman Mamedov <rm@romanrm.net>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120100852.470479a6@natsu>
In-Reply-To: <20160120001944.GA9884@localhost.localdomain>
References: <20160120030223.22cc3ae0@natsu>
	<20160120001944.GA9884@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qxt6WjpEZFnvYT1DZ5l0Qi0"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Qxt6WjpEZFnvYT1DZ5l0Qi0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jan 2016 16:19:44 -0800
Liu Bo <bo.li.liu@oracle.com> wrote:

> What about 'btrfs fi df' 's output on the directory where $NAME.img is
> located?

$ sudo btrfs fi df .
Data, single: total=3D8.59TiB, used=3D8.47TiB
System, DUP: total=3D32.00MiB, used=3D624.00KiB
Metadata, DUP: total=3D13.00GiB, used=3D9.87GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
-               9.1T  8.5T  571G  94% /mnt/r5/vm

The guest VM disk itself is 8 GB in size.

> According to my experience, kvm guest can be 'no response' when no space
> on the backend's filesystem, but you said that the alternative way
> work, so it doesn't look like a no space issue.

I don't get any ENOSPC errors on the host, also it doesn't seem to be a
slowdown caused by disk I/O searching for free space, just a complete lock-=
up:
I monitor the guest with 'ping', and when it happens, the ping responses st=
op
immediately and do not return, also there is no reaction to any keypress in=
 the
KVM VNC window.

--=20
With respect,
Roman

--Sig_/Qxt6WjpEZFnvYT1DZ5l0Qi0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlafFmQACgkQTLKSvz+PZwiD0gCeOC53WYFA45bOgrO8EtpMeZea
BJgAnj9rUYJsxI7ca9muULc7mG3Oil7P
=vqbu
-----END PGP SIGNATURE-----

--Sig_/Qxt6WjpEZFnvYT1DZ5l0Qi0--
