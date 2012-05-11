From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Fri, 11 May 2012 18:58:05 +0200
Message-ID: <201205111858.05972.Martin@lichtvoll.de>
References: <4FAAE94D.4010103@pocock.com.au> <pan.2012.05.11.02.18.22@cox.net> (sfid-20120511_112519_774381_10A0F835)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.05.11.02.18.22@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 11. Mai 2012 schrieb Duncan:
> Daniel Pocock posted on Wed, 09 May 2012 22:01:49 +0000 as excerpted:
> > There is various information about
> > - enterprise-class drives (either SAS or just enterprise SATA)
> > - the SCSI/SAS protocols themselves vs SATA having more advanced
> > features (e.g. for dealing with error conditions)
> > than the average block device
>=20
> This isn't a direct answer to that, but expressing a bit of concern
> over  the implications of your question, that you're planning on usin=
g
> btrfs in an enterprise class installation.
>=20
> While various Enterprise Linux distributions do now officially
> "support"  btrfs, it's worth checking out exactly what that means in
> practice.
>=20
> Meanwhile, in mainline Linux kernel terms, btrfs remains very much an=
=20
> experimental filesystem, as expressed by the kernel config option tha=
t=20
> turns btrfs on.  It's still under very intensive development, with an=
=20
> error-fixing btrfsck only recently available and still coming with it=
s=20
> own "may make the problems worse instead of fixing them" warning. =20
> Testers willing to risk the chance of data loss implied by that=20
> "experimental filesystem" label should be running the latest stable=20
> kernel at the oldest, and preferably the rcs by rc5 or so, as new
> kernels  continue to fix problems in older btrfs code as well as
> introduce new features and if you're running an older kernel, that
> means you're running a kernel with known problems that are fixed in
> the latest kernel.
>=20
> Experimental also has implications in terms of backups.  A good
> sysadmin  always has backups, but normally, the working copy can be
> considered the primary copy, and there's backups of that.  On an
> experimental filesystem under as intense continued development as
> btrfs, by contrast, it's best to consider your btrfs copy an extra
> "throwaway" copy only intended for testing.  You still have your
> primary copy, along with all the usual backups, on something less
> experimental, since you never know when/where/ how your btrfs testing
> will screw up its copy.

Duncan, did you actually test BTRFS? Theory can=C2=B4t replace real lif=
e=20
experience.

=46rom all of my personal BTRFS installations not one has gone corrupt =
- and=20
I have at least four, while more of them are in use at my employer. Exc=
ept=20
maybe a scratch data BRTFS RAID 0 over lots of SATA disks. But maybe it=
=20
would have been fixable by btrfs-zero-log which I didn=C2=B4t know of b=
ack then.=20
Another one needed a btrfs-zero-log, but that was quite some time ago.

Some of the installations are in use for more than a year AFAIR.

While I would still be reluctant with deploying BTRFS for a customer fo=
r=20
critical data and I think Oracle=C2=B4s and SUSE=C2=B4s move to support=
 it officially=20
is a bit daring, I don=C2=B4t think BTRFS is in a "throwaway copy" stat=
e=20
anymore.

As usual regular backups are important=E2=80=A6

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
