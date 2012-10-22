Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39608 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JVQFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 12:05:03 -0400
Date: Mon, 22 Oct 2012 17:05:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael <mike@draftx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID 5/6
Message-ID: <20121022160500.GZ25498@carfax.org.uk>
References: <CAGJTRch_o4SDnT+n0WnUfRysj-9T-6GmvsUrSd6XiU6C2JoEsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gX5Hm7FaHdN5aeGl"
In-Reply-To: <CAGJTRch_o4SDnT+n0WnUfRysj-9T-6GmvsUrSd6XiU6C2JoEsA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gX5Hm7FaHdN5aeGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 10:58:07AM -0500, Michael wrote:
> Does anyone know when RAID 5/6 are planned to be included in the
> Kernel?

   This is in the FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F

   Short answer: Not yet, probably soon.

> I am starting to buy parts for my next computer and would very
> much like to use BTRFS because I want a FS that can grow and also
> recover from undetected read errors - it will be large enough that
> these are possible. I'm hoping that it will be available for use in
> the coming months.

   You can switch storage types on the fly, so you could at least
start with RAID-1, and then restripe to RAID-5 (or -6) when it's
stable enough for you. This assumes that you can manage to use RAID-1
in the first place and expand later.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "There's more than one way to do it" is not a commandment. It ---  
                           is a dire warning.                            

--gX5Hm7FaHdN5aeGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIVurL9z9OVl50rAAQKNmg//W6RXdk/ku2mhhVHqDBUm3uUseLDyodMb
yzEuhq6cFjN/xqJmgf/ImiGTfuEVEOaLcy7rxX/g74UqizTG4/pLELiiOK1z7YlA
1s2kG7Al5TM6yUigw5vKlzmVFwy4FV9DN/1j7m6h33GC4+eLAJ/WAcP6XkfkRElC
HHWTjpurtML+gDdp8C6K6BqDl2l7GoT3J8A2tRFng3Qbi1pFi+CYdw8xWUSQiI0C
Cynl86MY5y/ZzJci6/fseWUqWbGq477khuVHdrIT+/V8Yun9FQtB95za35gKd7qU
I0BVwJ1eBefhJimUM1p8ixLjHgAo4s76710hBynDqQj9oL65Ktkqp05LzVN+RMKz
VP96hbGx8GfoBRLiwSnK+NDoIFOq+0mgRXCnQHi0o5JGQ91hIBsZ2wCkwLkndUQ8
dnOwu4iLg4TFojFLCJfJGaTw7UVvMUMQe9E6pqnAS64954I2gg0b2rHVoNmvwCuf
qgbiNRiIYnnwj01EYnjV9eoSPIPGv3etrowA8bO9DCwYeEogKAHVICqAsacG9M2U
6mAi37ZlF+qO7ogJO7BeTQdBQA/m3Ao9z7mvLJrKo5BfNIzLaVknXnULCynVOUsl
ksi0WIssgq34q5CGQH5MeSnJ/Py6LjADlvqdW6PVJqLlHdMdWdZI5A7KwHRZc/f4
X77FAqrjVx0=
=oXN8
-----END PGP SIGNATURE-----

--gX5Hm7FaHdN5aeGl--
