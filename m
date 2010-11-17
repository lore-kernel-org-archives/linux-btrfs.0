From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 09:52:29 -0800
Message-ID: <AANLkTimC=rt+mFuD4kyYCepyLYG0B+rdT5jh_dy_yRpN@mail.gmail.com>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>
	<20101117143103.GA2401@selene>
	<AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, Chris Ball <cjb@laptop.org>,
	linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 7:12 AM, Bart Noordervliet
<bart@noordervliet.net> wrote:
> On Wed, Nov 17, 2010 at 15:31, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
>> On Tue, Nov 16, 2010 at 10:19:45PM -0500, Chris Ball wrote:
>>> =3D=3D Changing RAID levels =3D=3D
>>>
>>> We need ioctls to change between different raid levels. =C2=A0Some =
of these
>>> are quite easy -- e.g. for RAID0 to RAID1, we just halve the availa=
ble
>>> bytes on the fs, then queue a rebalance.
>>
>> =C2=A0 I would be interested in the rebalancing ioctls, and in RAID =
level
>> management. I'm still very much trying to learn the basics, though, =
so
>> I may go very slowly at first...
>>
>> =C2=A0 Hugo.
>
> Can I suggest we combine this new RAID level management with a
> modernisation of the terminology for storage redundancy, as has been
> discussed previously in the "Raid1 with 3 drives" thread of March thi=
s
> year? I.e. abandon the burdened raid* terminology in favour of
> something that makes more sense for a filesystem.
>
> Mostly this would involve a discussion about what terms would make
> most sense, though some changes in the behaviour of btrfs redundancy
> modes may be warranted if they make things more intuitive.
>
> I could help you make these changes in your patches, or write my own
> patches against yours, though I'm also completely new to kernel
> development.
>

That would inherently solve the need to convert between dup and raid1
as well.  Why those are separate and why dup does not become raid1
when there are N > 1 drives is beyond me.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
