From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Ceph on btrfs 3.4rc
Date: Fri, 27 Apr 2012 13:02:08 +0200
Message-ID: <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
	<20120424152141.GB3326@localhost.localdomain>
	<Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae93410eb2188b704bea70980
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

--14dae93410eb2188b704bea70980
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
> On Tue, 24 Apr 2012, Josef Bacik wrote:
>> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote:
>> > After running ceph on XFS for some time, I decided to try btrfs again.
>> > Performance with the current "for-linux-min" branch and big metadata
>> > is much better. The only problem (?) I'm still seeing is a warning
>> > that seems to occur from time to time:
>
> Actually, before you do that... we have a new tool,
> test_filestore_workloadgen, that generates a ceph-osd-like workload on th=
e
> local file system. =A0It's a subset of what a full OSD might do, but if
> we're lucky it will be sufficient to reproduce this issue. =A0Something l=
ike
>
> =A0test_filestore_workloadgen --osd-data /foo --osd-journal /bar
>
> will hopefully do the trick.
>
> Christian, maybe you can see if that is able to trigger this warning?
> You'll need to pull it from the current master branch; it wasn't in the
> last release.

Trying to reproduce with test_filestore_workloadgen didn't work for
me. So here are some instructions on how to reproduce with a minimal
ceph setup.

You will need a single system with two disks and a bit of memory.

- Compile and install ceph (detailed instructions:
http://ceph.newdream.net/docs/master/ops/install/mkcephfs/)

- For the test setup I've used two tmpfs files as journal devices. To
create these, do the following:

# mkdir -p /ceph/temp
# mount -t tmpfs tmpfs /ceph/temp
# dd if=3D/dev/zero of=3D/ceph/temp/journal0 count=3D500 bs=3D1024k
# dd if=3D/dev/zero of=3D/ceph/temp/journal1 count=3D500 bs=3D1024k

- Now you should create and mount btrfs. Here is what I did:

# mkfs.btrfs -l 64k -n 64k /dev/sda
# mkfs.btrfs -l 64k -n 64k /dev/sdb
# mkdir /ceph/osd.000
# mkdir /ceph/osd.001
# mount -o noatime,space_cache,inode_cache,autodefrag /dev/sda /ceph/osd.00=
0
# mount -o noatime,space_cache,inode_cache,autodefrag /dev/sdb /ceph/osd.00=
1

- Create /etc/ceph/ceph.conf similar to the attached ceph.conf. You
will probably have to change the btrfs devices and the hostname
(os39).

- Create the ceph filesystems:

# mkdir /ceph/mon
# mkcephfs -a -c /etc/ceph/ceph.conf

- Start ceph (e.g. "service ceph start")

- Now you should be able to use ceph - "ceph -s" will tell you about
the state of the ceph cluster.

- "rbd create -size 100 testimg" will create an rbd image on the ceph clust=
er.

- Compile my test with "gcc -o rbdtest rbdtest.c -lrbd" and run it
with "./rbdtest testimg".

I can see the first btrfs_orphan_commit_root warning after an hour or
so... I hope that I've described all necessary steps. If there is a
problem just send me a note.

Thanks,
Christian

--14dae93410eb2188b704bea70980
Content-Type: application/octet-stream; name="ceph.conf"
Content-Disposition: attachment; filename="ceph.conf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1j4o9g20

W2dsb2JhbF0KICAgICAgICBhdXRoIHN1cHBvcnRlZCA9IG5vbmUgCglkZWJ1ZyBvcHRyYWNrZXIg
PSAwIDsgdG8gd29yayBhcnJvdW5kIGEgbG9nIHByb2JsZW0gaW4gY2VwaCAwLjQ1CgpbbW9uXQog
ICAgICAgIG1vbiBkYXRhID0gL2NlcGgvbW9uCgpbbW9uLjBdCiAgICAgICAgaG9zdCA9IG9zMzkK
ICAgICAgICBtb24gYWRkciA9IDEyNy4wLjAuMTo2Nzg5Cgpbb3NkXQogICAgICAgIG9zZCBkYXRh
ID0gL2NlcGgvb3NkLiRpZAoJb3NkIGNsYXNzIGRpciA9IC91c3IvbGliNjQvcmFkb3MtY2xhc3Nl
cwoKW29zZC4wMDBdCiAgICAgICAgaG9zdCA9IG9zMzkKICAgICAgICBvc2Qgam91cm5hbCA9IC9j
ZXBoL3RlbXAvam91cm5hbDAKICAgICAgICBvc2Qgam91cm5hbCBzaXplID0gNTAwTQoJam91cm5h
bCBkaW8gPSBGYWxzZQogICAgICAgIGJ0cmZzIGRldnMgPSAiL2Rldi9zZGEiCgpbb3NkLjAwMV0K
ICAgICAgICBob3N0ID0gb3MzOQogICAgICAgIG9zZCBqb3VybmFsID0gL2NlcGgvdGVtcC9qb3Vy
bmFsMQogICAgICAgIG9zZCBqb3VybmFsIHNpemUgPSA1MDBNCiAgICAgICAgam91cm5hbCBkaW8g
PSBGYWxzZQogICAgICAgIGJ0cmZzIGRldnMgPSAiL2Rldi9zZGIiCg==
--14dae93410eb2188b704bea70980--
