From: Josef Bacik <josef@redhat.com>
Subject: Re: 'filesystem resize max' tries to use devid 1
Date: Tue, 24 Apr 2012 11:42:26 -0400
Message-ID: <20120424154225.GE3326@localhost.localdomain>
References: <CAJwq8q6Dd-Z6z=1H5h8m9TE8aBioY9x99ZBsGWa7pRdbVtDZOQ@mail.gmail.com>
 <20120424153114.GD3326@localhost.localdomain>
 <20120424153903.GA1928@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Jeremy Atkins <antrat@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120424153903.GA1928@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 06:39:03PM +0300, Ilya Dryomov wrote:
> On Tue, Apr 24, 2012 at 11:31:15AM -0400, Josef Bacik wrote:
> > On Sun, Apr 22, 2012 at 11:03:06PM -0400, Jeremy Atkins wrote:
> > > Back story:
> > > I started my pool with a 200gb partition at the end of my drive (=
sdc5)
> > > , until I was able to clear out the data at the beginning of my d=
rive.
> > >  When I was ready, I ran `btrfs dev add /dev/sdc4 /` then `btrfs =
dev
> > > del /dev/sdc5 /`,
> > >=20
> > > $ sudo btrfs fi resize max /
> > > Resize '/' of 'max'
> > > ERROR: unable to resize '/' - Invalid argument
> > >=20
> > > in dmesg i see:
> > > [ =A0 72.729685] btrfs: resizer unable to find device 1
> > >=20
> > > $ sudo btrfs fi df /
> > > Data: total=3D34.00GB, used=3D17.79GB
> > > System, DUP: total=3D64.00MB, used=3D20.00KB
> > > Metadata, DUP: total=3D33.50GB, used=3D394.93MB
> > >=20
> > > $ sudo btrfs fi sh
> > > Label: none =A0uuid: b0ad55e2-09e0-4658-8cab-d2e11ba03753
> > > =A0 =A0 =A0 =A0 Total devices 1 FS bytes used 17.18GB
> > > =A0 =A0 =A0 =A0 devid =A0 =A02 size 1.62TB used 101.12GB path /de=
v/sdc4
> > >=20
> > >=20
> > > $ uname -r
> > > 3.3.2-1.fc16.x86_64
> > >=20
> > > btrfs-progs version is current git master ( commit 1957076 )
> > >=20
> > > After writing this email, and searching around the wiki some, I
> > > discovered the command to resize specific devids,
> > >=20
> > > [antrat@tbox ~]$ sudo btrfs fi resize 2:max /
> > > Resize '/' of '2:max'
> > >=20
> > > and in dmesg:
> > > [ 1661.933884] btrfs: resizing devid 2
> > > [ 1661.933895] btrfs: new size for /dev/sdc4 is 1995564908544
> >=20
> > Hrm, if we're using filesystem resize max we should probably just m=
ax out all
> > the devices and not require one specific device, what do you think =
Ilya?
>=20
> I'd keep the devid:max syntax for maxing out a single device and add =
a
> new fs:max or similar to resize all devices.  ABI here is just a stri=
ng,
> so I think it can be easily done.
>=20

Right I think the devid:max thing is handy for people who want to do sp=
ecific
things, but I think just a normal btrfs fi resize max should do all dev=
ices for
simplicity and easy of use, no need for a fs:max.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
