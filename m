From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 17 Mar 2012 17:37:08 -0700
Message-ID: <20120318003708.GE22993@kroah.com>
References: <201112171833.34720.Martin@lichtvoll.de>
 <20120315174245.GV19217@shiny>
 <201203161605.47792.Martin@lichtvoll.de>
 <201203171043.25660.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>, stable@kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203171043.25660.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 17, 2012 at 10:43:25AM +0100, Martin Steigerwald wrote:
> Hi Greg, Chris, Arne, hi everyone,
>=20
> Am Freitag, 16. M=C3=A4rz 2012 schrieb Martin Steigerwald:
> > Am Donnerstag, 15. M=C3=A4rz 2012 schrieb Chris Mason:
> > > On Thu, Mar 15, 2012 at 06:32:19PM +0100, Martin Steigerwald wrot=
e:
> > > > Am Samstag, 25. Februar 2012 schrieb Arne Jansen:
> > > > > On 02/24/12 16:51, Martin Steigerwald wrote:
> > > > > > Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > > > >> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > > > >>> I still have this with 3.2.0-1-pae - which is a debian ke=
rnel
> > > > > >>> based on 3.2.1.
> > > > > >>>=20
> > > > > >>> When I do btrfs scrub start / the machine locks immediate=
ly
> > > > > >>> up hard.
> > > > > >>>=20
> > > > > >>> Then usually on next boot it stops on space_cache enabled
> > > > > >>> message, but not  the one for /, but the one for /home wh=
ich
> > > > > >>> is mounted later.
> >=20
> > [=E2=80=A6]
> >=20
> > > > > >> I now tested scrubbing /home which is a different BTRFS
> > > > > >> filesystem on the same machine.
> > > > > >>=20
> > > > > >> Then the scrub is started, scrub status tells me so, but
> > > > > >> nothing happens, no block in/out activity in vmstat, no CP=
U
> > > > > >> related activity in top.
> > > > > >>=20
> > > > > >> btrfs scrub cancel then hangs, but not the complete machin=
e,
> > > > > >> only the process.
> > > > > >>=20
> > > > > >> I had this once on my T520 with the internal Intel SSD 320=
 as
> > > > > >> well. The other time it worked.
> > > > > >>=20
> > > > > >> Well maybe that is due to BTRFS doing something else on my=
 T23
> > > > > >> now:
> > > > > >>=20
> > > > > >> deepdance:~>  ps aux | grep ino-cache | grep -v grep
> > > > > >> root      1992  5.5  0.0      0     0 ?        D    12:15 =
=20
> > > > > >> 0:09 [btrfs- ino-cache]
> >=20
> > [=E2=80=A6]
> >=20
> > > > > >> At least it doesn=C2=B4t lock up hard, so there might real=
ly be
> > > > > >> something strange with /.
> > > > > >=20
> > > > > > FWIW a btrfs filesystem balance / does work. After this a b=
trfs
> > > > > > scrub start / still locks the kernel.
> > > > >=20
> > > > > Hi Martin,
> > > > >=20
> > > > > I just sent 2 patches to the list. Could you please test if t=
hese
> > > > > fix your problem with scrub?
> > > >=20
> > > > I didn=C2=B4t yet test it but I tried the first balance then sc=
rub stuff
> > >=20
> > > > again:
> > > Looks like you're on a 32 bit machine.  The current for-linus bra=
nch
> > > has an important fix for scrub on 32 bit that should solve this.
> >=20
> > So finally - the machine did make-kpkg over night and complained ab=
out
> > missing Documentation lguest, then I switched off lots from distro
> > default config and just did the usual make stuff - I was able to sc=
rub
> > both partitions on that ThinkPad T23:
> >=20
> > deepdance:~> btrfs scrub status /
> > scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
> >         scrub started at Fri Mar 16 11:56:12 2012 and finished afte=
r
> > 741 seconds total bytes scrubbed: 9.62GB with 0 errors
> >=20
> > deepdance:~> btrfs scrub status /home
> > scrub status for a600de65-e1ab-4cbf-b150-bbaeaf9fa98d
> >         scrub started at Fri Mar 16 12:00:31 2012 and finished afte=
r
> > 1708 seconds total bytes scrubbed: 36.63GB with 0 errors
> >=20
> > Thanks a lot for fixing this.
> >=20
> > Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> [=E2=80=A6]
>=20
> Would that patch
>=20
> Btrfs: fix casting error in scrub reada code
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-
> btrfs.git;a=3Dcommit;h=3Da175423c831ea582c06784d1e172d2ce1d79923a
>=20
> (sorry for line break. KMail insists on it even when I disable line b=
reaks=20
> due to the minus sign in the URL.)
>=20
> that I tested above be something for stable?

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
