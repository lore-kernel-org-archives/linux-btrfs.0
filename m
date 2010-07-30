From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: no space left on device
Date: Fri, 30 Jul 2010 15:02:18 +0000 (UTC)
Message-ID: <i2uphq$p75$1@dough.gmane.org>
References: <i2to2q$b3m$1@dough.gmane.org>
	<AANLkTikBRfR45DZxZW9LM6wnREWrbysPCr9Z1d3YuYhC@mail.gmail.com>
	<20100730122756.GA5056@nbgentoo.vslesy.cz>
	<AANLkTinBj1O-LapAeBCT2Y3A1ZhfFZ3AotCk6SZ-e-2U@mail.gmail.com>
	<AANLkTimcgzp8Fs524GMzPaancXZU689twnBH3orY0yYn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With 2.6.34 it basically "works", but time to time the load goes up to =
50
and lot of btrfs-cleaner processess are spawned...=20
the system is responsive though, except for the filesystem... after an=20
hour or so the processes finish and the load goes back to normal

Lubos

> On Fri, Jul 30, 2010 at 3:26 PM, Leonidas Spyropoulos
> <artafinde@gmail.com> wrote:
>> I use the latest btrfs-tools and 2.6.34-020634-generic kernel for
>> lucid. Got no issues like that, is it happening with 2.6.34 kernel a=
s
>> well?
>>
>> On Fri, Jul 30, 2010 at 1:27 PM, Lubos Kolouch
>> <lubos.kolouch@gmail.com> wrote:
>>>
>>> Yes, I pulled today's btrfs-progs.
>>>
>>> Lubos
>>>
>>> On P=C3=A1, =C4=8Dec 30, 2010, 13:03:10, Leonidas Spyropoulos wrote=
:
>>> > Have you updated with latest btrfs-tools?
>>> >
>>> > On Fri, Jul 30, 2010 at 6:31 AM, Lubos Kolouch
>>> > <lubos.kolouch@gmail.com>wrote:
>>> >
>>> > > Hello,
>>> > >
>>> > > kerner 2.6.35-rc6
>>> > >
>>> > > btrfs filesystem df /home
>>> > > Data: total=3D1.68TB, used=3D987.62GB
>>> > > Metadata: total=3D56.01GB, used=3D48.16GB System: total=3D12.00=
MB,
>>> > > used=3D200.00KB
>>> > >
>>> > > touch: cannot touch `/home/x': No space left on device
>>> > >
>>> > > Any ideas what I should do?
>>> > >
>>> > > Thank you
>>> > >
>>> > > Lubos
>>> > >

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
