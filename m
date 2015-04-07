Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56462 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbDGQkM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 12:40:12 -0400
Date: Tue, 7 Apr 2015 16:40:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume & default subvolume
Message-ID: <20150407164010.GL13864@carfax.org.uk>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
 <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
 <20150407110354.GH13864@carfax.org.uk>
 <CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
 <20150407142030.GK13864@carfax.org.uk>
 <CAK1hC9s6ArS7-2wi-PFA9-RyTJv5T+gtHZ=U2NY-tS24UE3f6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cy9Nn4fUvYST66Pl"
In-Reply-To: <CAK1hC9s6ArS7-2wi-PFA9-RyTJv5T+gtHZ=U2NY-tS24UE3f6g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cy9Nn4fUvYST66Pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 07, 2015 at 06:31:36PM +0200, arnaud gaboury wrote:
> On Tue, Apr 7, 2015 at 4:20 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Tue, Apr 07, 2015 at 01:08:59PM +0200, arnaud gaboury wrote:
> >> On Tue, Apr 7, 2015 at 1:03 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Tue, Apr 07, 2015 at 12:58:28PM +0200, arnaud gaboury wrote:
> > [snip]
> >> >> After more reading, it seems to me creating a top root subvolume is
> >> >> the right thing to do:
> >> >> # btrfs subvolume create root
> >> >> # btrfs subvolume create root/var
> >> >> # btrfs subvolume create root/home
> >> >>
> >> >> Am I right?
> >> >
> >> >    Not how I'd recommend doing it. I'd say:
> >> >
> >> > # btrfs sub crea root
> >> > # btrfs sub crea var
> >> > # btrfs sub crea home
> >> >
> >> >    Then fstab:
> >> >
> >> > LABEL=myfs    /      btrfs    subvol=root         0 0
> >> > LABEL=myfs    /var   btrfs    subvol=var          0 0
> >> > LABEL=myfs    /home  btrfs    subvol=home         0 0
> >> >
> >> >    And finally, add this to your kernel command line in the bootloader
> >> > to specify how to mount root:
> >> >
> >> > rootflags=subvol=root
> >> >
> >> >    Hugo.
> >>
> >> Thank you Hugo. May you please tell why your recommendation is better
> >> than my settings, if I thereafter make root as the default sub-volume?
> >> I changed the root name to active and avoid any confusion:
> >
> >    Well, keeping the subvolumes separate from each other, rather than
> > nested, makes it a bit easier to do things like replace one subvolume
> > with an earlier snapshot. If you nest them, then your recovery process
> > from (say) a screwed-up / looks a bit like this:
> >
> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
> > # mv /media/btrfs/root /media/btrfs/old-root
> > # btrfs sub snap /media/btrfs/old-root/snapshots/last-root /media/btrfs/root
> > # btrfs sub snap /media/btrfs/old-root/var /media/btrfs/root/var
> > # btrfs sub snap /media/btrfs/old-root/home /media/btrfs/root/home
> > # btrfs sub set-default $n /media/btrfs
> > # umount /media/btrfs
> >
> >    If you don't nest them, and don't use set-default, then the same
> > recovery process would look like this:
> >
> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
> > # mv /media/btrfs/root /media/btrfs/old-root
> > # mv /media/btrfs/snapshots/last-root /media/btrfs/root
> > # umount /media/btrfs
> >
> >    (This also explains why I wouldn't use set-default, but instead
> > mount / using a subvol=<path> option).
> >
> >    Now, for making the snapshots in the first place, with nested
> > subvolumes, your snapshot script looks a bit like this:
> >
> > # btrfs sub snap / /snapshots/last-root
> >
> > and with the approach I'd recommend, it looks like this:
> >
> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
> > # btrfs sub snap /media/btrfs/root /media/btrfs/snapshots/last-root
> > # umount /media/btrfs
> >
> > which is a little more complex, but the approach is precisely similar
> > to the recovery process: mount the top level of the FS on
> > /media/btrfs, manipulate the subvolumes, and then unmount. This keeps
> > the management of subvolumes a completely separate concern from the
> > structure of the filesystem tree.
> >
> >    Hugo.
> 
> Thank you for all these info.
> Here is my setup now. I hope I fully understand all the hints.
> 
> $ cd /mnt/btrfs
> # btrfs subvolume create active  ---> Just in case I want to add
> another subvolumes
> # btrfs subvolume create active/rootvol
> # btrfs subvolume create active/home
> # btrfs subvolume create active/var
> # btrfs subvolume create active/etc

   One minor thing -- you've still got nested subvolumes here. You can
still run into the same kinds of management problems (not being able
to use mv efficiently to move subvolumes around). "active" doesn't
need to be a subvolume, it can (and, I'd argue, should) be an ordinary
directory.

   Hugo.

-- 
Hugo Mills             | What do you give the man who has everything?
hugo@... carfax.org.uk | Penicillin is a good start...
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--cy9Nn4fUvYST66Pl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVJAhqAAoJEFheFHXiqx3kTR8QALvGSHT9m3HsvnffooIejdi1
5kPpGkPOTBbImAZg+Z7ntmrLeZXOTwsKii3Re9185b6uNdFrEFc4XnSN+jiKlnyP
Hm6+AbACvS7AaVUC/1HDrp60MuMKwUI/Igfcy6he3ft7p2t8col1MhZwQB46WRi1
JOzlkI7nSW2qDZ7Nnq7fU6mY4jzTB/dXgId1EXvfJnXC6SuUCuiGwXwNu02JlHC2
i85BnemO6Y2CAyLMzfxA04yt/8Jp+i5mHLPfurUcNAbBhWmRBz4/8tE2UdDEEjC7
lrUJYA+r8/uoI0OOZVYUfk1vNpBFu0WZcU9ydUUMCte/hy+s6zFnJ9hVZniwzVK2
y33AHkEzs/GcVODZddFSPNjcDNAPZkdSZbOJanaJagvHMxdIQA6vZQ61+knkMIrG
rSB96YRM95l0yhEMx6Ooh01YwxzCRLXb1IhP5ydzkP7WmUigqors3tO9N/HCCAsE
1xhTovKRYzLN4gr8I994oiTN9S+gQdOCO0+BBcDRo9rACXjPMGf7AeaWKKcIUBM+
qNGI3s+PJvJqd0FODbTd22moQNVaHzk+h4lMlTC6Uy892wcPFSJNZIu6BFScTsLy
D3kMMfSOuW5mlbrYw+qVd0IQL1E4J/bya0F5IQOLQIeLBiqiQfFkWw7T+SIfWvWY
GhC4kI3ggtN61E8sLDaq
=dPUv
-----END PGP SIGNATURE-----

--cy9Nn4fUvYST66Pl--
