From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 0/3] Show Chunks by position
Date: Wed, 23 Nov 2011 12:34:08 +0000
Message-ID: <20111123123408.GF28749@carfax.org.uk>
References: <4EC67EAE.2090602@cfl.rr.com>
 <4ECC488B.7010406@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJKxYQkVikLexIKR"
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECC488B.7010406@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


--KJKxYQkVikLexIKR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 22, 2011 at 08:12:43PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2011 10:50 AM, Phillip Susi wrote:
> > This is a nice little tool.  The one suggestion that I have is that
> > it display the actual chunks and where they are located.  It seems
> > that right now it uses the same ioctl that btrfs fi df uses, and that
> > just gets the total combined size for all chunks of a given type.  It
> > would be nice if the gui actually parsed the chunk tree and showed
> > each individual chunk with lines showing how they are mapped to the
> > physical disks.
> 
> I managed to cobble together the following patches to implement this.
> The one thing that I still don't like is that the radio knob is in the
> data replication and allocation box, instead of the volumes box.  My
> python and tkinter skills are too lacking to figure out how to move it
> down there.

   Thanks for this. I hope I'll have time to look at it next week.

   Hugo.

> 
> Phillip Susi (3):
>   Changed volume_df() to return all chunks with their offsets
>   Update UsageDisplay to be capable of displaying all chunks by
>     position
>   Add radio knob to show space by position or combined
> 
>  btrfsgui/gui/usagedisplay.py |   98
> ++++++++++++++++++++++++++++--------------
>  btrfsgui/hlp/size.py         |   18 +++----
>  2 files changed, 73 insertions(+), 43 deletions(-)
> 
> - -- 
> 1.7.5.4
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iEYEARECAAYFAk7MSIoACgkQJ4UciIs+XuLyjQCeI4m7+u75R863B2RY3hkFELbP
> iJ8AoJwzVdiYZqgE1tXvHEOHz+gciDgj
> =dfd1
> -----END PGP SIGNATURE-----

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The English language has the mot juste for every occasion. ---    

--KJKxYQkVikLexIKR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOzOhAIKyzvlFcI40RAmhNAKCJ352B1NVf3dLdSkAqQvLod/DdqwCeJR58
rSIjAkimpT5oVzg1UnZjFBs=
=LQ41
-----END PGP SIGNATURE-----

--KJKxYQkVikLexIKR--
