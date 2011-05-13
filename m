From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Fri, 13 May 2011 10:59:53 +0200
Message-ID: <1305277193.3052.24.camel@tethys>
References: <1305179125.3106.3.camel@tethys>
	 <20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
	 <1305236204.3277.1.camel@tethys>
	 <BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Fajar,

Le vendredi 13 mai 2011 =C3=A0 13:54 +0700, Fajar A. Nugraha a =C3=A9cr=
it :

> Well, first of all, btrfs is still under heavy development.

The wiki https://btrfs.wiki.kernel.org/index.php/Main_Page says in bold=
:

=C2=AB Btrfs is under heavy development, but every effort is being made=
 to
keep the filesystem stable and fast. As of 2.6.31, we only plan to make
forward compatible disk format changes, and many users have been
experimenting with Btrfs on their systems with good results. =C2=BB

Adding to the fact that it comes included with the stock and distro
kernels... That gives a bit contradictory signals... "Should I stay or
should I go ?"

Looks a bit like legal babble boiling down to =C2=AB Yes, it is suppose=
d to
work and be usable, so please use it, just be so kind no to sue us if
you run into trouble. Not our fault, we won't accept any liability. =C2=
=BB

> Add to that the fact that you use Ubuntu Natty, which also have some =
known
> bugs. There should be some hints there on what the outcome would be :=
P

Every distro has bugs. However Natty's kernel never ever hanged my
system until I shifted to using BTRFS... I won't relate BTRFS issues to
using Natty unless there is some evidence pointing in this direction...

Not wanting to troll, of course, uh... ;-)

> If you're used to ext4 speed, then you'll notice that btrfs is consid=
erably
> slower. That's why I use SSD to add some I/O speed (currently booting=
 to gnome
> classic desktop only takes about 30 seconds).

Well, I noticed it's slower, still usable for me anyway, I'm a patient
guy ;-) Anyway an SSD is not an option to me, financially speaking ;-)

Kind regards.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
