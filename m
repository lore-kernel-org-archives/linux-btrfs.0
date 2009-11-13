From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck: checksum verify failed
Date: Fri, 13 Nov 2009 16:17:29 -0500
Message-ID: <20091113211729.GE11332@think>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
 <20091112140233.GB5211@think>
 <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
 <20091112145051.GB3196@think>
 <a4423d670911120743o3759d594v533bc6ff8cdedd9@mail.gmail.com>
 <20091112172502.GA2811@think>
 <a4423d670911120941x47ca35e7l661e13861dba750e@mail.gmail.com>
 <20091112200349.GB2811@think>
 <a4423d670911121344k4b2fbc5j165525602f801aa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670911121344k4b2fbc5j165525602f801aa4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2009 at 12:44:47AM +0300, Alexander Beregalov wrote:
> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> > On Thu, Nov 12, 2009 at 08:41:44PM +0300, Alexander Beregalov wrote=
:
> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> >> > On Thu, Nov 12, 2009 at 06:43:00PM +0300, Alexander Beregalov wr=
ote:
> >> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> >> >> > On Thu, Nov 12, 2009 at 05:16:34PM +0300, Alexander Beregalov=
 wrote:
> >> >> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> >> >> >> > On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Berega=
lov wrote:
> >> >> >> >> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum=
 verify
> >> >> >> >> failed";echo; done
> >> >> >> >> checksum verify failed on 31945617408 wanted 6607632D fou=
nd 9CC3ED0
> >> >> >> >> checksum verify failed on 31945617408 wanted 6607632D fou=
nd AFBBF41
> >> >> >> >
> >> >> >> > Was your filesystem mounted at the time? =A0It's strange t=
hat the checksum
> >> >> >> > keeps changing, that points to the data in the block chang=
ing.
> >> >> >>
> >> >> >> It was not.
> >> >> >> Any tips how I can try to find a root cause?
> >> >> >> It is raid0 of two disks.
> >> >> >
> >> >> > Well, I'd start by looking for anything else that could be to=
uching the
> >> >> > FS or the devices. =A0You shouldn't see more than two differe=
nt csums in this
> >> >> > configuration (one from each disk).
> >> >> I always see only these two blocks in output.
> >> >
> >> > The wanted is always the same but the found is always different?
> >>
> >> Yes, exactly. The bits marked as X look as random.
> >
> > Ok, I've added a new tool to the btrfs-unstable-progs repo. =A0It i=
s
> > called btrfs-map-logical and it will print the logical->physical ma=
pping
> > for any metadata or data block in the FS. =A0The FS should not be m=
ounted
> > when you run this program...it'll mostly work mounted but the resul=
ts
> > won't be 100% accurate.
> >
> > For your case:
> >
> > btrfs-map-logical -l 31945617408 -c 1 -o mirror1 /dev/sde
> > btrfs-map-logical -l 31945617408 -c 2 -o mirror2 /dev/sde
> >
> > This will print to the screen the mappings for that block and also =
save
> > the contents of the first mirror of the block to a file called mirr=
or1.
> > The second command will save the contents of the second mirror.
> >
> > If the FS isn't mounted and isn't being changed by someone else, yo=
u
> > should get exactly the same mappings every time and exactly the sam=
e
> > contents in the files mirror1 and mirror2 every time.
> >
> > Just let me know if you have any problems. =A0The most recent commi=
t in
> > the btrfs-progs repo is:
> >
> > commit ab8fb4c99516c186641bda1dbc0e788f68b4dc77
> > Author: Chris Mason <chris.mason@oracle.com>
> > Date: =A0 Thu Nov 12 14:34:09 2009 -0500
> >
> > =A0 =A0Add btrfs-map-logical program to map and read logical block =
numbers
> >
> > If you check kernel.org and this commit isn't there, just try again=
 ;)
> > The mirror takes a few minutes to update. =A0I'm pretty sure it goe=
s
> > faster if you hit reload over and over again, but that's just a gue=
ss.
> >
> > -chris
> >
>=20
> sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 1 -o /tmp/mirror1
> /dev/sde; md5sum /tmp/mirror1
> mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
> mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
> bcce5ab8cc65c948650376e936952547  /tmp/mirror1
>=20
> sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 2 -o /tmp/mirror2
> /dev/sde; md5sum /tmp/mirror2
> mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
> mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
> 347034331d8879096e262a736fd02ba0  /tmp/mirror2
>=20
> sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 1 -o /tmp/mirror1
> /dev/sde; md5sum /tmp/mirror1
> mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
> mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
> bcce5ab8cc65c948650376e936952547  /tmp/mirror1
>=20
> sh-4.0$  sudo ./btrfs-map-logical -l 31945617408 -c 2 -o /tmp/mirror2
> /dev/sde; md5sum /tmp/mirror2
> mirror 1 logical 31945617408 physical 16913231872 device /dev/sde
> mirror 2 logical 31945617408 physical 16893308928 device /dev/sdf
> 347034331d8879096e262a736fd02ba0  /tmp/mirror2

You're getting different answers for the two blocks, which is ok (one
could be corrupt).  What doesn't make sense is that btrfsck isn't
dealing with this correctly.  When you read both copies again, you get
the same answers as the first time, so this looks like a btrfsck bug to
me.

I'll try to reproduce.  If you're in a hurry, you could do something
like this (with the FS unmounted).  Keep a good copy of both mirror1 an=
d
mirror2

dd if=3D/tmp/mirror1 of=3D/dev/sde bs=3D1 seek=3D16913231872 count=3D40=
96
dd if=3D/tmp/mirror1 of=3D/dev/sdf bs=3D1 seek=3D16893308928 count=3D40=
96
sync

btrfsck.  If that doesn't work:

dd if=3D/tmp/mirror2 of=3D/dev/sde bs=3D1 seek=3D16913231872 count=3D40=
96
dd if=3D/tmp/mirror2 of=3D/dev/sdf bs=3D1 seek=3D16893308928 count=3D40=
96

btrfsck again.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
