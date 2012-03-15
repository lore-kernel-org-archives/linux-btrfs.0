From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Thu, 15 Mar 2012 14:08:52 -0400
Message-ID: <20120315180852.GW19217@shiny>
References: <201112171833.34720.Martin@lichtvoll.de>
 <201203151832.19703.Martin@lichtvoll.de>
 <20120315174245.GV19217@shiny>
 <201203151903.14445.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203151903.14445.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2012 at 07:03:14PM +0100, Martin Steigerwald wrote:
> Am Donnerstag, 15. M=E4rz 2012 schrieb Chris Mason:
> > >=20
> > > I didn=B4t yet test it but I tried the first balance then scrub s=
tuff=20
> > > again:
> > Looks like you're on a 32 bit machine.  The current for-linus branc=
h
> > has an important fix for scrub on 32 bit that should solve this.
>=20
> Yes, thats 32-bit.
>=20
> Can this fix be applied to 3.2 as well? If yes, could you point me at=
 it?
> Or otherwise is current for-linus somewhat stable?
>=20
> Cloning nonetheless - well after it finally installed git there which
> takes ages with audio playback lockups. Hopefully the /home BTRFS
> is faster than the / one ;). I have no cross-compiling set up.
>=20
> From atop:
>=20
> PAG | scan  11903 | stall      0 |              | swin      25 | swou=
t    875 |
> DSK |         sda | busy     74% | read     297 | write   4240 | avio=
    1 ms |

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git;a=3Dc=
ommit;h=3Da175423c831ea582c06784d1e172d2ce1d79923a

The patch is so small you can edit it by hand.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
