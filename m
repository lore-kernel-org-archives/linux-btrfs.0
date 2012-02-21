From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 01:13:23 +0000
Message-ID: <20120221011323.GC5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Cc: linux-btrfs@vger.kernel.org
To: tom@drdabbles.us
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 20, 2012 at 07:35:18PM -0500, Tom Cameron wrote:
> I had a 4 drive RAID10 btrfs setup that I added a fifth drive to with
> the "btrfs device add" command. Once the device was added, I used the
> balance command to distribute the data through the drives. This
> resulted in an infinite run of the btrfs tool with data moving back
> and forth across the drives over and over again. When using the "btrfs
> filesystem show" command, I could see the same pattern repeated in the
> byte counts on each of the drives.

   The balance operation should be guaranteed to complete. At least,
it does these days (back in the 2.6.35 days, it didn't always
complete). Having a repeating pattern of bytes counts isn't
necessarily a sign that it's stuck in an infinite loop. It was
probably just taking a very long time.

   If you use 3.3-rc4, and apply the restriper patches to the
userspace tools, you can use the new restriper code, which adds
(amongst many other things) a progress counter to balances.

> It would probably add more complexity to the code, but adding a check
> for loops like this may be handy. While a 5-drive RAID10 array is a
> weird configuration (I'm waiting for a case with 6 bays), it _should_
> be possible with filesystems like BTRFS.

   Indeed it should. I've not tested it yet myself, though.

> In my head, the distribution
> of data would be uneven across drives, but the duplicate and stripe
> count should be even at the end. I'd imagine it to look something like
> this:
> 
> D1: A1 B1 C1 D1
> D2: A1 B1 C1    E1
> D3: A2 B2    D1 E1
> D4: A2    C2 D2 E2
> D5:    B2 C2 D2 E2

   Yup, that's about right. Except that the empty spaces aren't there,
so it'll look more like this:

D1: A1 B1 C1 D1
D2: A1 B1 C1 E1
D3: A2 B2 D1 E1
D4: A2 C2 D2 E2
D5: B2 C2 D2 E2

> This is obviously over simplified, but the general idea is the same. I
> haven't looked into the way the "RAID"ing of objects works in BTRFS
> yet,

   See the "SysadminGuide" on the wiki[1] for a fuller explanation. I
should probably expand the example to show the case with odd numbers
of drives (and possibly with unbalanced disk sizes too).

> but because it's a filesystem and not a block-based system it
> should be smart enough to care only about the duplication and striping
> of data, and not the actual block-level or extent-level balancing.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=SysadminGuide

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'd make a joke about UDP,  but I don't know if ---         
                     anyone's actually listening...                      

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQu+zIKyzvlFcI40RAoTcAKDLMxVLQkqOYTP9w5lsysy7yzqF+ACdHuX3
4Fgfb9kEFXFnqKwj+LJNQME=
=JAoW
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
