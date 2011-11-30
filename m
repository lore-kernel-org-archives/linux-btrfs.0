From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs encryption problems
Date: Wed, 30 Nov 2011 08:48:14 -0500
Message-ID: <20111130134814.GW24338@shiny>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
 <20111123110956.GB31800@attic.humilis.net>
 <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
 <20111124160617.680b676f@zougloub.eu>
 <CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
 <20111124165429.10496040@Bidule>
 <CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
To: 810d4rk <810d4rk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2011 at 10:40:00AM +0000, 810d4rk wrote:
> > My mistake, the same printks are printed when the encryption key is=
 incorrect, I've seen that here.
> > It looks like you have some ugly hardware errors.
> > The kernel cannot read from the drive, so it cannot guess the file =
system on it.
> > If the data is valuable, you could try to ddrescue the drive to a b=
igger one.
> > =A0(>750GB... and that will take time...) and attempt to mount the =
rescued data.
> > If the drive is in an USB enclosure, you could plug it directly via=
 SATA to the system (maybe it has issues?).
>=20
> The hard drive is brand new, I also plugged it directly via eSATA and
> checked the SMART data and run some tests and it succeeded in all, if
> I format the drive again I have a working file-system for sure but
> some of my data that is not on the backup disk will be gone.. I had
> some time ago on opensuse tumbleweed a encrypted btrfs system and it
> was gone some time ago like this external hard drive, I also had
> various btrfs hard drives without encryption and they never failed,
> and I will make a image of the disk but that will be later because I
> don't have a backup hard drive bigger than 750gb, maybe btrfs fsck ca=
n
> restore my disk when it is officially released?

If you plug it in directly with esata, do the IO errors go away?  If so=
,
please post the kernel messages from that.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
