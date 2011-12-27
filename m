From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: FS won't mount, open_ctree failed, Assertion !(path->slots[0] == 0) failed
Date: Tue, 27 Dec 2011 12:14:45 +0100
Message-ID: <201112271214.45498.Martin@lichtvoll.de>
References: <CB041FF1.1FD66%dsmith@tgen.org> <20111223181542.GU19266@shiny> <4EF8C5C4.7090301@gmail.com> (sfid-20111227_102533_234959_359C4D67)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Evan LeCompte <evanlec@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF8C5C4.7090301@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 26. Dezember 2011 schrieb Evan LeCompte:
> On 12/23/2011 06:15 PM, Chris Mason wrote:
> > On Fri, Dec 23, 2011 at 09:37:28AM +0000, Evan LeCompte wrote:
> >> I'm having the very same issue as you. I've tried all the latest
> >> btrfs tools, btrfsck, btrfs-zero-log, restore, find-root etc etc.
> >>=20
> >> All to no avail. only err output is always
> >>=20
> >> "" btrfs_find_last_root: Assertion `!(path->slots[0] =3D=3D 0)' fa=
iled.
> >> ""
> >>=20
> >> This is a very cryptic error that doesn't tell me anything. and it
> >> seems to be the only error that is ever thrown when transaction
> >> id's get out of sync.
> >>=20
> >> Is there ANY way to even recover ANY files at all from these btrfs
> >> filesystems that lose transid sync? mine occurred simply from a
> >> loose sata cable falling out of one of my drives while the system
> >> was running.
> >>=20
> >> This is extremely frustrating, but I guess I have no one to blame
> >> but myself. I do have a backup but its about a month old (my cron
> >> backup script died for some reason and I didn't notice). So I'm
> >> faced with losing a months worth of work :(
> >>=20
> >> Please help us, anyone!
> >=20
> > Which kernel are you running?  If you're on a 3.2 kernel or you hav=
e
> > a recent pull of my git tree, you can try mount -o recovery.
> >=20
> > My guess is that your machine went down pretty quickly after the
> > loose sata cable fell out?  In that case mount -o recovery should
> > work.
> >=20
> > Otherwise we can work through the copy out recovery tools.
[=E2=80=A6]
> Chris,
> Can you help me work through the copy out recovery tools that you
> mentioned?
>=20
> I can't seem to get anything else to work, if I could just recover th=
e
> files so I don't lose a month's work I'd be so happy...

=46or starters I think it would be good when you explain exactly, what =
tools=20
you tried and what errors you have gotten (copy&paste the relevant part=
s!)=20
by doing so. It also makes sense to do this with a recent copy of btrfs=
-
tools.

I am no expert in BTRFS recovery but I think its easier to work from=20
there.

Aside from that, backup or not, I wouldn=C2=B4t put important data on a=
 RAID 0=20
across several devices and when it usually just is for saving on backup=
=20
restauration time in case one of the devices fails. Better have some=20
redundant RAID *and* a backup. Or if "RAID 0" at least BTRFS on *one*=20
device, instead of mutiple. Or otherwise said: I would use RAID-0 acros=
s=20
mutiple disks just for scratch data that I can easily afford to loose.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
