From: Paul Komkoff <i@stingr.net>
Subject: Re: Update to Project_ideas wiki page
Date: Fri, 26 Nov 2010 14:57:25 +0000
Message-ID: <AANLkTin2gYY4nET9=YmuF9qtO+UhKy--Qurw1O62ACNj@mail.gmail.com>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>
	<20101117143103.GA2401@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>, Chris Ball <cjb@laptop.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101117143103.GA2401@selene>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 2:31 PM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
>> =3D=3D Changing RAID levels =3D=3D
>>
>> We need ioctls to change between different raid levels. =A0Some of t=
hese
>> are quite easy -- e.g. for RAID0 to RAID1, we just halve the availab=
le
>> bytes on the fs, then queue a rebalance.

Can we please do it properly? That is, change raid levels on a
per-file, per-tree basis?

Thanks.
--=20
This message represents the official view of the voices in my head
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
