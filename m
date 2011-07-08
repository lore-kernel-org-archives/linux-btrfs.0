From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: How to get the default subvolume?
Date: Fri, 8 Jul 2011 12:01:42 +0100
Message-ID: <20110708110142.GC19280@carfax.org.uk>
References: <20110708095802.GA11513@yangyi-dev.bj.intel.com>
 <20110708095802.GA19280@carfax.org.uk>
 <FC2FB65B4D919844ADE4BE3C2BB739AD6B06BC86@shsmsx501.ccr.corp.intel.com>
 <20110708101329.GB19280@carfax.org.uk>
 <FC2FB65B4D919844ADE4BE3C2BB739AD6B06BC94@shsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Yang, Yi Y" <yi.y.yang@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <FC2FB65B4D919844ADE4BE3C2BB739AD6B06BC94@shsmsx501.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 08, 2011 at 06:28:54PM +0800, Yang, Yi Y wrote:
> From your source, you defined some structures using python and use
> them to get and parse btrfs metadata, very advanced and complicated
> :-), do you know there is any library to provide similar APIs in
> order that I can use some advanced APIs and don't need to worry
> about frequent changes of btrfs superblock and other metadata.

   The fundamental btrfs data structures (which you'll find defined in
ctree.h in the btrfs-progs source, and which are mirrored in my python
code) won't change much, since they define the on-disk layout.
Changing those structures creates incompatible filesystems, which is a
Bad Thing, so it doesn't happen all that often.

   Hugo.

PS. On most development mailing lists, it's conventional to write your
replies below the text you're replying to, not above.

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Hugo Mills
> Sent: Friday, July 08, 2011 6:13 PM
> To: Yang, Yi Y
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: How to get the default subvolume?
> 
> On Fri, Jul 08, 2011 at 06:06:02PM +0800, Yang, Yi Y wrote:
> > That's great, can you share your source code with me? I'm very eager 
> > to get this now :-)
> 
>    http://carfax.org.uk/btrfs-gui
>    http://git.darksatanic.net/repo/btrfs-gui.git/
> 
>    You probably want the btrfsgui.hlp.subvol.sv_list() function.
> 
>    Hugo.
> 
> > -----Original Message-----
> > From: Hugo Mills [mailto:hugo@carfax.org.uk]
> > Sent: Friday, July 08, 2011 5:58 PM
> > To: Yang, Yi Y
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: How to get the default subvolume?
> > 
> > On Fri, Jul 08, 2011 at 05:58:02PM +0800, Yi Yang wrote:
> > > I know I can set the default subvolume for a btrfs fs using
> > > 
> > > sudo btrfs subvolume set-default 256 /btrfs/mnt
> > > 
> > > But after that, how can get the default subvolume name? In my 
> > > opinion, btrfs-progs should provide "btrfs subvolume get-default 
> > > /btrfs/mnm" to get the default subvolume id and name, I think it is 
> > > very easy to do this in btrfs-progs and btrfs kernel space.
> > 
> >    I don't think the current btrfs-progs will do it. As you pointed 
> > out though, it's pretty easy to write the code to get the information 
> > (I implemented it for btrfs-gui without any additional kernel code, 
> > for example). We just need someone to implement it. :)
> > 
> >    I'd do it myself, but there's about a dozen things higher up my priority list right now.
> > 
> >    Hugo.
> > 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- vi: The core of evil. ---                      

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOFuOWIKyzvlFcI40RAstIAKCi0g88Q33asPPY3uXAMGUspRhkcgCbBymD
s3iJAY2iV2EcaDBKvLtoGaU=
=dLmS
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
