From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 15:31:47 +0100 (BST)
Message-ID: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
References: <201109111208.25761.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org,
	Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201109111208.25761.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

--- On Sun, 11/9/11, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Cc to BTRFS mailinglist as it
> triggered the idea of mine again.
>=20
>=20
> Hi!
>=20
> Today I did it again and removed a BTRFS partition that is
> written too.=20
> That BTRFS as of Kernel 3.0.3 (debian package) does not
> like very much. I=20
> think thats a known issue and I wrote a mail to BTRFS
> mailing list about=20
> it.
>=20
> In there I wrote:
>=20
> > Expected results:
> >=20
> > BTRFS fails gracefully except the loss of data from
> writes in flight, the=20
> > machine remains usable and BTRFS can be mounted
> again.
>=20
> And then cause the expected results IMHO are by no way the
> ideal results:
>=20
>=20
> > Ideal results (IMHO):
> >=20
> > Linux behaved like AmigaOS and told me that I *must*
> insert the device=20
> > again and *continues* writing after I did this.=20
>=20
> But I never saw any other OS that did that.
>=20
> And I see the problems with high bandwidth writes piling up
> in memory=20
> causing severe memory pressure.
>=20
> But then could Linux just freeze processes that continue
> writing to the=20
> drive until it is replugged again? Of course that
> shouldn=B4t happen to the=20
> drive / resides on.
>=20
> And there is a userspace part in it - the possibly udev and
> dbus=A0 driven=20
> notification to the user.

How do you cope with=20
(1) headless systems (one where there is no udev/dbus notification or d=
isplay).
(2) the user walking off in a hurry and never seeing the notification?
Should the kernel/user processes freeze indefinitely?

There is also a 3rd scenario - how how one malicious person or process =
doing a repeat insert/remove/write and get resource to pile up and cras=
h the machine?

It is probably possible/recommended with Amiga because Amiga is seldoml=
y run headless?

>=20
> Yet despite all of this NetBSD has a gsoc 2011 project at
> least suggested=20
> for exactly this behavior:
>=20
> Graceful USB disk detach/reattach
> http://wiki.netbsd.org/projects/gsoc_2011/disk-removal/
>=20
> They even mention the Amiga in there.
>=20
> Okay, its only for USB, not for eSATA, but I think it
> should be made=20
> generic for removable devices.
>=20
> Would that be possible? I gladly file an enhancement
> request about it or=20
> help testing it.
>=20
> I think thats the only approach that makes sense here. USB
> sticks and=20
> harddisks have no means to disallow device removal at any
> time. Thus the=20
> OS should offer the user a way to rethink the decision and
> plug the device=20
> in to prevent data loss. Actually I am surprised that no
> other operating=20
> system except AmigaOS seemed to offer this behavior. Well I
> am not quite=20
> sure about MS-DOS writing to disk. Maybe it even did that.
> But I did not=20
> use MS-DOS often.=20
>=20
> All current mainstream operating systems I know of default
> to loose data=20
> in that case. I think there is a better choice. What do you
> think? Might=20
> not be much of a server feature, but important for the
> desktop.
>=20
> Ciao,
> --=20
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA=A0 B82F 991B EAAC A599
> 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
