From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: failed disk
Date: Wed, 9 May 2012 16:33:06 +0100
Message-ID: <20120509153306.GR8938@carfax.org.uk>
References: <20120509143735.GQ8938@carfax.org.uk>
 <C8XJ9Fm9CXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kZU6r8y0YpRwyDfh"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8XJ9Fm9CXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--kZU6r8y0YpRwyDfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 05:14:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 09.05.12:
> 
> >    DUP is two copies of each block, but it allows the two copies to
> > live on the same device. It's done this because you started with a
> > single device, and you can't do RAID-1 on one device. The first bit
> > of metadata you write to it should automatically upgrade the DUP
> > chunk to RAID-1.
> 
> Ok.
> 
> Sounds familiar - have you explained that to me many months ago?

   Probably. I tend to explain this kind of thing a lot to people.

> >    As to the spurious "upgrade" of single to RAID-0, I thought Ilya
> > had stopped it doing that. What kernel version are you running?
> 
> 3.2.9, self made.

   OK, I'm pretty sure that's too old -- it will "upgrade" single to
RAID-0. You can probably turn it back to "single" using balance
filters:

# btrfs fi balance -dconvert=single /mountpoint

(You may want to write at least a little data to the FS first --
balance has some slightly odd behaviour on empty filesystems).

> I could test the message with 3.3.4, but not today (if it's only an  
> interpretation of always the same data).
> 
> >    Out of interest, why did you do the device adds separately,
> > instead of just this?
> 
> a) making the first 2 devices: I have tested both versions (one line  
> with 2 devices or 2 lines with 1 device); no big difference.
> 
> But I had tested the option "-L" (labelling) too, and that makes shit  
> for the oneliner: both devices get the same label, and then "findfs"  
> finds none of them.

   Umm... Yes, of course both devices will get the same label --
you're labelling the filesystem, not the devices. (Didn't we have this
argument some time ago?).

   I don't know what "findfs" is doing, that it can't find the
filesystem by label: you may need to run "sync" after mkfs, possibly.

> The really safe way would be: deleting this option for the "mkfs.btrfs"  
> command and only using
> 
>         btrfs fi label <device> [<newlabel>]

   ... except that it'd have to take a filesystem as parameter, not a
device (see above).

> b) third device: that's my usual test:
>         make a cluster of 2 deivces
>         fill them with data
>         add a third device
>         delete the smallest device

   What are you testing? And by "delete" do you mean "btrfs dev
delete" or "pull the cable out"?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Quidquid latine dictum sit,  altum videtur. ---           

--kZU6r8y0YpRwyDfh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqo4yIKyzvlFcI40RAiEUAJoDm1ZBhBKViK7ViX0xLb9QQbU/KwCgxlc9
t1vItGDjzn4rUTF5ZTQia4Y=
=ey6/
-----END PGP SIGNATURE-----

--kZU6r8y0YpRwyDfh--
