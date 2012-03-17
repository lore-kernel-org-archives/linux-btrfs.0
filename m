From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 17 Mar 2012 10:43:25 +0100
Message-ID: <201203171043.25660.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <20120315174245.GV19217@shiny> <201203161605.47792.Martin@lichtvoll.de> (sfid-20120316_160919_841295_64D691DA)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>, stable@kernel.org,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203161605.47792.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Greg, Chris, Arne, hi everyone,

Am Freitag, 16. M=C3=A4rz 2012 schrieb Martin Steigerwald:
> Am Donnerstag, 15. M=C3=A4rz 2012 schrieb Chris Mason:
> > On Thu, Mar 15, 2012 at 06:32:19PM +0100, Martin Steigerwald wrote:
> > > Am Samstag, 25. Februar 2012 schrieb Arne Jansen:
> > > > On 02/24/12 16:51, Martin Steigerwald wrote:
> > > > > Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > > >> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > > >>> I still have this with 3.2.0-1-pae - which is a debian kern=
el
> > > > >>> based on 3.2.1.
> > > > >>>=20
> > > > >>> When I do btrfs scrub start / the machine locks immediately
> > > > >>> up hard.
> > > > >>>=20
> > > > >>> Then usually on next boot it stops on space_cache enabled
> > > > >>> message, but not  the one for /, but the one for /home whic=
h
> > > > >>> is mounted later.
>=20
> [=E2=80=A6]
>=20
> > > > >> I now tested scrubbing /home which is a different BTRFS
> > > > >> filesystem on the same machine.
> > > > >>=20
> > > > >> Then the scrub is started, scrub status tells me so, but
> > > > >> nothing happens, no block in/out activity in vmstat, no CPU
> > > > >> related activity in top.
> > > > >>=20
> > > > >> btrfs scrub cancel then hangs, but not the complete machine,
> > > > >> only the process.
> > > > >>=20
> > > > >> I had this once on my T520 with the internal Intel SSD 320 a=
s
> > > > >> well. The other time it worked.
> > > > >>=20
> > > > >> Well maybe that is due to BTRFS doing something else on my T=
23
> > > > >> now:
> > > > >>=20
> > > > >> deepdance:~>  ps aux | grep ino-cache | grep -v grep
> > > > >> root      1992  5.5  0.0      0     0 ?        D    12:15 =20
> > > > >> 0:09 [btrfs- ino-cache]
>=20
> [=E2=80=A6]
>=20
> > > > >> At least it doesn=C2=B4t lock up hard, so there might really=
 be
> > > > >> something strange with /.
> > > > >=20
> > > > > FWIW a btrfs filesystem balance / does work. After this a btr=
fs
> > > > > scrub start / still locks the kernel.
> > > >=20
> > > > Hi Martin,
> > > >=20
> > > > I just sent 2 patches to the list. Could you please test if the=
se
> > > > fix your problem with scrub?
> > >=20
> > > I didn=C2=B4t yet test it but I tried the first balance then scru=
b stuff
> >=20
> > > again:
> > Looks like you're on a 32 bit machine.  The current for-linus branc=
h
> > has an important fix for scrub on 32 bit that should solve this.
>=20
> So finally - the machine did make-kpkg over night and complained abou=
t
> missing Documentation lguest, then I switched off lots from distro
> default config and just did the usual make stuff - I was able to scru=
b
> both partitions on that ThinkPad T23:
>=20
> deepdance:~> btrfs scrub status /
> scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
>         scrub started at Fri Mar 16 11:56:12 2012 and finished after
> 741 seconds total bytes scrubbed: 9.62GB with 0 errors
>=20
> deepdance:~> btrfs scrub status /home
> scrub status for a600de65-e1ab-4cbf-b150-bbaeaf9fa98d
>         scrub started at Fri Mar 16 12:00:31 2012 and finished after
> 1708 seconds total bytes scrubbed: 36.63GB with 0 errors
>=20
> Thanks a lot for fixing this.
>=20
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
[=E2=80=A6]

Would that patch

Btrfs: fix casting error in scrub reada code

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-
btrfs.git;a=3Dcommit;h=3Da175423c831ea582c06784d1e172d2ce1d79923a

(sorry for line break. KMail insists on it even when I disable line bre=
aks=20
due to the minus sign in the URL.)

that I tested above be something for stable?

To my knowledge Debian Wheezy and Ubuntu 12.04 LTS will have 3.2.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
