From: Goffredo Baroncelli <kreijack@alice.it>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 19:09:56 +0200
Message-ID: <200910121909.56545.kreijack@alice.it>
References: <4A74401B.90801@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD35667.3020103@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 12 October 2009, jim owens wrote:
> P=C3=A4r Andersson wrote:
> > I just ran into the max hard link per directory limit, and remember=
ed
> > this thread. I get EMLINK when trying to create more than 311 (not =
272)
> > links in a directory, so at least the BUG() is fixed.
> >=20
> > What is the reason for the limit, and is there any chance of increa=
sing
> > it to something more reasonable as Mikhail suggested?
> >=20
> > For comparison I tried to create 200k hardlinks to the the same fil=
e in
> > the same directory on btrfs, ext4, reiserfs and xfs:
>=20
> what real-world application uses and needs this many hard links?
>=20
> jim

=46or me 311 "hard link to the same file under the same directory" limi=
t is not=20
so high.
I don't know a software which need so many hard links. But it easy to f=
ind=20
some similar cases.

=46or example under my "/usr/bin" I have 478 _"soft links"_ to _differe=
nt_=20
files.

$ find /usr/bin/ -type l | wc -l
478

When a directory is created, its ".." entry is a hard link to the "pare=
nt"=20
directory. For example the /usr/share/doc directory has 2828 "hard link=
s"=20
because it has 2826 children directories.

$ ls -ld /usr/share/doc
drwxr-xr-x 2828 root root 12288 2009-08-20 19:03 /usr/share/doc
$ ls -ld /usr/share/* | egrep "^d" | wc -l
2826

These cases are different cases. But the 311 "hard link to the same fil=
e under=20
the same directory" limit may be too strong. Not now but in the next fo=
rmat=20
change I think that it would be useful to remove this limit.

BR
Goffredo

--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinw=
ind.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
