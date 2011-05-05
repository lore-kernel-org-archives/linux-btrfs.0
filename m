From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Having parent transid verify failed
Date: Thu, 05 May 2011 19:50:40 -0400
Message-ID: <1304639262-sup-37@think>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think> <4DC28DC4.7050308@gmail.com> <1304605365-sup-4172@think> <4DC2B3D2.6080307@gmail.com> <1304607926-sup-3304@think> <4DC3084A.7030100@gmail.com> <1304627478-sup-2626@think> <4DC310C0.5080808@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC310C0.5080808@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Konstantinos Skarlatos's message of 2011-05-05 17:04:00 -=
0400:
> On 5/5/2011 11:32 =CE=BC=CE=BC, Chris Mason wrote:
> > Excerpts from Konstantinos Skarlatos's message of 2011-05-05 16:27:=
54 -0400:
> >> I think i made some progress. When i tried to remove the directory=
 that
> >> i suspect contains the problematic file, i got this on the console
> >>
> >> rm -rf serverloft/
> >
> > Ok, our one bad block is in the extent allocation tree.  This is go=
ing
> > to be the very hardest thing to fix.
> >
> > Until I finish off the code to rebuild parts of the extent allocati=
on
> > tree, I think your best bet is to copy the files off.
> >
> > The big question is, what happened to make this error?  Can you des=
cribe
> > your setup in more detail?
>=20
> I created this btrfs filesystem on an arch linux system (amd64, quad=20
> core) with kernel 2.3.38.1. it is on top of a md raid 5.
>=20
> [root@linuxserver ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sde1[3] sdc1[1] sda1[0] sdf1[4]
>        5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2=20
> [4/4] [UUUU]
>=20
> the raid was grown from 3 devices to 4, and then btrfs was grown to m=
ax=20
> size. mount options were clear_cache,compress-force.
>=20
> I was investigating a performance issue that i had, because over the=20
> network i could only write to the filesystem at about 32mb/sec.
>=20
> when writing btrfs-delalloc- cpu usage was at 100%.
>=20
> While investigating i disabled compression, enabled space_cache and=20
> tried zlib compression, and various combinations, while copying large=
=20
> files back and forth using samba.
>=20
> BTW I tried to change some mount options using mount -o remount but=20
> although the new options were printed on dmesg i think that they were=
=20
> not enabled.
>=20
> I got the first error when i was copying some files and at the same t=
ime=20
> created a directory over samba. After a while i upgraded to 2.6.38.5 =
but=20
> nothing seems to have changed.
>=20
> I really dont think there is a hardware error here, but to be safe I =
am=20
> now running a check on the raid

This error basically means we didn't write the block.  It could be
because the write went to the wrong spot, or the hardware stack messed
it up, or because of a btrfs bug.  But, 2.6.38 is relatively recent.  I=
t
doesn't look like memory corruption because the transids are fairly
close.

When you grew the raid device, did you grow a partition as well?  We've
had trouble in the past with block dev flushing code kicking in as
devices are resized.

Samba isn't doing anything exotic, and 2.6.38 has my recent fixes for
rare metadata corruption bugs in btrfs.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
