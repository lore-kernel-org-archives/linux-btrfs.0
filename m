Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52246 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbbHCP2i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 11:28:38 -0400
Date: Mon, 3 Aug 2015 15:28:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sonic <sonicsmith@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
Message-ID: <20150803152835.GF14352@carfax.org.uk>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
 <pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
 <CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
 <CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
In-Reply-To: <CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 03, 2015 at 11:05:46AM -0400, Sonic wrote:
> On Mon, Aug 3, 2015 at 10:43 AM, Sonic <sonicsmith@gmail.com> wrote:
> > Is "btrfs rescue super-recover" safe to run? IOW, will it ask before
> > doing anything possibly destructive (assuming I don't give it a -y)?
> 
> Seemed a bit safe so I went for it and:
> 
> sartre ~ # btrfs rescue super-recover /dev/sdc
> All supers are valid, no need to recover
> sartre ~ # btrfs rescue super-recover /dev/sde
> All supers are valid, no need to recover
> 
> So it may not be a superblock issue.
> 
> From the dmesg earlier:
> [ 3421.193734] BTRFS (device sde): bad tree block start
> 8330001001141004672 20971520
> [ 3421.193738] BTRFS: failed to read chunk root on sde
> [ 3421.203221] BTRFS: open_ctree failed
> 
> I may need a chunk-recover and also wonder if zero-log is advisable.
> Any ideas in those directions?

   Very unlikely and definitely not, respectively. There's nothing at
all here to indicate that you've got a broken log, so dropping it
would be at best pointless. The chunk tree is also most likely
undamaged on both copies.

   Hugo.

-- 
Hugo Mills             | The early bird gets the worm, but the second mouse
hugo@... carfax.org.uk | gets the cheese.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVv4iiAAoJEFheFHXiqx3kfkAP/0cyRh9x4wwiClkgkswbI/nr
0TNpuNdPFLQnh9wp5L8MbN0zR2N5M7Bc3z4mdph5zISErCKGp+OIpGKXE8AwDTDV
IYYamaMWeZOgT646YEyHHNS5WzK7L7Zd4eWM/O8Cxj3yt3L2y0i01GDHcUCahXGe
gNgeoyE9quUauhDwdXI+RlbDkRShO6Ok8exOatf3tdmncoyXLguhYakTTkRtLC3e
TQuLx4P5hgcj3ZBWTAgqhVwFB58FLTuQ5G6sEDsHB9H0StSxggYBp0ILkPForw4Q
b3LsJ0+axKAQsDamPJyZtX2ITPdqmZGh++i91B48j3zRiF5IrB5jpLcfcn6wfqzm
VjrXWxctSzUFaTUo04XLywQJVzRBoL8nuOKG5jqIScP5onsk4UZpa6Gy9/yOWG6a
RsW3t51Xaa8smcGJVRDEmJFHlH/UhYYx3KYFZj5eYiScAZEDzRoLZj3xycq6U8qt
jV4NExU9JLO+2umMVw+crIOygQ+Jji49HtGEmMS/XnixiOj3YfobK83K2qhCPEpX
I1xES8dQLE8iM8O5SbGv8uMH8uMbTGdR4cLT2OJbxvQVe/S+Hlw38yjm6Hlc1P8i
tb+HbOeYkLtO8RqY6e7iUgiXBlygB+7gPIn2qYjcRzVBlnqhDxDTtMybdUaBs4QU
3KwRKsz9LOQzegrrgPkM
=nrSA
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
