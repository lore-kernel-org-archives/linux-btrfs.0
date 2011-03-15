From: Leon =?iso-8859-15?Q?Me=DFner?= <l.messner@physik.tu-berlin.de>
Subject: Re: btrfs mount segfaults or crashes after powerloss
Date: Tue, 15 Mar 2011 18:26:17 +0100
Message-ID: <20110315172617.GD37926@emmi.physik-pool.tu-berlin.de>
References: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de>
 <1300208269-sup-5260@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Leon =?iso-8859-15?Q?Me=DFner?= <l.messner@physik.tu-berlin.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300208269-sup-5260@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2011 at 12:58:43PM -0400, Chris Mason wrote:
> Excerpts from Leon Me=DFner's message of 2011-03-14 20:28:56 -0400:
> > Hi,
> >=20
> > i'm having a problem with a damaged btrfs after power loss. When i =
try
> > to mount the fs mount either segfaults (trace at bottom) or hangs i=
n=20
> > "D" state together with [btrfs-transacti].
> >=20
> > Please CC me as i'm not an the list.
> > # btrfsck -s 1 /dev/sdb2
>=20
> Does btrfsck /dev/sdb2 work?  -s 1 selects a different super, hopeful=
ly
> all the supers are the same.  If plain btrfsck runs without failing w=
e
> can easily work around the log tree crash.

Yes it does (i think), output is below.

# btrfsck /dev/sdb2
root 256 inode 257 errors 800
found 50907959296 bytes used err is 1
total csum bytes: 46730092
total tree bytes: 407293952
total fs tree bytes: 315609088
btree space waste bytes: 111966302
file data blocks allocated: 184320000000
 referenced 56142348288
Btrfs v0.19-35-g1b444cd

thanks,
Leon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
