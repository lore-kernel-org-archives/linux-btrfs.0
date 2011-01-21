From: Hubert Kario <hka@qbs.com.pl>
Subject: btrfs RAID1 woes and tiered storage
Date: Fri, 21 Jan 2011 09:07:54 +0100
Message-ID: <201101210907.54944.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been experimenting lately with btrfs RAID1 implementation and have=
 to say=20
that it is performing quite well, but there are few problems:

* when I purposefully damage partitions on which btrfs stores data (for=
=20
  example, by changing the case of letters) it will read the other copy=
 and=20
  return correct data. It doesn't report in dmesg this fact every time,=
 but it  =20
  does correct the one with wrong checksum
* when both copies are damaged it returns the damaged block as it is
  written(!) and only adds a warning in the dmesg with exact same wordi=
ng as=20
  with the single block corruption(!!)
* from what I could find, btrfs doesn't remember anywhere the number of=
=20
  detected and fixed corruptions

I don't know if it's the final design and while the first and last poin=
ts are=20
minor inconveniences the second one is quite major. At this time it doe=
sn't=20
prevent silent corruption from going unnoticed. I think that reading fr=
om such=20
blocks should return EIO (unless mounted nodatasum) or at least a broad=
cast=20
message noting that a corrupted block is being returned to userspace.



I've also been thinking about tiered storage (meaning 2+, not only two-=
tiered)=20
and have some ideas about it.

I think that there need to be 3 different mechanisms working together t=
o=20
achieve high performance:
* ability to store all metadata on selected volumes (probably read opti=
mised=20
  SSDs)
* ability to store all newly written data on selected volumes (write op=
timised=20
  SSDs)
* ability to differentiate between often written, often read and infreq=
uently=20
  accessed data (and based on this information, ability to move this da=
ta to=20
  fast SSDs, slow SSDs, fast RAID, slow RAID or MAID)

While the first two are rather straight-forward, the third one needs so=
me=20
explanation. I think that for this to work, we should save not only the=
 time=20
of last access to file and last change time but also few past values (I=
 think=20
that at least 8 to 16 ctimes and atimes are necessary but this will nee=
d=20
testing). I'm not sure about how and exactly when to move this data aro=
und to=20
keep the arrays balanced but a userspace daemon would be most flexible.

This solution won't work well for file systems with few very large file=
s of=20
which very few parts change often, in other words it won't be doing blo=
ck-
level tiered storage. From what I know, databases would benefit most fr=
om such=20
configuration, but then most databases can already partition tables to=20
different files based on access rate. As such, making its granularity o=
n file=20
level would make this mechanism easy to implement while still useful.

On second thought: it won't make it exactly file-level granular, if we=20
introduce snapshots in the mix, the new version can have the data regul=
arly=20
accessed while the old snapshot won't, this way the obsolete blocks can=
 be=20
moved to slow storage.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
