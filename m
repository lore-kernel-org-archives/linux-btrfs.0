From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: =?utf-8?Q?=E2=80=9Cbio?= too =?utf-8?Q?big=E2=80=9D?=
 regression and silent data corruption in 3.0
Date: Mon, 08 Aug 2011 19:39:44 -0300
Message-ID: <or1uwv7cjz.fsf@livre.localdomain>
References: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orwreobtuf.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Sun, 07 Aug 2011 22:00:24 -0300")
List-ID: <linux-btrfs.vger.kernel.org>

On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> tl;dr version: 3.0 produces =E2=80=9Cbio too big=E2=80=9D dmesg entri=
es and silently
> corrupts data in =E2=80=9Cmeta-raid1/data-single=E2=80=9D configurati=
ons on disks with
> different max_hw_sectors, where 2.6.38 worked fine.

=46WIW, I just got the same problem with 2.6.38.  No idea how I hadn't =
hit
it before, but it's not a 3.0 regression, just a regular (but IMHO very
serious) bug.

--=20
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
=46ree Software Evangelist      Red Hat Brazil Compiler Engineer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
