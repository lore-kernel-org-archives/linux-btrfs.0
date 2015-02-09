Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59870 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbbBIJPN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 04:15:13 -0500
Date: Mon, 9 Feb 2015 09:15:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209091510.GJ28427@carfax.org.uk>
References: <54D842FD.1010806@virtualcomplete.com>
 <20150209114023.137402bf@natsu>
 <20150209083941.GI28427@carfax.org.uk>
 <20150209141221.099d4fe5@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dpynvXbW/eW9Tpc3"
In-Reply-To: <20150209141221.099d4fe5@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dpynvXbW/eW9Tpc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2015 at 02:12:21PM +0500, Roman Mamedov wrote:
> On Mon, 9 Feb 2015 08:39:41 +0000
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > > I use KVM (QEMU) with discard pass-through from the VM guest ("discard=unmap"
> > > option), with the VM images stored on Btrfs. It works just fine, the disk
> > > space used for the image file does shrink when the guest OS issues discards on
> > > its FS. Maybe there is a difference in how KVM and the 'loop' module submit
> > > discards to Btrfs?
> > 
> >    This is interesting, because I've tried exactly that setup (KVM,
> > discard=unmap) and it's not worked for me.
> 
> Did you use the emulated IDE interface in KVM? Others such as virtio, ahci and
> maybe SCSI may not support discard. Did you get a successful result issuing
> TRIM within the guest (e.g. fstrim -v / succeeds and doesn't -ENOSUPP)?

   I used SCSI, so maybe that's the problem. I'll try with IDE.

   Hugo.

-- 
Hugo Mills             | I was cursed with poetry very young. It creates
hugo@... carfax.org.uk | unrealistic expectations.
http://carfax.org.uk/  |                                   Victor Frankenstein
PGP: 65E74AC0          |                                        Penny Dreadful

--dpynvXbW/eW9Tpc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU2HqeAAoJEFheFHXiqx3kffQQAKYk6YgERPK/T6UuDKVZjZbH
qa3mHQTXbTTy/6FjwetEHAt8LBjads4ZlkH7yMKIk2GpjC87CqSPD/ALje/3anmK
M8A4dzrfedYqqAesvNlaZozBuA+aTcq0e9nNgeId359QDGaSYnLuwdKnY9j4718G
Ash5NUB3Mhx/KdR/NDXI+yv0IW1mtE/UgTRtOc4H4TFFAMEifA8oJwTgJPiIH1/7
fKdfGi6Wa4Hu6QDy7j6ub1RI3SabbIggR1wm0nw+/tQzIwYhefozLKnYlSgsp4GN
Y4ms0CzQoailwZN85VmaA5e0t7khx52DbVBuog0Wo7mjtCtMqSo29GcXlNzn4HG0
Jdgnk4mq9qAMwfWOWLv4XSW7S0iwrP9XyxP2a3bYNuka1Eh4jI5KxL+b9kJFeL+4
AabUH0uIf8etr9AGGO5cYioWheBV4ZFOsDQL6L4olodgCvpDU40CF5RSSjxvoXNy
wstAZ/9VXsQWMgQPHsb9O6SlLLgbMkSu2NXad+NmLeKUnKlssYda6W9KcI+qKOAL
uSSi46Pc3YvqaOv11tRqJV/Vg5BjmqDXxKSmpgmliL56g8wjBOPshINiZvYDPRji
OPUqMz2G+oJKkivBWTC7n6hXquUbjCHLhagMUEiNupTSpKajPOZukDfkYtoXqzm3
S9bCChA+nY24HG5JC9xa
=Tf7J
-----END PGP SIGNATURE-----

--dpynvXbW/eW9Tpc3--
