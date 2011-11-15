From: Josef Bacik <josef@redhat.com>
Subject: Re: Reliability questions / "me too" for bugs
Date: Tue, 15 Nov 2011 09:17:40 -0500
Message-ID: <20111115141740.GA1948@localhost.localdomain>
References: <20111114171213.1f4279ae@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: lkml <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-kernel@zougloub.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111114171213.1f4279ae@Bidule>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2011 at 05:12:13PM -0500, J=E9r=F4me Carretero wrote:
> I have a couple of questions concerning btrfs reliability.
>=20
> I'm currently using btrfs in my internal drives (strong advantages) a=
nd have used it on external drives, but I've recently migrated the exte=
rnal ones to ext4, for reliability reasons.
> The kernel seems to be able to handle ext4 partition disconnections (=
drive error, cable gets eaten by rodent, or most commonly, unplugged to=
o early on removable drives...) quite gracefully.
> This is not yet the case for btrfs partitions (deadlocks, various oop=
ses, need to reboot).
> Any idea when this will be available ?
>=20

At some point in the future.  We know it's a problem, but as you can se=
e from
your nice list at the end, we have lot's of problems working properly w=
hen the
drives are plugged in and behaving fine ;).

> How to handle bad blocks (sometimes, they are very localized on HDDs,=
 and they will happen on old SSDs) ?
>=20
> Imagine the following use case:
>  - get untrusted drive from dumpster
>  - check that it runs, and has an acceptable amount of bad block clus=
ters
>  - add the drive to a btrfs pool, which guarantees that its data will=
 be duplicated somewhere else
>  - enjoy the drive while it lasts
>  - ability to retrieve bad blocks map later on
>  - ability to cleanly remove the drive from the pool if it becomes us=
eless (found a better one) or dies (see first question)
>    when that happens, data gets replicated to other locations...
>    data replication could be done automatically by background scrubbi=
ng with some mount flag or ioctl
> How far are we from that ? Will we get there some day ?
>=20
>=20
> Since I'm here, a few random and useless notes, as I'm currently test=
ing v3.2-rc1-284-g52e4c2a and I see a few bugs, deadlocks and weirdness=
es.
> I don't know if it's normal for -rc1, maybe.
> My current workload is "rsync 1.5TB from SATA to USB2+3 (500+1000GB i=
n raid0) and vice versa".
> The load average can grow to 15.
> I've ran into BUG at fs/btrfs/inode.c:1795 (http://comments.gmane.org=
/gmane.comp.file-systems.btrfs/14128).
> I've ran into WARNING: at fs/btrfs/free-space-cache.c:1847 btrfs_remo=
ve_free_space+0x1a3/0x287() [1]
> I've also ran into INFO: task btrfs-transacti:1465 blocked for more t=
han 120 seconds. [2]
> Sometimes linux is writing I don't know what for a looooooong time on=
 drives, and there's nothing in cache.
> Sometimes rsync stops, doing nothing. It will somehow restart after I=
 do a "echo 3 > /proc/sys/vm/drop_caches"...
> I see that a lot of features will be added for 3.2 but I hope they wi=
ll be well tested !

So the inode one was fixed recently, Chris sent the patch to Linus this=
 weekend
so upgrade to that and you should be good.  The free_space_cache one is=
 a new
one on me, how often do you hit it?  And as for the transaction thing, =
if it
happens again can you do sysrq+w?  Sometimes the guy hanging everybody =
up
doesn't get printed out so we only get part of the picture, sysrq+w wil=
l give us
all waiters so we can figure out whats going on.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
