From: "Robert G." <ruppertus@o2.pl>
Subject: Fw: no space left on device - critical issue
Date: Sun, 15 Aug 2010 15:05:31 +0200
Message-ID: <20100815150531.147b5ad8@leni>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Guys,
I've noticed the same issue.
Just look at the mail history.
I think it might be a critical problem.
Regards
Robert

Pocz=C4=85tek przekazywanej wiadomo=C5=9Bci:

Data: Sun, 15 Aug 2010 09:15:16 +0200
Od: Lubos Kolouch <lubos.kolouch@gmail.com>
Do: "Robert G." <ruppertus@o2.pl>
Temat: Re: no space left on device - critical issue


Hi

I think you sent it just to me and not to the list ;)

Lubos

On Ne, srp 15, 2010, 04:28:15, Robert G. wrote:
> Hi guys,
>=20
> I have exactly the same situation.
> I use 2.6.35 kernel and btrfs-tools 0.19+201006 (from debian testing
> distro). System says there is no space on /home partition even though
> it's plenty of it.
> I have ssd disk and mount filesystem with ssd option.
> It's rather critical issue.
>=20
> root@leni:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: 'root'  uuid: a4e12457-f608-47f1-a9b2-ac68dbc3f5cc
> 	Total devices 1 FS bytes used 9.47GB
> 	devid    1 size 29.30GB used 29.30GB path /dev/sda5
>=20
> Label: 'tmp'  uuid: 718bbcc2-1087-4f41-a90a-287a015eca02
> 	Total devices 1 FS bytes used 1.77MB
> 	devid    1 size 10.00GB used 9.03GB path /dev/sda6
>=20
> Label: 'home'  uuid: f714cbe0-c952-4821-a3b7-db3be5daa99f
> 	Total devices 1 FS bytes used 33.95GB
> 	devid    1 size 48.30GB used 48.30GB path /dev/sda8
>=20
> Btrfs Btrfs v0.19
> root@leni:~# btrfs filesystem df /home
> Data: total=3D33.77GB, used=3D33.71GB
> Metadata: total=3D7.26GB, used=3D242.59MB
> System: total=3D12.00MB, used=3D12.00KB
> root@leni:~#=20
>=20
> root@leni:~# df -h
> System plik=C3=B3w         rozm. u=C5=BCyte dost. %u=C5=BC. zamont. n=
a
> /dev/sda5              30G   11G   20G  35% /
> tmpfs                 2,0G     0  2,0G   0% /lib/init/rw
> udev                   10M  264K  9,8M   3% /dev
> tmpfs                 2,0G     0  2,0G   0% /dev/shm
> /dev/sda3             258M   57M  188M  24% /boot
> /dev/sda8              49G   35G   15G  71% /home
> /dev/sda6              10G  1,9M   10G   1% /tmp
>=20
> root@leni:~# mount | grep btrfs
> /dev/sda5 on / type btrfs (rw,ssd)
> /dev/sda8 on /home type btrfs (rw,ssd)
> /dev/sda6 on /tmp type btrfs (rw,ssd)
>=20
>=20
> Regards
> Robert
>=20
>=20
>=20
> Dnia 2010-08-14, o godz. 20:15:49
> Lubos Kolouch <lubos.kolouch@gmail.com> napisa=C5=82(a):
>=20
> > I have another example with 2.6.35-r1 and latest btrfs-progs
> >=20
> > # btrfs filesystem show
> > Label: none  uuid: 46c7a8b4-ca13-4b4f-a695-6a0e31112411
> > 	Total devices 2 FS bytes used 1.23TB
> > 	devid    1 size 896.39GB used 896.39GB path /dev/dm-0
> > 	devid    2 size 896.39GB used 896.25GB path /dev/dm-1
> >=20
> > # btrfs filesystem df /home
> > Data: total=3D1.74TB, used=3D1.23TB
> > Metadata: total=3D3.01GB, used=3D2.18GB
> > System: total=3D12.00MB, used=3D200.00KB
> >=20
> > So there should be plenty of space left, but I am getting messages
> > that the device is out of free space.
> >=20
> > Anything I can try to debug this?
> >=20
> > Thank you
> >=20
> > Lubos
> >=20
> >=20
> > Lubos Kolouch, Fri, 30 Jul 2010 15:09:59 +0000:
> >=20
> > > correction - btrfs-cache processes
> > >=20
> > > Lubos Kolouch, Fri, 30 Jul 2010 15:02:18 +0000:
> > >=20
> > >> With 2.6.34 it basically "works", but time to time the load goes
> > >> up to 50 and lot of btrfs-cleaner processess are spawned... the
> > >> system is responsive though, except for the filesystem... after
> > >> an hour or so the processes finish and the load goes back to
> > >> normal
> > >>=20
> > >> Lubos
> > >>=20
> > >>> On Fri, Jul 30, 2010 at 3:26 PM, Leonidas Spyropoulos
> > >>> <artafinde@gmail.com> wrote:
> > >>>> I use the latest btrfs-tools and 2.6.34-020634-generic kernel
> > >>>> for lucid. Got no issues like that, is it happening with 2.6.3=
4
> > >>>> kernel as well?
> > >>>>
> > >>>> On Fri, Jul 30, 2010 at 1:27 PM, Lubos Kolouch
> > >>>> <lubos.kolouch@gmail.com> wrote:
> > >>>>>
> > >>>>> Yes, I pulled today's btrfs-progs.
> > >>>>>
> > >>>>> Lubos
> > >>>>>
> > >>>>> On P=C3=A1, =C4=8Dec 30, 2010, 13:03:10, Leonidas Spyropoulos=
 wrote:
> > >>>>> > Have you updated with latest btrfs-tools?
> > >>>>> >
> > >>>>> > On Fri, Jul 30, 2010 at 6:31 AM, Lubos Kolouch
> > >>>>> > <lubos.kolouch@gmail.com>wrote:
> > >>>>> >
> > >>>>> > > Hello,
> > >>>>> > >
> > >>>>> > > kerner 2.6.35-rc6
> > >>>>> > >
> > >>>>> > > btrfs filesystem df /home
> > >>>>> > > Data: total=3D1.68TB, used=3D987.62GB
> > >>>>> > > Metadata: total=3D56.01GB, used=3D48.16GB System:
> > >>>>> > > total=3D12.00MB, used=3D200.00KB
> > >>>>> > >
> > >>>>> > > touch: cannot touch `/home/x': No space left on device
> > >>>>> > >
> > >>>>> > > Any ideas what I should do?
> > >>>>> > >
> > >>>>> > > Thank you
> > >>>>> > >
> > >>>>> > > Lubos
> > >>>>> > >
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
