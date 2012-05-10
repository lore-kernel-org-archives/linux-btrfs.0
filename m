From: Josef Bacik <josef@redhat.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Thu, 10 May 2012 13:40:38 -0400
Message-ID: <20120510174038.GA2061@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Sage Weil <sage@newdream.net>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Christian Brunner <christian@brunner-muc.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2012 at 01:02:08PM +0200, Christian Brunner wrote:
> Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
> > On Tue, 24 Apr 2012, Josef Bacik wrote:
> >> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote:
> >> > After running ceph on XFS for some time, I decided to try btrfs =
again.
> >> > Performance with the current "for-linux-min" branch and big meta=
data
> >> > is much better. The only problem (?) I'm still seeing is a warni=
ng
> >> > that seems to occur from time to time:
> >
> > Actually, before you do that... we have a new tool,
> > test_filestore_workloadgen, that generates a ceph-osd-like workload=
 on the
> > local file system. =A0It's a subset of what a full OSD might do, bu=
t if
> > we're lucky it will be sufficient to reproduce this issue. =A0Somet=
hing like
> >
> > =A0test_filestore_workloadgen --osd-data /foo --osd-journal /bar
> >
> > will hopefully do the trick.
> >
> > Christian, maybe you can see if that is able to trigger this warnin=
g?
> > You'll need to pull it from the current master branch; it wasn't in=
 the
> > last release.
>=20
> Trying to reproduce with test_filestore_workloadgen didn't work for
> me. So here are some instructions on how to reproduce with a minimal
> ceph setup.
>=20
> You will need a single system with two disks and a bit of memory.
>=20
> - Compile and install ceph (detailed instructions:
> http://ceph.newdream.net/docs/master/ops/install/mkcephfs/)
>=20
> - For the test setup I've used two tmpfs files as journal devices. To
> create these, do the following:
>=20
> # mkdir -p /ceph/temp
> # mount -t tmpfs tmpfs /ceph/temp
> # dd if=3D/dev/zero of=3D/ceph/temp/journal0 count=3D500 bs=3D1024k
> # dd if=3D/dev/zero of=3D/ceph/temp/journal1 count=3D500 bs=3D1024k
>=20
> - Now you should create and mount btrfs. Here is what I did:
>=20
> # mkfs.btrfs -l 64k -n 64k /dev/sda
> # mkfs.btrfs -l 64k -n 64k /dev/sdb
> # mkdir /ceph/osd.000
> # mkdir /ceph/osd.001
> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sda /ceph/=
osd.000
> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sdb /ceph/=
osd.001
>=20
> - Create /etc/ceph/ceph.conf similar to the attached ceph.conf. You
> will probably have to change the btrfs devices and the hostname
> (os39).
>=20
> - Create the ceph filesystems:
>=20
> # mkdir /ceph/mon
> # mkcephfs -a -c /etc/ceph/ceph.conf
>=20
> - Start ceph (e.g. "service ceph start")
>=20
> - Now you should be able to use ceph - "ceph -s" will tell you about
> the state of the ceph cluster.
>=20
> - "rbd create -size 100 testimg" will create an rbd image on the ceph=
 cluster.
>=20
> - Compile my test with "gcc -o rbdtest rbdtest.c -lrbd" and run it
> with "./rbdtest testimg".
>=20
> I can see the first btrfs_orphan_commit_root warning after an hour or
> so... I hope that I've described all necessary steps. If there is a
> problem just send me a note.
>=20

Well it's only taken me 2 weeks but I've finally git it all up and runn=
ing,
hopefully I'll reproduce.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
