Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55381 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965260AbaD2WVn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 18:21:43 -0400
Date: Tue, 29 Apr 2014 23:21:39 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Brandon Philips <brandon@ifup.co>
Cc: linux-btrfs@vger.kernel.org, Michael Marineau <mike@marineau.org>
Subject: Re: EBS volumes with identical UUIDs + btrfs
Message-ID: <20140429222139.GB24298@carfax.org.uk>
References: <CAEm7Kty8sgL850nOPUG3DGmAjJmJZuAPL-EAseRWVD=-i3_RYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
In-Reply-To: <CAEm7Kty8sgL850nOPUG3DGmAjJmJZuAPL-EAseRWVD=-i3_RYw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2014 at 02:44:08PM -0700, Brandon Philips wrote:
> Hello All-
> 
> I attached an AWS EBS volume to `xvdh` that was from a terminated EC2
> machine to another machine. The filesystem shared a btrfs UUID since
> they came from an identical install. When I mounted the new EBS volume
> to /mnt something very odd happened:
> 
> Before:
> 
> $ mount
> /dev/xvda9 on / type btrfs (rw,relatime,ssd,space_cache)
> /dev/xvda3 on /usr type ext4 (ro,relatime)
> 
> After:
> 
> # mount /dev/xvdh9 /mnt
> 
> # mount
> /dev/xvdh9 on / type btrfs (rw,relatime,ssd,space_cache)
> /dev/xvdh9 on /mnt type btrfs (rw,relatime,ssd,space_cache)
> 
> It seems that btrfs gets very confused when there are matching UUIDs
> and /mnt didn't contain the contents that I expected. To work around
> the issue I booted a non-identical machine image that had a different
> btrfs UUID and attached the backup EBS volume again and everything
> worked as expected.
> 
> What is the right way of handling this?

   The only solution that there is right now is, "don't do that".
btrfs basically assumes that if several block devices have the same
UUID in their btrfs superblocks, they're different parts of the same
filesystem. If they're actually clones of the same filesystem, then it
has problems, and can _really_ screw things up, as you've discovered.

   The closest thing to a "good" solution that's been proposed so far
is to have a tool that will scan the metadata on a block device (or a
set of block devices making up a filesystem) and rewrite the FS UUID
embedded in every metadata block. This is likely to be expensive.

   To do the conversion, you'll have to either (a) load the chunk tree
and only scan the metadata chunks, or (b) scan the whole FS for things
that look like metadata blocks and convert every block you find. In
either case, you'll have to supply exact names for the block device(s)
to convert -- preferably as a whole (particularly in case (a), where
you need all that info to find the current chunk tree).

   Option (a) is useful if you already have the clones -- but given
the behaviour of most udev installations these days, that's already
got you in a dangerous position, because udev has probably already
detected the new devices and run btrfs dev scan on them. Option (b) is
handy if you want to treat the image as a stream (e.g. dd if=/dev/sda
| btrfs fi set-uuid --stream | dd of=/dev/sdb)

   Needless to say, neither of these has actually been implemented
yet.

   Hugo.

> Attaching EBS volumes from
> snapshots or old identical machines is a common use case.
> 
> Thanks!
> 
> Brandon

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---         
                           of the precipiate.                            

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2Al81heFHXiqx3kAQKiURAAqPS0fd0YdIsNQB/N8EveY5VNVzJ0Xo/6
h5IOcB4+JTrO9nbXvUkxfF3vRB0m/Q2tEks38W0nX6jOAaqqAwMbq7CRM0YuyWYo
0/y/Cvk0Lz6Y5ukOy+kkmBTKKaJ/WOyDjH3WskbolcPecBjwEdAg+KihWmWqQd42
gwmaQuESTSx+MuO/Amyyy+DuZ0Yzk0uqDIumLVuR4RxgE+pViSvJZ5DR1UVuYP8p
SOdArr9ckHHXgqan2USGi9QcPJDQ7ZZyEpwoIgmcUwyJ5sdm/qvO8nypRjDR2xeb
X35hkBOqxCushwgZu8B3XIR4rLBM+F8CX1cu4QxVmAfJZlqhf+Ts7cPf5/ELPFo/
9gzR2SEJ0Fju4dwCHJtAi/Tyrdvt9JgtcRQGSQdldWVekQrdAhXfLb4anCFz8Hct
yloe6aXsswJVmMIAuvjhpd87Ro/fPVfaY0zWLXUbWRBYq6nY3zgM+W4VfsGzXx7h
3x182SI7Al8AsOOCqCHANq4Dc7foBZRLuKXGq8UWfm9IYx4OLGsgseZsTnoFARNl
cNSsz6SEVPqf60qTyH6XyfCs+LvnWADEkPSr8y0gdZnFFJTvqLbE3L2N3qA2HK43
T9TxCwwljV3EciSJcMXO30v1U+SsAXz4G5hCFEefrDj0Gdl2MWh3I2w1rRU+FlO6
hnVvTK/L3ks=
=RxBO
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
