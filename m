From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Fri, 13 May 2011 16:16:56 +0700
Message-ID: <BANLkTi=CF--tqdo0AtnFYbaepMP=-_ZKuw@mail.gmail.com>
References: <1305179125.3106.3.camel@tethys>
	<20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
	<1305236204.3277.1.camel@tethys>
	<BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
	<1305277193.3052.24.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305277193.3052.24.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2011 at 3:59 PM, Sw=E2mi Petaramesh <swami@petaramesh.o=
rg> wrote:
> Adding to the fact that it comes included with the stock and distro
> kernels... That gives a bit contradictory signals... "Should I stay o=
r
> should I go ?"
>
> Looks a bit like legal babble boiling down to =AB Yes, it is supposed=
 to
> work and be usable, so please use it, just be so kind no to sue us if
> you run into trouble. Not our fault, we won't accept any liability. =BB

Something like that.
Note also since it's in heavy development, even a small difference in
kernel version can make a difference between whether a bug is present
or not, so it's advisable to always try latest kernel version.

>
>> Add to that the fact that you use Ubuntu Natty, which also have some=
 known
>> bugs. There should be some hints there on what the outcome would be =
:P
>
> Every distro has bugs. However Natty's kernel never ever hanged my
> system until I shifted to using BTRFS... I won't relate BTRFS issues =
to
> using Natty unless there is some evidence pointing in this direction.=
=2E.
>
> Not wanting to troll, of course, uh... ;-)

No troll taken.

Just wanted to point out that since Natty is new and has known bugs
(which might include kernel package as well), if you encounter
problems try to use latest available kernel for Natty first. If it
doesn't work, try latest vanilla kernel from kernel.org. For example,
IIRC 2.6.38 has a bug in that you can't use mount option "subvol=3D..."
if the fs/subvolume is newly created, while 2.6.39 works fine. At
least that's what I experienced, so now I use subvolid to select
subvolume.

>
>> If you're used to ext4 speed, then you'll notice that btrfs is consi=
derably
>> slower. That's why I use SSD to add some I/O speed (currently bootin=
g to gnome
>> classic desktop only takes about 30 seconds).
>
> Well, I noticed it's slower, still usable for me anyway, I'm a patien=
t
> guy ;-) Anyway an SSD is not an option to me, financially speaking ;-=
)

A 60GB Corsair Force should be about $140. Highly recommended. Higher
capacities provide even better cost/GB.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
