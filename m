From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Stupid newb tricks: making a subvolume of root.
Date: Fri, 11 Nov 2011 21:58:50 +0000
Message-ID: <20111111215849.GN28749@carfax.org.uk>
References: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
 <20111110145944.GK28749@carfax.org.uk>
 <68365841c0d5cfbc86aff3e90dc407eb@www.jots.org>
 <20111111191309.GM28749@carfax.org.uk>
 <31df0a0994b64649a627f735105f1511@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pjk796cY0SfIo9Z2"
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <31df0a0994b64649a627f735105f1511@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--Pjk796cY0SfIo9Z2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 11, 2011 at 04:47:17PM -0500, Ken D'Ambrosio wrote:
> On Fri, 11 Nov 2011 19:13:09 +0000 Hugo Mills <hugo@carfax.org.uk> wrote
> 
> >    I'd suggest reporting (on this mailing list) the panic message(s)
> > you got, and how you got to them. I know there's been quite a few
> > additional patches worked on since Chris pushed out the stack for
> > -rc1, so it's quite plausible that your particular problem has already
> > been fixed in someone's tree.
> 
> Hmmm.  I just pulled Chris's tree, and it seems to have done the trick.  It's
> mounting, now.  I'm being leery of outright deleting, because grub-mkconfig
> seems confused about being mounted off a different subvolume:
> grub-probe: error: cannot find a device for / (is /dev/mounted?).
> 
> (Needless to say, /dev/ *is* mounted.  Likely, I've somehow confused it with
> fstab or something.)

   I think grub has some problems with some of the btrfs features. I
don't know if we've got a decent list of issues written down yet.

> But I'm able to look at directories, cat/cp files, etc., so I now at least
> *could* blow things away.  Which is handy.

   Glad the upgrade's helped. Just make sure you've got off-machine
backups, and the will to use them, and you'll be fine. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--Pjk796cY0SfIo9Z2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOvZqZIKyzvlFcI40RAkhmAJ9YcQZvm+pZ95Tr9L/6ggQ9LMG8IgCfQIv3
+Fs5gkAjO9Dc/U8FVq4bHL0=
=KsTc
-----END PGP SIGNATURE-----

--Pjk796cY0SfIo9Z2--
