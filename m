From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Thu, 15 Mar 2012 19:03:14 +0100
Message-ID: <201203151903.14445.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201203151832.19703.Martin@lichtvoll.de> <20120315174245.GV19217@shiny> (sfid-20120315_185259_074357_E09C1265)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120315174245.GV19217@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 15. M=E4rz 2012 schrieb Chris Mason:
> On Thu, Mar 15, 2012 at 06:32:19PM +0100, Martin Steigerwald wrote:
> > Am Samstag, 25. Februar 2012 schrieb Arne Jansen:
> > > On 02/24/12 16:51, Martin Steigerwald wrote:
> > > > Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > >> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > > >>> I still have this with 3.2.0-1-pae - which is a debian kernel
> > > >>> based on 3.2.1.
> > > >>>=20
> > > >>> When I do btrfs scrub start / the machine locks immediately u=
p
> > > >>> hard.
> > > >>>=20
> > > >>> Then usually on next boot it stops on space_cache enabled
> > > >>> message, but not  the one for /, but the one for /home which
> > > >>> is mounted later.
> > > >>>=20
> > > >>> When I then boot with 3.1 it works. BTRFS redos the space_cac=
he
> > > >>> then while  the machine takes ages to boot - I mean ages - 10
> > > >>> minutes till KDM prompt is no problem there.
> > > >>=20
> > > >> I now tested scrubbing /home which is a different BTRFS
> > > >> filesystem on the same machine.
> > > >>=20
> > > >> Then the scrub is started, scrub status tells me so, but nothi=
ng
> > > >> happens, no block in/out activity in vmstat, no CPU related
> > > >> activity in top.
> > > >>=20
> > > >> btrfs scrub cancel then hangs, but not the complete machine,
> > > >> only the process.
> > > >>=20
> > > >> I had this once on my T520 with the internal Intel SSD 320 as
> > > >> well. The other time it worked.
> > > >>=20
> > > >> Well maybe that is due to BTRFS doing something else on my T23
> > > >> now:
> > > >>=20
> > > >> deepdance:~>  ps aux | grep ino-cache | grep -v grep
> > > >> root      1992  5.5  0.0      0     0 ?        D    12:15   0:=
09
> > > >> [btrfs- ino-cache]
> > > >>=20
> > > >> Hmmm, so I just let it sit for a while, maybe eventually it wi=
ll
> > > >> scrub /home.
> > > >>=20
> > > >> At least it doesn=B4t lock up hard, so there might really be
> > > >> something strange with /.
> > > >=20
> > > > FWIW a btrfs filesystem balance / does work. After this a btrfs
> > > > scrub start / still locks the kernel.
> > >=20
> > > Hi Martin,
> > >=20
> > > I just sent 2 patches to the list. Could you please test if these
> > > fix your problem with scrub?
> >=20
> > I didn=B4t yet test it but I tried the first balance then scrub stu=
ff=20
> > again:
> Looks like you're on a 32 bit machine.  The current for-linus branch
> has an important fix for scrub on 32 bit that should solve this.

Yes, thats 32-bit.

Can this fix be applied to 3.2 as well? If yes, could you point me at i=
t?
Or otherwise is current for-linus somewhat stable?

Cloning nonetheless - well after it finally installed git there which
takes ages with audio playback lockups. Hopefully the /home BTRFS
is faster than the / one ;). I have no cross-compiling set up.

=46rom atop:

PAG | scan  11903 | stall      0 |              | swin      25 | swout =
   875 |
DSK |         sda | busy     74% | read     297 | write   4240 | avio  =
  1 ms |


=46rom vmstat 1:

deepdance:~> vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----c=
pu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy=
 id wa
 0  2 127012 109472     36 263096    1    6   661   740  516 1572 42 14=
 41  4
 0  2 127012 110628     36 263088    0    0     0  2228  995 2114 41 14=
  0 44
 0  0 127012 112800     36 263088    0    0     0  2916 1148 2306 38 19=
  2 41
 1  0 127012  98416     36 277192  664    0   664     8  642 1203 82 13=
  3  2
 2  0 127012  79320     36 294872 1072    0  1072     0  653 1226 77 16=
  0  7
 9  0 127556  85952     36 279968  700  544   700 16456 1442 9767 37 63=
  0  0
 3  0 127556  92584     36 281720  360    0   364 22408 1743 11684 44 5=
6  0  0
 0  2 127556  90964     36 282984    0    0    52  3104  915 2528 41 44=
  0 14
 3  1 127556  91932     36 283036    0    0     0  2408  995 1969 46 14=
  0 40
 0  1 127556  91760     36 283296    0    0     4  3004  980 2140 39 27=
  6 29
 6  1 121000 190288     36 283884    0    0   612     8  596 1452 39 17=
 26 18
 1  2 121000 181060     36 287732    0    0  3776  2104  791 1485 52 33=
  0 15
 2  2 121000 181212     36 287724    0    0     4  2384  862 1936 40 23=
  1 37
 0  1 121000 181444     36 287732    0    0     4  1888  870 2000 38 20=
 10 32
 1  0 121000 181160     36 287740    0    0     4  2104  846 2170 45 25=
  9 20
 3  1 121000 181156     36 287748    0    0     0  3528  916 2179 44 17=
  7 32
 0  0 121000 181748     36 287756    0    0     0  1976  843 2199 41 19=
 17 23
 3  0 121000 179252     36 290036    0    0  2240  2088  875 2197 42 30=
  1 28

These high values on wait luck suspicious to me.

Anyway, cloning now.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
