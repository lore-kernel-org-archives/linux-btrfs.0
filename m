From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance RAID10 with odd device count
Date: Wed, 22 Feb 2012 11:48:20 +0000 (UTC)
Message-ID: <pan.2012.02.22.11.48.19@cox.net>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
	<CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
	<20120221010724.GB5350@carfax.org.uk>
	<CA+Huu1E2cg5a4PWtCkN4a4qou4T++VENsLjC8=TiRPJw5tzAUA@mail.gmail.com>
	<20120221012148.GD5350@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 21 Feb 2012 01:21:48 +0000 as excerpted:

> On Mon, Feb 20, 2012 at 08:13:43PM -0500, Tom Cameron wrote:
>> On Mon, Feb 20, 2012 at 8:07 PM, Hugo Mills <hugo@carfax.org.uk> wro=
te:
>> >
>> > =C2=A0 However, you can remove any one drive, and your data is fin=
e,
>> > =C2=A0 which
>> > is what btrfs's RAID-1 guarantee is. I understand that there will =
be
>> > additional features coming along Real Soon Now (possibly at the sa=
me
>> > time that RAID-5 and -6 are integrated) which will allow the
>> > selection of larger numbers of copies.
>> >
>> >
>> Is there a projected timeframe for RAID5/6? I understand it's curren=
tly
>> not the development focus of the BTRFS team, and most organizations
>> want performance over capacity making RAID10 the clear choice. But,
>> there are still some situations where RAID6 is better suited (large
>> pools of archive storage).
>=20
>    Rumour has it that it's the next major thing after btrfsck is out
> of the door. I don't know how accurate that is. I'm just some bloke o=
n
> the Internet. :)

The report I read (on phoronix, ymmv but it was supposed to be from a=20
talk at scalex, iirc) said raid-5/6 was planned for kernel 3.4 or 3.5,=20
with triple-copy-mirroring said to piggyback on some of that code, so=20
presumably 3.5 or 3.6.

Triple-copy-mirroring as a special case doesn't really make sense to me=
,=20
tho.  The first implementation as two-copy (dup) only makes sense, but =
in=20
generalizing that to allow triple copy, I'd think/hope they'd generaliz=
e=20
it to N-copy, IOW, traditional raid-1 style, instead.

I guess we'll see.

=46WIW, I'm running on an older 4-spindle md-raid1 setup now, and I had=
=20
/hoped/ to convert that to 4-copy btrfs-raid1, but that's simply not=20
possible ATM tho a hybrid 2-copy btrfs on dual dual-spindle md/raid1s i=
s=20
possible, if a bit complex.

Given that the disks are older, 300 gig sata seagates nearing half thei=
r=20
rated run-hours according to smart (great on power and spinup cycles=20
tho), now's not the time to switch them to dual-copy-only!  I'd think=20
about triple-copy, but no less!  Thus, I'm eagerly awaiting the=20
introduction of tri- or preferably N-copy raid1 mode, in 3.5-ish.  But=20
the various articles had lead me to believe that btrfs was almost ready=
=20
to have the experimental label removed, and it turns out not to be quit=
e=20
that far along, maybe end-of-year if things go well, so letting btrfs=20
continue to stabilize in general while I wait, certainly won't hurt. =3D=
:^)

Meanwhile, I'm staying on-list so as to keep informed of what else is=20
going on, btrfs-wise, while I wait for triple-copy-mode, minimum.


--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
