From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Fri, 16 Mar 2012 16:05:47 +0100
Message-ID: <201203161605.47792.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <201203151832.19703.Martin@lichtvoll.de> <20120315174245.GV19217@shiny> (sfid-20120315_185259_074357_E09C1265)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120315174245.GV19217@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 15. M=C3=A4rz 2012 schrieb Chris Mason:
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
[=E2=80=A6]
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
[=E2=80=A6]
> > > >> At least it doesn=C2=B4t lock up hard, so there might really b=
e
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
> > I didn=C2=B4t yet test it but I tried the first balance then scrub =
stuff=20
> > again:
> Looks like you're on a 32 bit machine.  The current for-linus branch
> has an important fix for scrub on 32 bit that should solve this.

So finally - the machine did make-kpkg over night and complained about
missing Documentation lguest, then I switched off lots from distro defa=
ult
config and just did the usual make stuff - I was able to scrub both
partitions on that ThinkPad T23:

deepdance:~> btrfs scrub status /
scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        scrub started at Fri Mar 16 11:56:12 2012 and finished after 74=
1 seconds
        total bytes scrubbed: 9.62GB with 0 errors

deepdance:~> btrfs scrub status /home
scrub status for a600de65-e1ab-4cbf-b150-bbaeaf9fa98d
        scrub started at Fri Mar 16 12:00:31 2012 and finished after 17=
08 seconds
        total bytes scrubbed: 36.63GB with 0 errors

Thanks a lot for fixing this.=20

Tested-by: Martin Steigerwald <martin@lichtvoll.de>

Arne, if you want me to test your two patches to readahead as well, ple=
ase
tell me. Now since only a few files need to be recompiled it would be
quite easy to test them.

Next challenge is the slow performance at times. This morning as I boot=
ed
into the new kernel afterwards on tty it took at least 15 seconds of
heavy disk activity with hearable lots of seeks to just open a screen.
But thats something for a different thread.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
