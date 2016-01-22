Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37140 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcAVPZd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 10:25:33 -0500
Date: Fri, 22 Jan 2016 15:25:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Radek Sprta <radek.sprta@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Unmountable fs after power outage
Message-ID: <20160122152530.GX422@carfax.org.uk>
References: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
 <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9FEOsnejx470nED"
In-Reply-To: <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m9FEOsnejx470nED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 22, 2016 at 04:11:53PM +0100, Radek Sprta wrote:
> Hello everybody,
> 
> after a recent power outage attempting to mount a my btrfs partition
> fails with the following error:
> 
> mount: wrong fs type, bad option, bad superblock on /dev/sda8,
>        missing codepage or helper program, or other error
> 
> This is what dmesg shows:
> [ 1035.236081] BTRFS (device sda8): parent transid verify failed on
> 410124288 wanted 85753 found 85755
> [ 1035.240756] BTRFS (device sda8): parent transid verify failed on
> 410124288 wanted 85753 found 85755
> [ 1035.240780] BTRFS: failed to read tree root on sda8
> [ 1035.252025] BTRFS: open_ctree failed

   Try mounting with -orecovery. That's the main approach for dealing
with transid failures.

> Below is the result of btrfs check:
> Checking filesystem on /dev/sda8
> UUID: b0486700-ff9f-4979-8735-257ff1428a0d
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 311702978854 bytes used err is 0
> total csum bytes: 271057636
> total tree bytes: 1859862528
> total fs tree bytes: 1473953792
> total extent tree bytes: 72876032
> btree space waste bytes: 377740163
> file data blocks allocated: 11278336921600
>  referenced 975937630208
> btrfs-progs v4.0

   That looks reasonably promising -- nothing seriously damaged that
btrfs check could find, at least.

> I tried googling the "open_ctree failed" error, but couldn't find any
> definite answers. Here's some additional info:

   "open_ctree failed" is a really generic error message,
unfortunately. Almost every case that leads to a failure to mount will
output that message, so there's no single solution you can find from
just that error. The "parent transid verify failed" is a much better
indication of what's happened here, and the small difference in
transid numbers would indicate that -orecovery might actually have a
chance of working.

   Hugo.

> uname -a:
> Linux Computer 4.2.0-22-generic #27-Ubuntu SMP Thu Dec 17 22:57:08 UTC
> 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs fi show:
> Label: none  uuid: b0486700-ff9f-4979-8735-257ff1428a0d
> Total devices 1 FS bytes used 290.37GiB
> devid    1 size 301.32GiB used 295.04GiB path /dev/sda8
> 
> Thanks in advance for any help,
> Radek

-- 
Hugo Mills             | Always be sincere, whether you mean it or not.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |                                      Flanders & Swann
PGP: E2AB1DE4          |                                The Reluctant Cannibal

--m9FEOsnejx470nED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWoknqAAoJEFheFHXiqx3kn1AP/RNXJoVhB0aIrWcsK2zpQF9P
8zDn9QKiLvoofr9V9expA7aUYsD1XPv2xbJz61Zpdtv4uG3PwAbVy2l/q50WG+tg
fjE426G9h+VbIaeTCMw332iRvvXgJu4WLOUf0VEdCs8cu4/SoVkCToMGyQkQ6Cfp
DQUAaDHeyETstrIWYqZR7pMwPOw6Y+YOLEgA+OzQj4OstbaSsSOTVHH9wJZ3B404
6D86sndYdlnlSZiHsXl8YVhlUYC7aDhXQbHhgGWf424nGSKpHc3K3KF0UmJDR3pa
Qncj0jJWC8Qsg3nRGH8ZDuEhZDRs/aGj4XD/zWgkez03ogkK4Gl9+w8eeUEXJX3B
EJeF5kJSflJM2GXratUVp3Wz6D8Pmq97Pt8ccYubdaLN3A48vMgjmCK+ONbfxfni
9fnF9GX7vsXmecPmN7KJhPBbxB100o10AuyEsjwbruX5mGHcN6cp/X2RpydRSmuJ
we/l5SrHxKLy5J5seLYMwJbvZ2xMpLj9PAGKY3KYZgxAiwjAOVZuYy8EMgbS/DvD
SpZ5VCHt0blAokgujzMSE/VHxF3uy8aziVpsgvkU3hwYDvs4BsuUz2p19Slcfu+o
C1Ke8LRAdoNBuj1x4bTYUiEsAUOTPmtzqqPSkt3MONfoZ3PtGfUr+pql/hMT3oDi
hfYDTM26SGMrgdoE9LX9
=YbK0
-----END PGP SIGNATURE-----

--m9FEOsnejx470nED--
