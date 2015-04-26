Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35809 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbbDZPc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 11:32:28 -0400
Date: Sun, 26 Apr 2015 15:32:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid0 needs mounting alternate device every boot? open_ctree
 failed (3.19.5)
Message-ID: <20150426153226.GA18187@carfax.org.uk>
References: <20150426152007.GA27173@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="crFW2+mWrWMXeHsA"
In-Reply-To: <20150426152007.GA27173@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--crFW2+mWrWMXeHsA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 26, 2015 at 08:20:07AM -0700, Marc MERLIN wrote:
> This is the weirdest thing:
> gargamel:/var/log# mount /dev/mapper/raid0d2 /mnt/btrfs_space
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d2,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> [  835.718898] BTRFS info (device dm-5): disk space caching is enabled
> [  835.778580] BTRFS: failed to read the system array on dm-5
> [  835.819223] BTRFS: open_ctree failed
> 
> gargamel:/var/log# mount /dev/mapper/raid0d1 /mnt/btrfs_space
> [  847.047607] BTRFS: device label btrfs_space devid 1 transid 40929 /dev/mapper/raid0d1
> [  847.073955] BTRFS info (device dm-4): disk space caching is enabled
> 
> The previous boot, I had to mount raid0d2 because raid0d1 didn't work.
> 
> Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
>         Total devices 2 FS bytes used 401.54GiB
>         devid    1 size 836.13GiB used 295.02GiB path /dev/mapper/raid0d1
>         devid    2 size 836.13GiB used 295.01GiB path /dev/mapper/raid0d2
> 
> Data, RAID0: total=580.00GiB, used=398.22GiB
> System, RAID1: total=8.00MiB, used=64.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=5.00GiB, used=3.08GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Those are 2 crypted disks which are already decrypted by the time I try
> to mount them, I just don't understand why btrfs fails if I mount
> one device but works with the other one, or the other way around.
> 
> Any idea what could be causing this?

   The usual reason for this is that btrfs dev scan isn't being run
properly. It's usually handled by udev -- most distributions will put
the appropriate hooks in their udev configuration if you have the
distribution's btrfs-progs package installed. If you have only a
self-built btrfs-progs from git installed, then the udev hooks
probably aren't there, and you'll need to configure it yourself (or
arrange to have btrfs dev scan run after the cryptsetup open
operation).

   Hugo.

-- 
Hugo Mills             | You can't expect a boy to be vicious until he's gone
hugo@... carfax.org.uk | to a good school.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                  Saki

--crFW2+mWrWMXeHsA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPQUKAAoJEFheFHXiqx3kT0oQAKKzPPOmmBSoNMab3sbE41Xw
0RRY6Te6+PSCJq2ZGaH6e9IR4gulyUw4HcyLWXO6KMZB+8YNkxtZfhaMLpAINNt4
qaGXV1ZWTHJbNv0oJSKFAQ84+O+jS74qtpz/+XZewzf4ypq9Z9Cflo39U6S2EiCt
hSSLZIwJhYqiqmnj1kAC+FgpO9Ks1Ub7owMtYWn7dXOXBkwe8RqFELYDJkMLPKwk
jdc2lZFVPWltp5kQ4H+TaXCD5eZS+3qSeBjRzn8Vh+/3wdsDaTcOA3rfbPpQngjv
qFvpjd4P+3KvPrDtkq26HGdzedvjR/Pn6invQCKQqPjTifAnUmlMFvtriLhfgby/
AXgogsBXPcEitpRRyAh95JZvN9+vpLXIunDK/eAt92L69a3H7W7BUj/LTqI2c9In
OEFqltFRz4sOPKSV5T53itb0FP70UzRUr11mkHXNECkjMkcDhTVdiTKvTjug7B1U
HHR0IGtcsYvRWBfH1tiBRyUI5SC3Glhq7Uq9KCnC12DuDoHh0KCDNzkMS4b2kIIF
ttBJhDTSY/Zto0XswgiZ/MdQ8yNuAhAAe6NUPnu/EhtF///xXDphK49Li7x1mvSk
v13PRJ6vhWz41QNxA6UiEMpSFHQoqmtgLZamZWRHcvAm5lxegCHb8yLrlSUynI5L
ci764hfCifj/1pfGrUr6
=iGwe
-----END PGP SIGNATURE-----

--crFW2+mWrWMXeHsA--
