Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33583 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3GZOpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 10:45:55 -0400
Date: Fri, 26 Jul 2013 15:45:53 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Axelle <aafortinet@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Adding 500G disk to btrfs volume... but I don't get 500G more of
 available space (raid0)
Message-ID: <20130726144553.GL20517@carfax.org.uk>
References: <CANKzOHASE9pB6TjJ4JbqY1PE6cRsbCsY=KU3NVRjwcb74tikVQ@mail.gmail.com>
 <20130726074508.GJ20517@carfax.org.uk>
 <CANKzOHCJY29__R-5vsjNTrmQ82HgrYqrSgX2AZ7mbF2T1h=eTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umrsQkkrw7viUWFs"
In-Reply-To: <CANKzOHCJY29__R-5vsjNTrmQ82HgrYqrSgX2AZ7mbF2T1h=eTQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--umrsQkkrw7viUWFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 04:35:59PM +0200, Axelle wrote:
> Hi Hugo,
> Thanks for your answer, but I'm afraid I still don't get it.
> 
> >RAID-0 requires at least two devices.
> 
> Well, I have three devices, so that's more than enough isn't it?
> Or do you mean I should be adding two devices at a time?
> 
> > If you balance this
> >configuration, you'll use up the first 93.13 GiB of each device
> >striping across all three devices, for a total of 3*93.13 = 279.39
> 
> why 93.13? I guess you meant 84.53 which is the size I am using on
> sdc1 and sdc6.

   Sorry, a little unclear -- if you balance, and then continue
writing data to the FS. Once you hit 93.13 GiB (the size of the
smallest device), you switch to 2-device operation, and then when
that's full, you can't go any further.

> ># btrfs balance start -dconvert=single,soft /samples
> 
> Nice command but I wasn't thinking of stopping RAID0 striping. I was
> expecting my data to be stripped evenly on all 3 devices.

   It's worth noting that /dev/sdc1 and /dev/sdc6 are on the same
physical device. If that's a rotational device (i.e. traditional hard
disk), then you're going to have a serious performance decrease as a
result of that, because /dev/sdc will have to spend lots of its time
seeking between the two partitions. "single" operation really is the
better option here -- you'll get to use all your space, and you won't
suffer the performance problems of striping between two partitions on
the same disk.

> Well - evenly - until the smallest one /dev/sdc1 is filled, then,
> it'll use only the last two, when /dev/sdc6 is filled, it will used
> /dev/sdb only.
> Is that possible/correct?

   That's exactly what happens, except for the last bit. RAID-0
requires at least two devices, so it can't stripe across the one
device remaining once you have completely filled /dev/sdc1 and
/dev/sdc6.

> But basically, what does not make sense to me is what df reports as
> available size.
> Look.
> Before, I had ~165G used on a total of 194G.
> I added a new disk of 465G. Now, df reports I have a total of 660G
> (that's right) with 165G used (that's correct too) but only 43G
> available!
> 
> I was expecting to have ~495G available! Where are my 465G gone?

   It's not usable with the RAID configuration you've specified, so
it's not shown.

   Hugo.

> $ df -h
> Filesystem      Size  Used Avail Use% Mounted on
> ...
> /dev/sdc1       660G  165G   43G  80% /samples
> 
> 
> 
> Thanks
> Axelle.
> 
> On Fri, Jul 26, 2013 at 9:45 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Jul 26, 2013 at 09:05:03AM +0200, Axelle wrote:
> >> Hi btrfs folks,
> >>
> >> I'm afraid I have a newbie question... but I can't sort it out? It's
> >> just about adding a disk to a btrfs volume and not getting the correct
> >> amount of GB in the end...
> >>
> >> I have a btrfs volume which already consists of two different devices
> >> and which is mounted on /samples. Its total size is 194G.
> >>
> >> $ df -h
> >> Filesystem Size Used Avail Use% Mounted on ... /dev/sdc1 194G 165G 20G
> >> 90% /samples
> >>
> >> Now, I would like to add another 500G to that volume, from another device. I did
> >>
> >> $ sudo mkfs.btrfs -m raid0 -d raid0 /dev/sdb
> >> $ sudo btrfs device add /dev/sdb /samples
> >> My filesystem now correctly reports:
> >>
> >> $ sudo btrfs filesystem show
> >> Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
> >>     Total devices 3 FS bytes used 161.98GB
> >>     devid    3 size 465.76GB used 0.00 path /dev/sdb
> >>     devid    2 size 93.13GB used 84.51GB path /dev/sdc1
> >>     devid    1 size 100.61GB used 84.53GB path /dev/sdc6
> >> But I miss some space when I do:
> >
> >    RAID-0 requires at least two devices. If you balance this
> > configuration, you'll use up the first 93.13 GiB of each device
> > striping across all three devices, for a total of 3*93.13 = 279.39
> > GiB. Then /dev/sdc1 becomes full, leaving you with two devices which
> > have 7.48 GiB and 372.63 GiB respectively. After another 7.48 GiB on
> > each device (for a total of 2*7.48 = 14.96 GiB), you have filled
> > /dev/sdc1, leaving only /dev/sdb to work with. Since there's only one
> > device, it can't be used by RAID-0.
> >
> >    If you want to use the full space available, you should rebalance
> > to single usage, which stops the RAID-0 striping, and allocates
> > linearly:
> >
> > # btrfs balance start -dconvert=single,soft /samples
> >
> >    Hugo.
> >
> >> $ df -h
> >> Filesystem      Size  Used Avail Use% Mounted on
> >> ...
> >> /dev/sdc1       660G  165G   43G  80% /samples
> >> I added 500G! Why haven't I got more available??
> >>
> >> To debug, I ran this command:
> >>
> >> $ sudo btrfs filesystem df /samples
> >> Data, RAID0: total=162.00GB, used=159.79GB
> >> Data: total=8.00MB, used=7.48MB
> >> System, RAID1: total=8.00MB, used=24.00KB
> >> System: total=4.00MB, used=0.00
> >> Metadata, RAID1: total=3.50GB, used=2.19GB
> >> Metadata: total=8.00MB, used=0.00
> >> My data is in RAID0, that's ok. So where have my 500G gone, and how
> >> can I fix this?
> >>
> >> Thanks
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
> >   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
> >            --- Sometimes, when I'm alone, I Google myself. ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I hate housework. You make the beds, you wash the dishes, and ---  
           six months later you have to start all over again.            

--umrsQkkrw7viUWFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfKLoVheFHXiqx3kAQI4Hw//QI0vDP1SXGxFnjKpYLObXFVF2A9KaKbK
6qsDTMOt8mc0ldn43JVtfNl8qh7EmWVhRxNCqi102Or5g6Wrpm1A67Yi6gl8wBrE
AjrE5Ua60j+luF+LFeCCpAbrbeCWoUnY5HHZ8UI9/npP9bMw8V3jvJWr0Y8ihdly
HApbUv/DrdKX1BnJ83LmqaN3wWt6RuAaqkoDxuLf0Kpslfn5B46t7Y9zDzLmIiji
/FXNT5Vb59As+X3/2GtjlwV/uOl44sEUsbvp3uxmWq23U6Ya1TXwazaBCQxyyuVh
/oPwWBpCddlkHnDeUVaQzDLjqFOt8DXGe6QCe/qC696CYdL2ZuArnNchqTUf/C8H
pKqpOEyDSshzic30OcjZLAy1FHKYV8uU+atWLXtHZAlFER3UJZmeyzAhhr9mzapC
voHnkArLzJYbfaVTr3UZpVqfZImgF3r4cT9WS1wP1FghMoO0TtaJy4hhGRBcYwaY
KFPgT8xawLTXxBfRQMPU0bJUyDfh4Ix7AKJGueg+0RtTyvgwWYozVDLukF9Tkux9
HpYtVN8qbUAdar1fumLDrM8LbFuyA1CwrOqikV5+ykaSXYS5RhpvpuM6PlS49xIw
3CrJuXF6guP/XnJ32h8M7X4nOlD+7h3DO13DXGzHV70WZM6p38zBI7m0SsLvMWnp
sS5KSWJcrZA=
=7opq
-----END PGP SIGNATURE-----

--umrsQkkrw7viUWFs--
