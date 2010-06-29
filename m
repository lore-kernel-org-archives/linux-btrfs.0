From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: default subvolume abilities/restrictions
Date: Tue, 29 Jun 2010 15:20:47 +0200
Message-ID: <201006291520.47701.hka@qbs.com.pl>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost> <AANLkTinQTEhdnKLF4UKnv1eAqNpgFTwKYynDfx02itHd@mail.gmail.com> <AANLkTim2yLTkutV-SGqDwGqHyTgMJCMun9Ac-ukNJlxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim2yLTkutV-SGqDwGqHyTgMJCMun9Ac-ukNJlxg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 18 June 2010 23:01:37 C Anthony Risinger wrote:
> On Sun, Jun 13, 2010 at 12:47 PM, C Anthony Risinger <anthony@extof.m=
e>=20
wrote:
> > On Sat, Jun 12, 2010 at 8:06 PM, C Anthony Risinger <anthony@extof.=
me>=20
wrote:
> >> On Sat, Jun 12, 2010 at 7:22 PM, David Brown <btrfs@davidb.org> wr=
ote:
> >>> On Sat, Jun 12, 2010 at 06:06:23PM -0500, C Anthony Risinger wrot=
e:
> >>>>> # btrfs subvolume create new_root
> >>>>> # mv . new_root/old_root
> >>>>=20
> >>>> can i at least get confirmation that the above is possible?
> >>>=20
> >>> I've had no problem with
> >>>=20
> >>>  # btrfs subvolume snapshot . new_root
> >>>  # mkdir old_root
> >>>  # mv * old_root
> >>>  # rm -rf old_root
> >>>=20
> >>> Make sure the 'mv' fails fo move new_root, and I'd look at the
> >>> new_root before removing everything.
> >>>=20
> >>> David
> >>=20
> >> heh, yeah i as i was writing the last email i realized that all i
> >> really wanted was to:
> >>=20
> >> # mv * new_root
> >>=20
> >> for some reason i was convinced that i must snapshot the old_root =
(.)
> >> to new_root... and then remove the erroneous stuff from old_root (=
=2E).
> >> thus a way to "parent" the default subvol (old_root/.) seemed a be=
tter
> >> solution...
> >>=20
> >> but alas, a snapshot isn't necessary.  i can create an empty subvo=
l
> >> "new_root", and then "mv * new_root".
> >>=20
> >> i don't know how that escaped me :-), sorry for all the noise.
> >> however, there probably is a legitimate use case for wanting to
> >> replace the default subvolume, but this isn't it.
> >>=20
> >> C Anthony
> >=20
> > ok i take it all back, i DO need this...
> >=20
> > i rewrote my initramfs hook to do the following operations:
> >=20
> > # btrfs subvolume create /new_root
> > # mv /* /new_root
> >=20
> > instead of what i had:
> >=20
> > # btrfs subvolume snapshot / /new_root
> >=20
> > and it resulted in scarily COPYING my entire system... several gigs
> > worth... to the newly created subvolume, which took forever, and
> > grinded on my HD for awhile.  i don't know how long because i went =
to
> > bed.
> >=20
> > this is why i need a way to "parent" the default subvolume.
> >=20
> > a snapshot is nice and quick, but it leaves / full of erroneous
> > folders (dev/etc/usr/lib), an entire system, that will no longer be
> > used.  this space will in time become dead wasted space unless my
> > users manually "rm -rf" themselves.
> >=20
> > so... any input on this?  how can i effectively, and efficiently, m=
ove
> > a users installation into a dedicated subvolume, when they have
> > already installed into the default subvolume?
> >=20
> > i think the best way is what i originally suggested; make an empty
> > subvolume the new top-level subvol, and place the old top-level sub=
vol
> > INTO it with a new name.
> >=20
> > thoughts?
>=20
> can i get a little feedback on this problem?  i choke slightly when
> telling users the only way to clean their old / is by rm -rf'ing
> everything....
>=20
> i need the ability to "move" the default subvolume into a new, empty
> subvolume.  the empty subvolume then becomes the new default.
>=20
> the end result is moving the users installation into a dedicated
> subvolume, cleanly and efficiently, so the system can do other things
> with the "subroot" structure.
>=20
> the way i am doing it now is snapshotting the users / to /__active...
> however, the side effect is an entire system worth of files that will
> in time become dead space.
>=20
> moving the users install via "mv" into an empty subvol does not work.
> everything is actually copied =3D slow,slow,slow.

I don't have a btrfs file system on hand to actually try it, but did yo=
u try=20
copying using "cp --reflink=3Dalways"?

>=20
> ideas???  how can i "parent" the default subvol with an empty subvol?
> this seems a legitimate operation.

>=20
> thanks,
> C Anthony

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
