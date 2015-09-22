Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43711 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbbIVL7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 07:59:15 -0400
Date: Tue, 22 Sep 2015 11:59:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS kernel error on mounted partition. Partition has errors
 detected but not repaired by btrfs-check.
Message-ID: <20150922115913.GE5918@carfax.org.uk>
References: <CAFENT7LzCRHX3p-zSrk1ECjo0JQ6=49W=Om9P-2g4x+dpAM2pw@mail.gmail.com>
 <CAFENT7KRPVkkezyddhRXcbNKVftu6VsbrioEY4JTy1FV9jOjXQ@mail.gmail.com>
 <CAFENT7L=hq8uRZ=YU2gRm9S3xfDBLx=BJuFuMuEex_PWDyWLkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
In-Reply-To: <CAFENT7L=hq8uRZ=YU2gRm9S3xfDBLx=BJuFuMuEex_PWDyWLkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 22, 2015 at 08:55:05AM -0300, Sylvain Joyeux wrote:
> Hi
> 
> Hopefully, third time's the charm ... this time I'm subscribed.
> 
> (NB: sorry if you got this twice, but it did not appear in the ML
> archives so I'm assuming it never reached the ML ...)
> 
> I am in the situation where a partition has errors, detected by
> btrfs-check but not repaired by it. Mounting the partition causes
> always the same kernel errors to be reported on dmesg.
> 
> I get these errors with a 4.2 kernel and btrfs-progs 4.2. The
> partition has been used on a mixture of 4.0.7 and 4.2 kernels (I have
> to reboot on 4.0 when I need to use the NVidia card), and I really am
> unable to pinpoint whether it happened first on 4.0 or 4.2...
> 
> I use this partition mostly as a target for btrfs send / btrfs receive
> - type backups (synchronization of snapper-based snapshotting), and
> really did nothing fancy beyond that (which, well, is in itself
> fancy). So, no big deal for now for me, I just thought that a
> non-repairable corrupted filesystems could be of interest.
> 
> Attached:
>  - the output of btrfs check. btrfs check --repair does not fix them.
>  - the dmesg output with the kernel errors

   Not attached to this email. :) Can you just put the text inline?
It's more likely to be picked up by the mail archivers, and it's
generally easier to view and comment on.

   Hugo.

> I can provide the partition image as created by btrfs-image, but it's
> 230MB in size, don't know where to put it
> 
> Note: since it was a week or so ago, I reinitialized the partition,
> and just got the exact same problem today. The only thing a bit out of
> the ordinary about this partition is that it is mounted in two
> different places, and that I have some VMs on it, and am using the
> nocow attribute on the VM files.
> 
> Regards,
> Sylvain

-- 
Hugo Mills             | "Can I offer you anything? Tea? Seedcake? Glass of
hugo@... carfax.org.uk | Amontillado?"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Mrs Gillyflower, Doctor Who

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAUKRAAoJEFheFHXiqx3kGW4P/Aoy+N69EINHFSgq85efp9pO
diTr3+7RICtCVAPJkyAJcPRbl7GtoVLzcJhvUyP+aFKYGR2tLQGump3S3BoPW1Mg
VBIRHMGjBzOvMnha1fPCBWoGvSD95xrQSEpbrVkK8pfISohsx/Vre6ntO4Zr0SqC
mzhGCqqJevFtb4T2KUB3uWfmVVRFeOgEiQwintR5l7PxmxnE2fWa3E9ZwoJUeuQP
FPGHf6dOCaApoythW5gPIkXYUBSE8WQNWP3Z949F3IkSSv+z05Wh7M8hwd8hWbHI
w/DdcBb9t5Y9mAnsNKIM7Hf3w3C78nVMEUhfO7OA4evnuJ3x15yl7jU/raCih0vF
YOa62NlgGt8on4VAw1C8tSyxA0BTkPbJn5YUfkTCQqlBHYFez4xhCoiyBzy7YE6h
g5KHc4F0dXVbeDvTv2xpax24/ElC0kGzQ3i0f8G1juYRHSEErrOu4hng1UcTsGd8
EyWbiQMDS/zYi0EYnt/R4QGijkUU5WGjx7nGlLBCQJASdo0rnTHfbgsO9eRkYmaq
hBFxs6PHdMwRjzQh5SJjFjJbCpEkICkglClU9yzba4ncgGy+U1r8RhV2EtWXaXyw
0OYycpAUHjgCSlVsN0ziz2+Z2inABY3nC3sq2Sgp9fAaMLrABR9oQ3R0c9S0dYdx
q1RpJ3U/qv0ht8d9e1lH
=rKq+
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
