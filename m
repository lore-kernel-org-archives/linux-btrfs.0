From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Fri, 25 Nov 2011 10:40:00 +0000
Message-ID: <CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
 <20111123110956.GB31800@attic.humilis.net> <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
 <20111124160617.680b676f@zougloub.eu> <CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
 <20111124165429.10496040@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124165429.10496040@Bidule>
List-ID: <linux-btrfs.vger.kernel.org>

> My mistake, the same printks are printed when the encryption key is i=
ncorrect, I've seen that here.
> It looks like you have some ugly hardware errors.
> The kernel cannot read from the drive, so it cannot guess the file sy=
stem on it.
> If the data is valuable, you could try to ddrescue the drive to a big=
ger one.
> =C2=A0(>750GB... and that will take time...) and attempt to mount the=
 rescued data.
> If the drive is in an USB enclosure, you could plug it directly via S=
ATA to the system (maybe it has issues?).

The hard drive is brand new, I also plugged it directly via eSATA and
checked the SMART data and run some tests and it succeeded in all, if
I format the drive again I have a working file-system for sure but
some of my data that is not on the backup disk will be gone.. I had
some time ago on opensuse tumbleweed a encrypted btrfs system and it
was gone some time ago like this external hard drive, I also had
various btrfs hard drives without encryption and they never failed,
and I will make a image of the disk but that will be later because I
don't have a backup hard drive bigger than 750gb, maybe btrfs fsck can
restore my disk when it is officially released?

--=20
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
