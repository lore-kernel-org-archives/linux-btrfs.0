From: Chris Mason <chris.mason@ORACLE.COM>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 10:33:09 -0400
Message-ID: <20091007143309.GF3757@think>
References: <200910062048.32381.diegocg@gmail.com>
 <20091007031754.GB3757@think>
 <200910071551.46430.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910071551.46430.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2009 at 03:51:46PM +0200, Diego Calleja wrote:
> On Wednesday 07 October 2009 05:17:54 Chris Mason escribi=F3:
>=20
> > Thanks, I'll try to reproduce.  Which raid level did you use for da=
ta?
> > If not raid1, could you try with raid1? ;)
>=20
> I'm not sure, since the utils won't tell. I mkfs'ed and mounted one o=
f the 3.5GB
> files with no special options, and copied some files on it. I mkfs'ed=
 the second
> file, put it in a loop device, and added it to the pool with btrfs-vo=
l -a. Then
> I run btrfs-vol -b and I copied more files and rebalanced several tim=
es.
>=20
> Then I zeroed one of the files used as disks, and tried to read the f=
iles in
> the volume (unsucessfully). Then I rebalanced, and I hit the oops. It=
 seems to
> be very reproducible.

Ok, in this case you ended up with raid0 on the data.  If you:

mkfs.btrfs -d raid1 /dev/loop0 /dev/loop1 you'll get data raid1.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
