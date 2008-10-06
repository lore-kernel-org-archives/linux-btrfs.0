From: Josef Bacik <jbacik@redhat.com>
Subject: Re: space info full
Date: Mon, 6 Oct 2008 14:27:24 -0400
Message-ID: <20081006182723.GB2840@unused.rdu.redhat.com>
References: <200810040945.56118.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin =?iso-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810040945.56118.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 04, 2008 at 09:45:55AM +0200, Martin B=FCrger wrote:
> Hello,
> 'space info full' was the only message I got from dmesg. df reports:
>

space info full doesn't mean the disk is full, just means we've allocat=
ed all of
the block group chunks that the filesystem can hold, so you will get th=
at
message well before you actually run out of disk space.  As it stands n=
ow btrfs
has a short circuit when you hit ~15% free to go ahead an ENOSPC to avo=
id
hitting the many BUG()'s that are sitting around to handle ENOSPC.
=20
> /dev/sdb1             33551720  28504548   5047172 =20
> 85% /mnt/btrfstest
>=20
> df -i reports:
> /dev/sdb1                  0       0       0    -  /mnt/btrfstest
>=20
> Any (e.g., touch, rm) operation on that mounted filesystem lets the=20
> CPU rise and the system hang...
>

are you running the latest git trees of both btrfs-unstable and
btrfs-progs-unstable?  I'd expect BUG()'s or something like that, shoul=
dn't be
getting hangs.  Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
