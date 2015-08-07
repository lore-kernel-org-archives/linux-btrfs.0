Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38695 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbbHGIL4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 04:11:56 -0400
Date: Fri, 7 Aug 2015 08:11:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
Message-ID: <20150807081149.GK14352@carfax.org.uk>
References: <55BD277F.2040201@friedels.name>
 <20150801203258.GA14352@carfax.org.uk>
 <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
 <55C3AE34.8050804@friedels.name>
 <55C40957.9040209@cn.fujitsu.com>
 <55C43F14.7080402@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uuKVzAmB+c+zQlhu"
In-Reply-To: <55C43F14.7080402@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uuKVzAmB+c+zQlhu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 07, 2015 at 07:16:04AM +0200, Hendrik Friedel wrote:
> Hello Quo,
> 
> thanks for your reply.
> 
> >> But then:
> >>root@homeserver:/mnt/__Complete_Disk# btrfs fi df /mnt/__Complete_Disk/
> >>Data, RAID5: total=3.83TiB, used=3.78TiB
> >>System, RAID5: total=32.00MiB, used=576.00KiB
> >>Metadata, RAID5: total=6.46GiB, used=4.84GiB
> >>GlobalReserve, single: total=512.00MiB, used=0.00B
> >GlobalReserve is not a chunk type, it just means a range of metadata
> >reserved for overcommiting.
> >And it's always single.
> >
> >Personally, I don't think it should be output in "fi df" command, as
> >it's in a higher level than chunk.
> >
> >At least for your case, nothing is needed to worry about.
> 
> 
> But this seems to be a RAID5 now, right?
> Well, that's what I want, but the command was:
> btrfs balance start -dprofiles=single -mprofiles=raid1
> /mnt/__Complete_Disk/
> 
> So, we would expect raid1 here, no?

   No, profiles= selects chunks of that profile. If you wanted to
change the RAID level, you should use convert=.

   Hugo.

> Greetings,
> Hendrik
> 
> 
> >>
> >>
> >>On 01.08.2015 22:44, Chris Murphy wrote:
> >>>On Sat, Aug 1, 2015 at 2:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >>>>On Sat, Aug 01, 2015 at 10:09:35PM +0200, Hendrik Friedel wrote:
> >>>>>Hello,
> >>>>>
> >>>>>I converted an array to raid5 by
> >>>>>btrfs device add /dev/sdd /mnt/new_storage
> >>>>>btrfs device add /dev/sdc /mnt/new_storage
> >>>>>btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
> >>>>>
> >>>>>The Balance went through. But now:
> >>>>>Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
> >>>>>         Total devices 3 FS bytes used 5.28TiB
> >>>>>         devid    1 size 2.73TiB used 2.57TiB path /dev/sde
> >>>>>         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
> >>>>>         devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
> >>>>>btrfs-progs v4.1.1
> >>>>>
> >>>>>Already the 2.57TiB is a bit surprising:
> >>>>>root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
> >>>>>Data, single: total=2.55TiB, used=2.55TiB
> >>>>>Data, RAID5: total=2.73TiB, used=2.72TiB
> >>>>>System, RAID5: total=32.00MiB, used=736.00KiB
> >>>>>Metadata, RAID1: total=6.00GiB, used=5.33GiB
> >>>>>Metadata, RAID5: total=3.00GiB, used=2.99GiB
> >>>>
> >>>>    Looking at the btrfs fi show output, you've probably run out of
> >>>>space during the conversion, probably due to an uneven distribution of
> >>>>the original "single" chunks.
> >>>>
> >>>>    I think I would suggest balancing the single chunks, and trying the
> >>>>conversion (of the unconverted parts) again:
> >>>>
> >>>># btrfs balance start -dprofiles=single -mprofile=raid1
> >>>>/mnt/new_storage/
> >>>># btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft
> >>>>/mnt/new_storage/
> >>>>
> >>>
> >>>Yep I bet that's it also. btrfs fi usage might be better at exposing
> >>>this case.
> >>>
> >>>
> >>
> >>
> 
> 

-- 
Hugo Mills             | There is no dark side to the Moon, really. As a
hugo@... carfax.org.uk | matter of fact, it's all dark.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            Pink Floyd

--uuKVzAmB+c+zQlhu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVxGhFAAoJEFheFHXiqx3kgYsP/1arVanNgpwwExOD85M5N494
VAhZW3V/Qt41gIHSjdIDB34oIyoCUwE5cBgyiI+6oJYhrGevZJVNlqZc5TIOoNEq
84BXXvUUClX+Cv6FCKhB3LQptAw61iXyNQJyPdOPUOmckGgCSV6hGW+tzcGlSAMl
mevIYVp97aMvzglKgAcb/WfZYb3wpiJ4I9yG5WPbKgl/VoyAc1vt4Uz+Cs8uZUzg
ggfIzdZqhc7+4HU2ujywsfv8NFCedI/UOjTEmoo/8N87VRdtJN1o1NyOM0WyVKaa
MjmqcjEUmXOZULF4hLE1Jn4kV0oua8qhqBiWpXCf91j/u/p8FwDH4OVsX3RpSu1n
fz4S2L/ytZOOo23taKyIJBvUK0DVafbAmDQB+CBa+asJHn9BT+T5Qc9baDdbeSb9
pY2fHk2LJlKhkkmkwMUIgPsHSXqpSqi5byNiBZvDT4c3KeT0ny7BI4P+Qdi7eFzm
d8Fq6dOjQB0SzORagJlJiIAhMCRXwmFq9QX+9OKGF+4Y3tE4GM6DQbcgSrrvoeho
BRGKkBxyXzizHDxanIqvxJIfd6mYb2eP4recKi+bXQnMStHoieQ6+X//4Dk5sSuJ
qa/WK+z41vsxfTvrOsQwCB9U0By7T/+8LMeDQYv7xh0F8GENEP177niV688EFk3n
yDVwI5cDtm1gDbhmyHig
=pKtu
-----END PGP SIGNATURE-----

--uuKVzAmB+c+zQlhu--
