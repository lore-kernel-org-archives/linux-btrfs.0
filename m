From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Thu, 15 Mar 2012 13:42:45 -0400
Message-ID: <20120315174245.GV19217@shiny>
References: <201112171833.34720.Martin@lichtvoll.de>
 <201202241651.57233.Martin@lichtvoll.de>
 <4F48986D.4090703@gmx.net>
 <201203151832.19703.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203151832.19703.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2012 at 06:32:19PM +0100, Martin Steigerwald wrote:
> Am Samstag, 25. Februar 2012 schrieb Arne Jansen:
> > On 02/24/12 16:51, Martin Steigerwald wrote:
> > > Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > >> Am Samstag, 21. Januar 2012 schrieb Martin Steigerwald:
> > >>> I still have this with 3.2.0-1-pae - which is a debian kernel b=
ased
> > >>> on 3.2.1.
> > >>>=20
> > >>> When I do btrfs scrub start / the machine locks immediately up
> > >>> hard.
> > >>>=20
> > >>> Then usually on next boot it stops on space_cache enabled messa=
ge,
> > >>> but not  the one for /, but the one for /home which is mounted
> > >>> later.
> > >>>=20
> > >>> When I then boot with 3.1 it works. BTRFS redos the space_cache
> > >>> then while  the machine takes ages to boot - I mean ages - 10
> > >>> minutes till KDM prompt is no problem there.
> > >>=20
> > >> I now tested scrubbing /home which is a different BTRFS filesyst=
em
> > >> on the same machine.
> > >>=20
> > >> Then the scrub is started, scrub status tells me so, but nothing
> > >> happens, no block in/out activity in vmstat, no CPU related acti=
vity
> > >> in top.
> > >>=20
> > >> btrfs scrub cancel then hangs, but not the complete machine, onl=
y
> > >> the process.
> > >>=20
> > >> I had this once on my T520 with the internal Intel SSD 320 as we=
ll.
> > >> The other time it worked.
> > >>=20
> > >> Well maybe that is due to BTRFS doing something else on my T23 n=
ow:
> > >>=20
> > >> deepdance:~>  ps aux | grep ino-cache | grep -v grep
> > >> root      1992  5.5  0.0      0     0 ?        D    12:15   0:09
> > >> [btrfs- ino-cache]
> > >>=20
> > >> Hmmm, so I just let it sit for a while, maybe eventually it will
> > >> scrub /home.
> > >>=20
> > >> At least it doesn=B4t lock up hard, so there might really be som=
ething
> > >> strange with /.
> > >=20
> > > FWIW a btrfs filesystem balance / does work. After this a btrfs s=
crub
> > > start / still locks the kernel.
> >
> > Hi Martin,
> >=20
> > I just sent 2 patches to the list. Could you please test if these
> > fix your problem with scrub?
>=20
> I didn=B4t yet test it but I tried the first balance then scrub stuff=
 again:

Looks like you're on a 32 bit machine.  The current for-linus branch ha=
s
an important fix for scrub on 32 bit that should solve this.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
