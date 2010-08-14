From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: no space left on device
Date: Sat, 14 Aug 2010 20:15:49 +0000 (UTC)
Message-ID: <i46thk$gn0$1@dough.gmane.org>
References: <i2to2q$b3m$1@dough.gmane.org>
	<AANLkTikBRfR45DZxZW9LM6wnREWrbysPCr9Z1d3YuYhC@mail.gmail.com>
	<20100730122756.GA5056@nbgentoo.vslesy.cz>
	<AANLkTinBj1O-LapAeBCT2Y3A1ZhfFZ3AotCk6SZ-e-2U@mail.gmail.com>
	<AANLkTimcgzp8Fs524GMzPaancXZU689twnBH3orY0yYn@mail.gmail.com>
	<i2uphq$p75$1@dough.gmane.org> <i2uq07$p75$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have another example with 2.6.35-r1 and latest btrfs-progs

# btrfs filesystem show
Label: none  uuid: 46c7a8b4-ca13-4b4f-a695-6a0e31112411
	Total devices 2 FS bytes used 1.23TB
	devid    1 size 896.39GB used 896.39GB path /dev/dm-0
	devid    2 size 896.39GB used 896.25GB path /dev/dm-1

# btrfs filesystem df /home
Data: total=3D1.74TB, used=3D1.23TB
Metadata: total=3D3.01GB, used=3D2.18GB
System: total=3D12.00MB, used=3D200.00KB

So there should be plenty of space left, but I am getting messages
that the device is out of free space.

Anything I can try to debug this?

Thank you

Lubos


Lubos Kolouch, Fri, 30 Jul 2010 15:09:59 +0000:

> correction - btrfs-cache processes
>=20
> Lubos Kolouch, Fri, 30 Jul 2010 15:02:18 +0000:
>=20
>> With 2.6.34 it basically "works", but time to time the load goes up =
to
>> 50 and lot of btrfs-cleaner processess are spawned... the system is
>> responsive though, except for the filesystem... after an hour or so =
the
>> processes finish and the load goes back to normal
>>=20
>> Lubos
>>=20
>>> On Fri, Jul 30, 2010 at 3:26 PM, Leonidas Spyropoulos
>>> <artafinde@gmail.com> wrote:
>>>> I use the latest btrfs-tools and 2.6.34-020634-generic kernel for
>>>> lucid. Got no issues like that, is it happening with 2.6.34 kernel=
 as
>>>> well?
>>>>
>>>> On Fri, Jul 30, 2010 at 1:27 PM, Lubos Kolouch
>>>> <lubos.kolouch@gmail.com> wrote:
>>>>>
>>>>> Yes, I pulled today's btrfs-progs.
>>>>>
>>>>> Lubos
>>>>>
>>>>> On P=C3=A1, =C4=8Dec 30, 2010, 13:03:10, Leonidas Spyropoulos wro=
te:
>>>>> > Have you updated with latest btrfs-tools?
>>>>> >
>>>>> > On Fri, Jul 30, 2010 at 6:31 AM, Lubos Kolouch
>>>>> > <lubos.kolouch@gmail.com>wrote:
>>>>> >
>>>>> > > Hello,
>>>>> > >
>>>>> > > kerner 2.6.35-rc6
>>>>> > >
>>>>> > > btrfs filesystem df /home
>>>>> > > Data: total=3D1.68TB, used=3D987.62GB
>>>>> > > Metadata: total=3D56.01GB, used=3D48.16GB System: total=3D12.=
00MB,
>>>>> > > used=3D200.00KB
>>>>> > >
>>>>> > > touch: cannot touch `/home/x': No space left on device
>>>>> > >
>>>>> > > Any ideas what I should do?
>>>>> > >
>>>>> > > Thank you
>>>>> > >
>>>>> > > Lubos
>>>>> > >


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
