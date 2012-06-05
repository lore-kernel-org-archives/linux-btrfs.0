Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51880 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FERSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 13:18:22 -0400
Date: Tue, 5 Jun 2012 18:18:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim <jim@webstarts.com>
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: delete disk proceedure
Message-ID: <20120605171819.GK15986@carfax.org.uk>
References: <4FCE19D3.4090908@webstarts.com>
 <CAIin7n9CXB@helmut.hullen.de>
 <20120605170420.GJ15986@carfax.org.uk>
 <4FCE3DF1.2050106@webstarts.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aqWxf8ydqYKP8htK"
In-Reply-To: <4FCE3DF1.2050106@webstarts.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aqWxf8ydqYKP8htK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 01:12:17PM -0400, Jim wrote:
> [sorry for the resend, signature again]
> I am waiting for a window (later tonight) when I can try mounting
> the btrfs export.  Am I reading you guys correctly, that you think I
> should be deleting drives from the array?  Or is this a just in
> case?  Thanks.

   Try the modified exports as I suggested in the other part of the
thread first. If that turns out to be problematic still, then we can
discuss any migration strategies.

   Hugo.

> Jim Maloney
> 
> On 06/05/2012 01:04 PM, Hugo Mills wrote:
> >On Tue, Jun 05, 2012 at 06:19:00PM +0200, Helmut Hullen wrote:
> >>Hallo, Jim,
> >>
> >>Du meintest am 05.06.12:
> >>
> >>>/dev/sda               11T  4.9T  6.0T  46% /btrfs
> >>>[root@advanced ~]# btrfs fi show
> >>>failed to read /dev/sr0
> >>>Label: none  uuid: c21f1221-a224-4ba4-92e5-cdea0fa6d0f9
> >>>          Total devices 12 FS bytes used 4.76TB
> >>>          devid    6 size 930.99GB used 429.32GB path /dev/sdf
> >>>          devid    5 size 930.99GB used 429.32GB path /dev/sde
> >>>          devid    8 size 930.99GB used 429.32GB path /dev/sdh
> >>>          devid    9 size 930.99GB used 429.32GB path /dev/sdi
> >>>          devid    4 size 930.99GB used 429.32GB path /dev/sdd
> >>>          devid    3 size 930.99GB used 429.32GB path /dev/sdc
> >>>          devid   11 size 930.99GB used 429.08GB path /dev/sdk
> >>>          devid    2 size 930.99GB used 429.32GB path /dev/sdb
> >>>          devid   10 size 930.99GB used 429.32GB path /dev/sdj
> >>>          devid   12 size 930.99GB used 429.33GB path /dev/sdl
> >>>          devid    7 size 930.99GB used 429.32GB path /dev/sdg
> >>>          devid    1 size 930.99GB used 429.09GB path /dev/sda
> >>>Btrfs v0.19-35-g1b444cd
> >>>df -h and btrfs fi show seem to be in good size agreement.  Btrfs was
> >>>created as raid1 metadata and raid0 data.  I would like to delete the
> >>>last 4 drives leaving 7T of space to hold 4.9T of data.  My plan
> >>>would be to remove /dev/sdi, j, k, l one at a time.  After all are
> >>>deleted run "btrfs fi balance /btrfs".
> >>I'd prefer
> >>
> >>         btrfs device delete /dev/sdi
> >>         btrfs filesystem balance /btrfs
> >>         btrfs device delete /dev/sdj
> >>         btrfs filesystem balance /btrfs
> >>
> >>etc. - after every "delete" its "balance" run.
> >    That's not necessary. Delete will move the blocks from the device
> >being removed into spare space on the other devices. The balance is
> >unnecessary. (In fact, delete and balance share quite a lot of code)
> >
> >>That may take a lot of hours - I use the last lines of "dmesg" to
> >>extrapolate the needed time (btrfs produces a message about every
> >>minute).
> >>
> >>And you can't use the console from where you have started the "balance"
> >>command. Therefore I wrap this command:
> >>
> >>       echo 'btrfs filesystem balance /btrfs' | at now
> >    ... or just put it into the background with "btrfs bal start
> >/mountpoint&". You know, like everyone else does. :)
> >
> >    Hugo.
> >
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Quantum est ille canis in fenestra? ---               

--aqWxf8ydqYKP8htK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPzj9bIKyzvlFcI40RAvmqAJ9MZXclpwbvDWDTNStV5V/3gZFV3ACglS4u
dxbxfNjSnbZV3YyU9K8G4q4=
=WIwk
-----END PGP SIGNATURE-----

--aqWxf8ydqYKP8htK--
