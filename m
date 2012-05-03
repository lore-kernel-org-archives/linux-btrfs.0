From: Josef Bacik <josef@redhat.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Thu, 3 May 2012 15:49:25 -0400
Message-ID: <20120503194924.GC7313@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120503141354.GC1914@localhost.localdomain>
 <f35947dc064c7ff1a073b430a2d681f5@hq.newdream.net>
 <20120503152053.GA7313@localhost.localdomain>
 <1e9c626272411bb1fb403a3aa8aeced7@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josh Durgin <josh.durgin@dreamhost.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1e9c626272411bb1fb403a3aa8aeced7@hq.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 09:38:27AM -0700, Josh Durgin wrote:
> On Thu, 3 May 2012 11:20:53 -0400, Josef Bacik <josef@redhat.com>
> wrote:
> > On Thu, May 03, 2012 at 08:17:43AM -0700, Josh Durgin wrote:
> >> On Thu, 3 May 2012 10:13:55 -0400, Josef Bacik <josef@redhat.com>
> >> wrote:
> >> > On Fri, Apr 27, 2012 at 01:02:08PM +0200, Christian Brunner wrot=
e:
> >> >> Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
> >> >> > On Tue, 24 Apr 2012, Josef Bacik wrote:
> >> >> >> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner =
wrote:
> >> >> >> > After running ceph on XFS for some time, I decided to try =
btrfs again.
> >> >> >> > Performance with the current "for-linux-min" branch and bi=
g metadata
> >> >> >> > is much better. The only problem (?) I'm still seeing is a=
 warning
> >> >> >> > that seems to occur from time to time:
> >> >> >
> >> >> > Actually, before you do that... we have a new tool,
> >> >> > test_filestore_workloadgen, that generates a ceph-osd-like wo=
rkload on the
> >> >> > local file system. =A0It's a subset of what a full OSD might =
do, but if
> >> >> > we're lucky it will be sufficient to reproduce this issue. =A0=
Something like
> >> >> >
> >> >> > =A0test_filestore_workloadgen --osd-data /foo --osd-journal /=
bar
> >> >> >
> >> >> > will hopefully do the trick.
> >> >> >
> >> >> > Christian, maybe you can see if that is able to trigger this =
warning?
> >> >> > You'll need to pull it from the current master branch; it was=
n't in the
> >> >> > last release.
> >> >>
> >> >> Trying to reproduce with test_filestore_workloadgen didn't work=
 for
> >> >> me. So here are some instructions on how to reproduce with a mi=
nimal
> >> >> ceph setup.
> >> >>
> >> >> You will need a single system with two disks and a bit of memor=
y.
> >> >>
> >> >> - Compile and install ceph (detailed instructions:
> >> >> http://ceph.newdream.net/docs/master/ops/install/mkcephfs/)
> >> >>
> >> >> - For the test setup I've used two tmpfs files as journal devic=
es. To
> >> >> create these, do the following:
> >> >>
> >> >> # mkdir -p /ceph/temp
> >> >> # mount -t tmpfs tmpfs /ceph/temp
> >> >> # dd if=3D/dev/zero of=3D/ceph/temp/journal0 count=3D500 bs=3D1=
024k
> >> >> # dd if=3D/dev/zero of=3D/ceph/temp/journal1 count=3D500 bs=3D1=
024k
> >> >>
> >> >> - Now you should create and mount btrfs. Here is what I did:
> >> >>
> >> >> # mkfs.btrfs -l 64k -n 64k /dev/sda
> >> >> # mkfs.btrfs -l 64k -n 64k /dev/sdb
> >> >> # mkdir /ceph/osd.000
> >> >> # mkdir /ceph/osd.001
> >> >> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sda =
/ceph/osd.000
> >> >> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sdb =
/ceph/osd.001
> >> >>
> >> >> - Create /etc/ceph/ceph.conf similar to the attached ceph.conf.=
 You
> >> >> will probably have to change the btrfs devices and the hostname
> >> >> (os39).
> >> >>
> >> >> - Create the ceph filesystems:
> >> >>
> >> >> # mkdir /ceph/mon
> >> >> # mkcephfs -a -c /etc/ceph/ceph.conf
> >> >>
> >> >> - Start ceph (e.g. "service ceph start")
> >> >>
> >> >> - Now you should be able to use ceph - "ceph -s" will tell you =
about
> >> >> the state of the ceph cluster.
> >> >>
> >> >> - "rbd create -size 100 testimg" will create an rbd image on th=
e ceph cluster.
> >> >>
> >> >
> >> > It's failing here
> >> >
> >> > http://fpaste.org/e3BG/
> >>
> >> 2012-05-03 10:11:28.818308 7fcb5a0ee700 -- 127.0.0.1:0/1003269 <=3D=
=3D
> >> osd.1 127.0.0.1:6803/2379 3 =3D=3D=3D=3D osd_op_reply(3 rbd_info [=
call] =3D -5
> >> (Input/output error)) v4 =3D=3D=3D=3D 107+0+0 (3948821281 0 0) 0x7=
fcb380009a0
> >> con 0x1cad3e0
> >>
> >> This is probably because the osd isn't finding the rbd class.
> >> Do you have 'rbd_cls.so' in /usr/lib64/rados-classes? Wherever
> >> rbd_cls.so is,
> >> try adding 'osd class dir =3D /path/to/rados-classes' to the [osd]
> >> section
> >> in your ceph.conf, and restarting the osds.
> >>
> >> If you set 'debug osd =3D 10' you should see '_load_class rbd' in =
the osd
> >> log
> >> when you try to create an rbd image.
> >>
> >> Autotools should be setting the default location correctly, but if
> >> you're
> >> running the osds in a chroot or something the path would be wrong.
> >>
> >=20
> > Yeah all that was in the right place, I rebooted and I magically
> > stopped getting
> > that error, but now I'm getting this
> >=20
> > http://fpaste.org/OE92/
> >=20
> > with that ping thing repeating over and over.  Thanks,
>=20
> That just looks like the osd isn't running. If you restart the
> osd with 'debug osd =3D 20' the osd log should tell us what's going o=
n.

Ok that part was my fault, Duh I need to redo the tmpfs and mkcephfs st=
uff after
reboot.  But now I'm back to my original problem

http://fpaste.org/PfwO/

I have the osd class dir =3D /usr/lib64/rados-classes thing set and lib=
cls_rbd is
in there, so I'm not sure what is wrong.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
