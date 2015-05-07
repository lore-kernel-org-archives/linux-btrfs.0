Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52698 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbEGJEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 05:04:53 -0400
Date: Thu, 7 May 2015 09:04:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: strange behavior btrfs copy
Message-ID: <20150507090451.GM18480@carfax.org.uk>
References: <loom.20150507T103552-598@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YIwHDYD8sUXtBKvt"
In-Reply-To: <loom.20150507T103552-598@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YIwHDYD8sUXtBKvt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 07, 2015 at 08:44:35AM +0000, sri wrote:
> Hi,
> 
> I have a btrfs file system /b1 on /dev/sdb with 2 subvolumes and 2 
> snapshots of them.
> 
> I have written a code which takes 2 disks as input source: /dev/sdb and 
> destination as /dev/sdc and copies entire disk in 512 byte chunks to 
> desination /dev/sdc.

   Don't do that. Really.

   What you end up with is two devices containing the same filesystem,
*with the same UUID*. What then happens is that udev is likely to read
the newly-modified device, and identify it as a btrfs filesystem. That
then triggers a run of btrfs dev scan, which tells the kernel that
/dev/sdb and /dev/sdc are part of the same filesystem (because they
have the same UUID). When one (or, worse, both) of these are mounted,
you get undefined behaviour, because it's treating both devices as
part of the same FS.

> my source btrfs /dev/sdb is mounted /b1 currently and mount command show 
> the same.
> 
> I ran above program and it is successful. and now everything in /dev/sdb 
> is copied to /dev/sdc
> 
> but after this when I run mount command at CLI, i am seeing strange 
> behaviour and output show /dev/sdc is mounted on /b1.
> 
> Some how it changes device from /dev/sdb to /dev/sdc on the fliy.

   Yes, because it's the same filesystem according to the kernel.

> I also tried to cd to /b1 (which make /b1 is in use) and ran same 
> program, still after copy from /dev/sdb to /dev/sdc, mount shows 
> /dev/sdc is mounted on /b1
> 
> 
> what could be the reason for this?
> 
> does btrfs do any polling or something?

   It's udev that does the "polling" that triggers the rescan that
gives the kernel correct but inconsistent (and inconvenient for you)
information.

> since /dev/sdb and /dev/sdc contains same data, i can mount /dev/sdc 
> independently.

   Well, you can't, because they're the same filesystem according to
the kernel...

   Qu Wenruo posted a patch set recently (Tuesday) that gives the
capability of changing the UUID of a btrfs filesystem. If you really
must do this copying, that's probably what you need. You will probably
also have to turn off udev while the copy and UUID-changing is going
on.

   Hugo.

-- 
Hugo Mills             | vi: The core of evil.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--YIwHDYD8sUXtBKvt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVSyqzAAoJEFheFHXiqx3kYykP/RzFR/Jotqo62RVQyQFweWVN
dXygzzZ0xsYwrpvKfYhEZAbJr6QUZJbHKuEDneXTbXhyutPATnMEFVCVyBIaNNcq
npKzn+eMrXFghitjPIgXl4atkFNGlhiKMgt+Pvl0PVJqQ+lferVVUG+GIbaXJFqS
J+lzHe9flQnuK1pJWmcOEW2NOT9lBIQreNbdeRw+K6vXpQUw4oMdnTnMY9v8s3S9
ewBCT4T9lBjB+5/8C431Ns3YxcpBR4vLcL8N6Tg0WpcSJ2syoRy5JFbn3h0k5mV1
d7cjco/jhWLxi5GgD7HEQmIVaCdiGcFZzcVEKSLHurBm5FehTzKPGRv/srHpRAvH
OqSgDWsZXMGSny+hGsj9arqe3p9F414pbTcYmvhdP+GU0jtPtl1iapmgpwlSWgDy
YN9sCzkKIxa4WGQY+u9/SdvIqx+M7GFupEgFN3azj6jYQXmzj0qndwZzYS9f5WAg
0NrYBQ49Je234uoAP8KjitABfBDyPYcfzgRmGM2As2fn4RYQAExT72h+m+7sUOzM
NBWy5zvttB3BpqUfR70OeT19vJegr8xIKJ29i9+Qq4VjQAjkCZMGqZqLgLkVZRtM
57Vn5JxJdelzoccND2dvhOOdmF4cbsqAymAvEHTuiuYrgucZ7lfhciqy0bZnKY6h
OnZNP6ksOk3ra+trpnch
=qN6c
-----END PGP SIGNATURE-----

--YIwHDYD8sUXtBKvt--
