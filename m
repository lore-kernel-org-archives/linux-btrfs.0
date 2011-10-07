From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Date: Fri, 7 Oct 2011 16:21:37 +0100
Message-ID: <20111007152137.GE28351@carfax.org.uk>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	lennart@poettering.net, harald@redhat.com, david@fubar.dk,
	greg@kroah.com, Chris Mason <chris.mason@oracle.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 07, 2011 at 02:46:23PM +0200, Kay Sievers wrote:
> On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> >> What do you mean would be ugly?
> >
> > I have an ext4fs. It supports every possible file name allowed by POSIX
> > and SuS. What name are you going to use for your 'hidden directory' that
> > won't clash with a real file ?
> 
> Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
> root dir list, not a real file in the root dir.
> 
> We need kernel support for changing a mounted fs, because, unlike
> ext4, the blocks containing the strings are inside the fs, which the
> kernel might change any time.

   It's worth noting that there are similar issues with btrfs around
changing label. A common API for it would make sense. The only btrfs
patches I've seen to change label after mkfs-time work either as:

 * unmounted only, single underlying device only, pure userspace
   implementation
 * mounted only, multiple underlying devices, kernel support needed

   The kernel-side patches never got integrated, so we're still unable
to change the label on the majority of btrfs filesystems.

   Changing the UUID for the filesystem is even harder, as I think
it's written to every metadata block. I'm not sure we can do that
sanely on a mounted filesystem.

   Hugo (just a spear-carrier from the btrfs chorus).

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---    
                       course,  in a state of sin.                       

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOjxkBIKyzvlFcI40RAgIDAJ4vnYgjZebmA0wpEQzy1qi44MwNZQCghJ5b
41HHyafRYZchbGY+XaFpOjc=
=0xMq
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
