From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 12:08:25 +0200
Message-ID: <201109111208.25761.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Cc to BTRFS mailinglist as it triggered the idea of mine again.


Hi!

Today I did it again and removed a BTRFS partition that is written too.=
=20
That BTRFS as of Kernel 3.0.3 (debian package) does not like very much.=
 I=20
think thats a known issue and I wrote a mail to BTRFS mailing list abou=
t=20
it.

In there I wrote:

> Expected results:
>=20
> BTRFS fails gracefully except the loss of data from writes in flight,=
 the=20
> machine remains usable and BTRFS can be mounted again.

And then cause the expected results IMHO are by no way the ideal result=
s:


> Ideal results (IMHO):
>=20
> Linux behaved like AmigaOS and told me that I *must* insert the devic=
e=20
> again and *continues* writing after I did this.=20

But I never saw any other OS that did that.

And I see the problems with high bandwidth writes piling up in memory=20
causing severe memory pressure.

But then could Linux just freeze processes that continue writing to the=
=20
drive until it is replugged again? Of course that shouldn=B4t happen to=
 the=20
drive / resides on.

And there is a userspace part in it - the possibly udev and dbus  drive=
n=20
notification to the user.

Yet despite all of this NetBSD has a gsoc 2011 project at least suggest=
ed=20
for exactly this behavior:

Graceful USB disk detach/reattach
http://wiki.netbsd.org/projects/gsoc_2011/disk-removal/

They even mention the Amiga in there.

Okay, its only for USB, not for eSATA, but I think it should be made=20
generic for removable devices.

Would that be possible? I gladly file an enhancement request about it o=
r=20
help testing it.

I think thats the only approach that makes sense here. USB sticks and=20
harddisks have no means to disallow device removal at any time. Thus th=
e=20
OS should offer the user a way to rethink the decision and plug the dev=
ice=20
in to prevent data loss. Actually I am surprised that no other operatin=
g=20
system except AmigaOS seemed to offer this behavior. Well I am not quit=
e=20
sure about MS-DOS writing to disk. Maybe it even did that. But I did no=
t=20
use MS-DOS often.=20

All current mainstream operating systems I know of default to loose dat=
a=20
in that case. I think there is a better choice. What do you think? Migh=
t=20
not be much of a server feature, but important for the desktop.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
