From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with
 degenerated profile
Date: Wed, 18 Jan 2012 14:42:08 +0100
Message-ID: <CABVOS0_6JpZF7e2AAp4-xSF2vrGMdxQ+Nv4_yiyaabThsPePNQ@mail.gmail.com>
References: <4F154738.8000709@cn.fujitsu.com> <20120117205815.GG3658@shiny>
 <4F169B04.3060200@jan-o-sch.net> <20120118124157.GF20139@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120118124157.GF20139@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2012 at 13:41, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Jan 18, 2012 at 11:12:20AM +0100, Jan Schmidt wrote:
>> On 17.01.2012 21:58, Chris Mason wrote:
>> > These two didn't make my first pull request just because I wanted =
to get
>> > something out the door. =C2=A0I'll definitely have them in the nex=
t pull.
>>
>> Please, don't do that! You can't just degenerate to DUP when RAID1 i=
s
>> out of space, that's entirely different.
>
> =C2=A0 Agreed. This isn't a good idea.
>
>> It's debatable whether degeneration from RAID0 to single is acceptab=
le,
>> but that again has different characteristics.
>
> =C2=A0 RAID-0 to single and RAID-10 to RAID-1 are less controversial,=
 I
> think, although we need to be clear about what the performance
> guarantees of the striping are (and how they would be affected by the
> move to fewer disks). Given that we already degrade the striping of
> RAID-0 down to "as many devices as we can fit right now", we're not
> really providing much in the way of performance guarantees.

Definitely this degeneration is good idea, but it should be only
optional and not default behavior of filesystem, default should be
ENOSPC.

>
> =C2=A0 (I'd definitely support some way of defining a fixed-width str=
ipe,
> but that's a whole separate question that we shouldn't get into now).
>
>> ENOSPC is the best choice for both in my opinon.
>>
>> -Jan
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0--- What's a Nazg=C3=BBl like you doing in a plac=
e like this? ---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
