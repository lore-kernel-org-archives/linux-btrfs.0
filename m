From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 'filesystem resize max' tries to use devid 1
Date: Tue, 24 Apr 2012 11:59:20 -0400
Message-ID: <20120424155920.GM22794@shiny>
References: <CAJwq8q6Dd-Z6z=1H5h8m9TE8aBioY9x99ZBsGWa7pRdbVtDZOQ@mail.gmail.com>
 <20120424153114.GD3326@localhost.localdomain>
 <20120424153903.GA1928@zambezi.lan>
 <20120424154225.GE3326@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Jeremy Atkins <antrat@gmail.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120424154225.GE3326@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 11:42:26AM -0400, Josef Bacik wrote:
> On Tue, Apr 24, 2012 at 06:39:03PM +0300, Ilya Dryomov wrote:
> > On Tue, Apr 24, 2012 at 11:31:15AM -0400, Josef Bacik wrote:
> > > On Sun, Apr 22, 2012 at 11:03:06PM -0400, Jeremy Atkins wrote:
> > > > Back story:
> > > > I started my pool with a 200gb partition at the end of my drive=
 (sdc5)
> > > > , until I was able to clear out the data at the beginning of my=
 drive.
> > > >  When I was ready, I ran `btrfs dev add /dev/sdc4 /` then `btrf=
s dev
> > > > del /dev/sdc5 /`,
> > > >=20
> > > > $ sudo btrfs fi resize max /
> > > > Resize '/' of 'max'
> > > > ERROR: unable to resize '/' - Invalid argument
> > > >=20
> > > > in dmesg i see:
> > > > [ =A0 72.729685] btrfs: resizer unable to find device 1
> > > >=20
> > > > $ sudo btrfs fi df /
> > > > Data: total=3D34.00GB, used=3D17.79GB
> > > > System, DUP: total=3D64.00MB, used=3D20.00KB
> > > > Metadata, DUP: total=3D33.50GB, used=3D394.93MB
> > > >=20
> > > > $ sudo btrfs fi sh
> > > > Label: none =A0uuid: b0ad55e2-09e0-4658-8cab-d2e11ba03753
> > > > =A0 =A0 =A0 =A0 Total devices 1 FS bytes used 17.18GB
> > > > =A0 =A0 =A0 =A0 devid =A0 =A02 size 1.62TB used 101.12GB path /=
dev/sdc4
> > > >=20
> > > >=20
> > > > $ uname -r
> > > > 3.3.2-1.fc16.x86_64
> > > >=20
> > > > btrfs-progs version is current git master ( commit 1957076 )
> > > >=20
> > > > After writing this email, and searching around the wiki some, I
> > > > discovered the command to resize specific devids,
> > > >=20
> > > > [antrat@tbox ~]$ sudo btrfs fi resize 2:max /
> > > > Resize '/' of '2:max'
> > > >=20
> > > > and in dmesg:
> > > > [ 1661.933884] btrfs: resizing devid 2
> > > > [ 1661.933895] btrfs: new size for /dev/sdc4 is 1995564908544
> > >=20
> > > Hrm, if we're using filesystem resize max we should probably just=
 max out all
> > > the devices and not require one specific device, what do you thin=
k Ilya?
> >=20
> > I'd keep the devid:max syntax for maxing out a single device and ad=
d a
> > new fs:max or similar to resize all devices.  ABI here is just a st=
ring,
> > so I think it can be easily done.
> >=20
>=20
> Right I think the devid:max thing is handy for people who want to do =
specific
> things, but I think just a normal btrfs fi resize max should do all d=
evices for
> simplicity and easy of use, no need for a fs:max.  Thanks,
>=20

Agreed, I hadn't thought of it this way in the past, but I can see
people expecting max to mean max out all the devices.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
