Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42396 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab3BBSCm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 13:02:42 -0500
Date: Sat, 2 Feb 2013 18:02:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Atri Sharma <atri.jiit@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Newbie help-- Making BTRFS partition
Message-ID: <20130202180239.GT16285@carfax.org.uk>
References: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
 <20130202161959.GS16285@carfax.org.uk>
 <CAOeZVicJEMg6OmDdkV5_Ti8==527bsH+VDbKkrgQe+Myyg4_gg@mail.gmail.com>
 <CAOeZVicg6FNj_+nyQZzrrRs3CBmKaYbb5+fgCGdVf0U=M=49wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o6aug3O60clXg2rj"
In-Reply-To: <CAOeZVicg6FNj_+nyQZzrrRs3CBmKaYbb5+fgCGdVf0U=M=49wQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--o6aug3O60clXg2rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 02, 2013 at 11:06:23PM +0530, Atri Sharma wrote:
> Hi Hugo,
> 
> Thanks for the earlier help.
> 
> I needed some more help please.
> 
> I created a BTRFS partition on /dev/sda3. To verify, the output of df
> -T command:
> 
> e
> /dev/sda1                         fuseblk     102396   25180     77216
>  25% /run/media/atri/System Reserved
> /dev/sda3                         btrfs    331637760     120 317977536
>   1% /run/media/atri/02fad498-f636-410e-a4bf-4d91428b9106
> 
> 
> After this, I am trying to create a folder on the partition. How do I do that?

   Well, a folder (aka a directory) is created with mkdir. But...

> I tried :
> 
> [atri@AtriServer ~]$ sudo btrfs subvolume create /dev/sda3/
> Create subvolume '/dev/sda3'
> ERROR: cannot create subvolume - Inappropriate ioctl for device

   ... you're trying to create a subvolume here, so I'll assume that's
what you want.

   If you take a look at the output of "btrfs --help", you'll see that
most of the commands take a path, not a device. This is usually the
location of some file or directory, and in most cases should be a
mount point of (some subvolume within) the filesystem.

   In this case, what you want to do is create the subvolume with, for
example:

sudo btrfs subvolume create /run/media/atri/02fad498-f636-410e-a4bf-4d91428b9106/subvolumename

because the filesystem is mounted at
/run/media/atri/02fad498-f636-410e-a4bf-4d91428b9106/, so you need to
specify a path below that to create any subvolumes in it. (I'd
recommend mounting your filesystem somewhere with a slightly shorter
name).

   Once you've created the subvolume, it'll look like a directory, but
it can also be mounted independently of the rest of the filesystem.

   Hugo.

> Please help.
> 
> Atri
> 
> On Sat, Feb 2, 2013 at 9:56 PM, Atri Sharma <atri.jiit@gmail.com> wrote:
> > Hi Hugo,
> >
> > Thanks.
> >  I was having some issues with my priviledges, and sorting them out has worked.
> >
> > Thanks a ton,
> >
> > Atri
> >
> > On Sat, Feb 2, 2013 at 9:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> On Sat, Feb 02, 2013 at 08:56:20PM +0530, Atri Sharma wrote:
> >>> Hi all,
> >>>
> >>> I am running a Fedora 17 system. I am trying to set up a new partition
> >>> of 2 GB size which has BTRFS as file system.
> >>>
> >>> When I am trying to do mkfs.btrfs on a partition, I get:
> >>>
> >>> [atri@AtriServer ~]$ mkfs.btrfs /dev/sda3
> >>>
> >>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> >>> WARNING! - see http://btrfs.wiki.kernel.org before using
> >>>
> >>> check_mounted(): Could not open /dev/sda3
> >>> error checking /dev/sda3 mount status
> >>
> >>    You need to be root, or (typically) to be in the "disk" group in
> >> order to write to a block device.
> >>
> >>    Hugo.
> >>
> >> --
> >> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
> >>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
> >>   --- "What's so bad about being drunk?" "You ask a glass of water" ---
> >>
> >
> >
> >
> > --
> > Regards,
> >
> > Atri
> > l'apprenant
> 
> 
> 
> -- 
> Regards,
> 
> Atri
> l'apprenant
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- We don't just borrow words;  on occasion, English has pursued ---  
         other languages down alleyways to beat them unconscious         
               and rifle their pockets for new vocabulary.               

--o6aug3O60clXg2rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQ1Uv79z9OVl50rAAQJH1hAAlfJCi2vi0/Bc+cATr2lb5IMGW24AuHA+
lj5LyKGegotm+0WIDXVJdeSmKXyvEfUrbZrhBX6Dislx6XVAocGQaOL+47jgxSWV
l1txzT1RZTT1TKmdsl0VWrXmdnefgx6JvKYROc5E+8olaNm0+IJmtblTy9Q9CplL
wOuwQfXIHF5+GqV5RXlBFPbMheVgWUanY2YAcrMB/rd7yJYh31ordZQJwvVM1744
B5NSDacYjWFxvsKsDzBXRo5bxEt2B9sF15vKgT8rTWn40TpQQcCmq4/UgSpJPPIx
LQvAQbKHeSBiuvrFdmwM624pj1Gpu8OApn1pFJaa5X9DbAFpwLUAWLayp70PVTCO
WP3p9xljMNkIyElEmRbdBtydv7hJ+EwmW48Gjg4E2GBOl14tKk7IkA8CzGYPH1Pv
ILSnw1XAZIBEeepjPMe2gcn4RfgQBfP3ITUVmUR7PkTl+jvo6OCOfnpwG7OlGMvC
TjmPkuIorTaNZnHw454OPUZmRY+iGnT8ZWS20MS7P7EGd3HAXSYzOY6Mi/H/BEYd
WkGpwJfwAyvarHgcF446t53DXk5Rny9e+m8rMHRLQsHs/foQYhGouPT72Dl6a2LO
+yfV/V21I7c9CIS1UIkQGw2RRLaLz09N1ZsGdvXpwVRoqrAf+TALJnGCXqJzdiud
4utY37GxqMQ=
=mVtc
-----END PGP SIGNATURE-----

--o6aug3O60clXg2rj--
