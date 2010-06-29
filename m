From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: default subvolume abilities/restrictions
Date: Tue, 29 Jun 2010 17:23:23 +0200
Message-ID: <201006291723.23939.kreijack@libero.it>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost> <AANLkTim2yLTkutV-SGqDwGqHyTgMJCMun9Ac-ukNJlxg@mail.gmail.com> <201006291520.47701.hka@qbs.com.pl>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006291520.47701.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, June 29, 2010, Hubert Kario wrote:
> On Friday 18 June 2010 23:01:37 C Anthony Risinger wrote:
> > On Sun, Jun 13, 2010 at 12:47 PM, C Anthony Risinger <anthony@extof=
=2Eme>=20
> wrote:
> > > On Sat, Jun 12, 2010 at 8:06 PM, C Anthony Risinger <anthony@exto=
f.me>=20
> wrote:
> > >> On Sat, Jun 12, 2010 at 7:22 PM, David Brown <btrfs@davidb.org> =
wrote:
> > >>> On Sat, Jun 12, 2010 at 06:06:23PM -0500, C Anthony Risinger wr=
ote:
> > >>>>> # btrfs subvolume create new_root
> > >>>>> # mv . new_root/old_root
> > >>>>=20
> > >>>> can i at least get confirmation that the above is possible?
> > >>>=20
> > >>> I've had no problem with
> > >>>=20
> > >>>  # btrfs subvolume snapshot . new_root
> > >>>  # mkdir old_root
> > >>>  # mv * old_root
> > >>>  # rm -rf old_root
> > >>>=20
> > >>> Make sure the 'mv' fails fo move new_root, and I'd look at the
> > >>> new_root before removing everything.
> > >>>=20
> > >>> David
> > >>=20
> > >> heh, yeah i as i was writing the last email i realized that all =
i
> > >> really wanted was to:
> > >>=20
> > >> # mv * new_root
> > >>=20
> > >> for some reason i was convinced that i must snapshot the old_roo=
t (.)
> > >> to new_root... and then remove the erroneous stuff from old_root=
 (.).
> > >> thus a way to "parent" the default subvol (old_root/.) seemed a =
better
> > >> solution...
> > >>=20
> > >> but alas, a snapshot isn't necessary.  i can create an empty sub=
vol
> > >> "new_root", and then "mv * new_root".
> > >>=20
> > >> i don't know how that escaped me :-), sorry for all the noise.
> > >> however, there probably is a legitimate use case for wanting to
> > >> replace the default subvolume, but this isn't it.
> > >>=20
> > >> C Anthony
> > >=20
> > > ok i take it all back, i DO need this...
> > >=20
> > > i rewrote my initramfs hook to do the following operations:
> > >=20
> > > # btrfs subvolume create /new_root
> > > # mv /* /new_root
> > >=20
> > > instead of what i had:
> > >=20
> > > # btrfs subvolume snapshot / /new_root
> > >=20
> > > and it resulted in scarily COPYING my entire system... several gi=
gs
> > > worth... to the newly created subvolume, which took forever, and
> > > grinded on my HD for awhile.  i don't know how long because i wen=
t to
> > > bed.
> > >=20
> > > this is why i need a way to "parent" the default subvolume.
> > >=20
> > > a snapshot is nice and quick, but it leaves / full of erroneous
> > > folders (dev/etc/usr/lib), an entire system, that will no longer =
be
> > > used.  this space will in time become dead wasted space unless my
> > > users manually "rm -rf" themselves.
> > >=20
> > > so... any input on this?  how can i effectively, and efficiently,=
 move
> > > a users installation into a dedicated subvolume, when they have
> > > already installed into the default subvolume?
> > >=20
> > > i think the best way is what i originally suggested; make an empt=
y
> > > subvolume the new top-level subvol, and place the old top-level s=
ubvol
> > > INTO it with a new name.
> > >=20
> > > thoughts?
> >=20
> > can i get a little feedback on this problem?  i choke slightly when
> > telling users the only way to clean their old / is by rm -rf'ing
> > everything....
> >=20
> > i need the ability to "move" the default subvolume into a new, empt=
y
> > subvolume.  the empty subvolume then becomes the new default.
> >=20
> > the end result is moving the users installation into a dedicated
> > subvolume, cleanly and efficiently, so the system can do other thin=
gs
> > with the "subroot" structure.
> >=20
> > the way i am doing it now is snapshotting the users / to /__active.=
=2E.
> > however, the side effect is an entire system worth of files that wi=
ll
> > in time become dead space.
> >=20
> > moving the users install via "mv" into an empty subvol does not wor=
k.
> > everything is actually copied =3D slow,slow,slow.
>=20
> I don't have a btrfs file system on hand to actually try it, but did =
you try=20
> copying using "cp --reflink=3Dalways"?

This should work for the files but not for the directories.

The real problem is that the "." (default) subvolume is a special case=20
subvolume. It is difficult to drop because all subvolumes depend by its=
=2E

The 'mv' command permits to move the subvolumes between subvolumes, but=
 if you=20
want to be capable to move all subvolumes, the "." (default) subvolumes=
 has to=20
be mounted.

It was created the "set-default" command to change the "default" subvol=
ume.=20
But it didn't solve all the problem.

I am not an expert of the internal of btrfs, but I am still convinced t=
hat the=20
subvolumes have to live in a different name-space, and them have to be =
mounted=20
_only_ by  "mount -o subvol=3D<name>...".

IMHO for now the best thing to do, is always create the root filesystem=
 in a=20
non-default subvolume, and use the "." (default) subvolume _only_ to ma=
nage=20
the subvolumes.

To move the default subvolume, the best thing to do it is to clone and =
then=20
remove the original file.

>=20
> >=20
> > ideas???  how can i "parent" the default subvol with an empty subvo=
l?
> > this seems a legitimate operation.
>=20
> >=20
> > thanks,
> > C Anthony
>=20



> --=20
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinw=
ind.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
