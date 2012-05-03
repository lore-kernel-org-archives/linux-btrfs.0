From: Josh Durgin <josh.durgin@dreamhost.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Thu, 03 May 2012 08:17:43 -0700
Message-ID: <f35947dc064c7ff1a073b430a2d681f5@hq.newdream.net>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120503141354.GC1914@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, <linux-btrfs@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120503141354.GC1914@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 3 May 2012 10:13:55 -0400, Josef Bacik <josef@redhat.com>
wrote:
> On Fri, Apr 27, 2012 at 01:02:08PM +0200, Christian Brunner wrote:
>> Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
>> > On Tue, 24 Apr 2012, Josef Bacik wrote:
>> >> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote=
:
>> >> > After running ceph on XFS for some time, I decided to try btrfs=
 again.
>> >> > Performance with the current "for-linux-min" branch and big met=
adata
>> >> > is much better. The only problem (?) I'm still seeing is a warn=
ing
>> >> > that seems to occur from time to time:
>> >
>> > Actually, before you do that... we have a new tool,
>> > test_filestore_workloadgen, that generates a ceph-osd-like workloa=
d on the
>> > local file system. =C2=A0It's a subset of what a full OSD might do=
, but if
>> > we're lucky it will be sufficient to reproduce this issue. =C2=A0S=
omething like
>> >
>> > =C2=A0test_filestore_workloadgen --osd-data /foo --osd-journal /ba=
r
>> >
>> > will hopefully do the trick.
>> >
>> > Christian, maybe you can see if that is able to trigger this warni=
ng?
>> > You'll need to pull it from the current master branch; it wasn't i=
n the
>> > last release.
>>
>> Trying to reproduce with test_filestore_workloadgen didn't work for
>> me. So here are some instructions on how to reproduce with a minimal
>> ceph setup.
>>
>> You will need a single system with two disks and a bit of memory.
>>
>> - Compile and install ceph (detailed instructions:
>> http://ceph.newdream.net/docs/master/ops/install/mkcephfs/)
>>
>> - For the test setup I've used two tmpfs files as journal devices. T=
o
>> create these, do the following:
>>
>> # mkdir -p /ceph/temp
>> # mount -t tmpfs tmpfs /ceph/temp
>> # dd if=3D/dev/zero of=3D/ceph/temp/journal0 count=3D500 bs=3D1024k
>> # dd if=3D/dev/zero of=3D/ceph/temp/journal1 count=3D500 bs=3D1024k
>>
>> - Now you should create and mount btrfs. Here is what I did:
>>
>> # mkfs.btrfs -l 64k -n 64k /dev/sda
>> # mkfs.btrfs -l 64k -n 64k /dev/sdb
>> # mkdir /ceph/osd.000
>> # mkdir /ceph/osd.001
>> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sda /ceph=
/osd.000
>> # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sdb /ceph=
/osd.001
>>
>> - Create /etc/ceph/ceph.conf similar to the attached ceph.conf. You
>> will probably have to change the btrfs devices and the hostname
>> (os39).
>>
>> - Create the ceph filesystems:
>>
>> # mkdir /ceph/mon
>> # mkcephfs -a -c /etc/ceph/ceph.conf
>>
>> - Start ceph (e.g. "service ceph start")
>>
>> - Now you should be able to use ceph - "ceph -s" will tell you about
>> the state of the ceph cluster.
>>
>> - "rbd create -size 100 testimg" will create an rbd image on the cep=
h cluster.
>>
>=20
> It's failing here
>=20
> http://fpaste.org/e3BG/

2012-05-03 10:11:28.818308 7fcb5a0ee700 -- 127.0.0.1:0/1003269 <=3D=3D
osd.1 127.0.0.1:6803/2379 3 =3D=3D=3D=3D osd_op_reply(3 rbd_info [call]=
 =3D -5
(Input/output error)) v4 =3D=3D=3D=3D 107+0+0 (3948821281 0 0) 0x7fcb38=
0009a0
con 0x1cad3e0

This is probably because the osd isn't finding the rbd class.
Do you have 'rbd_cls.so' in /usr/lib64/rados-classes? Wherever
rbd_cls.so is,
try adding 'osd class dir =3D /path/to/rados-classes' to the [osd]
section
in your ceph.conf, and restarting the osds.

If you set 'debug osd =3D 10' you should see '_load_class rbd' in the o=
sd
log
when you try to create an rbd image.

Autotools should be setting the default location correctly, but if
you're
running the osds in a chroot or something the path would be wrong.

Josh
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
