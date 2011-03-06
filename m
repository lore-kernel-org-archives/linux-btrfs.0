From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Recovering "parent transid verify failed"
Date: Sun, 6 Mar 2011 11:02:57 +0000
Message-ID: <20110306110257.GF4084@carfax.org.uk>
References: <AANLkTik2t4bG_vwveO=5dovOE=6gDH5FKzjANs7cgRWY@mail.gmail.com>
 <AANLkTik8z13+5pKThfCSsTeM_08VDCQiKvHD2GEQLqGb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Cc: linux-btrfs@vger.kernel.org
To: Yo'av Moshe <bjesus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik8z13+5pKThfCSsTeM_08VDCQiKvHD2GEQLqGb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 06, 2011 at 12:28:41PM +0200, Yo'av Moshe wrote:
> Hey,
> I'd start by saying that I know Btrfs is a still experimental, and so
> there's no guarantee that one would be able to help me at all... But I
> thought I'll try anyway :-)
> 
> Few months ago I bought a new laptop and installed ArchLinux on it,
> with Btrfs on the root filesystem... I know, it's not the smartest
> thing to do...
> After a few month I had issues with my hibernations scripts, and one
> day I tried to hibernate my computer but it didn't go that well, and,
> well, ever since then my Btrfs partition is not accessible.
> I opened up the Btrfs FAQ and saw that the fsck tool should be out by
> the end of 2010, and thought "oh well, I could wait until then", and
> went on and installed Ubuntu with Ext4 on another small partition.
> 
> But times goes one and the fsck tool is still in development... I've
> tried using the code from GIT and it didn't work, and I'm starting to
> wonder (a) if there's any hope at all and (b) what other step am I
> able to do to recover my old Btrfs partition.

   Yes, there is hope. This error should be fixable with the new fsck.

> When trying to mount the Btrfs parition I get this in dmesg:
> [105252.779080] device fsid d14e78a602757297-bf762d859b406ca9 devid 1
> transid 135714 /dev/sda4
> [105252.818697] parent transid verify failed on 216925220864 wanted
> 135714 found 135713
[snip]
> Should I wait for btrfsck to be ready?

   Yes.

> Am I not using it correctly now?

   No, there's not a lot the current version can do right now.

> Is there anyway to recover this partition or should I just wipe it and
> reinstall Btrfs only when I'm supposed to?..
> 
> Your help is appreciated.

   HTH,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNc2nhIKyzvlFcI40RAsq2AKCrSZE6nXYIRbxfLThwIH/yEeO/iACggwHZ
vXj/K5R746xiMj8x6Ehdzbs=
=zinf
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
