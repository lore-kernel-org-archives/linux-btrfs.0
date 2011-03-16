From: Leon =?iso-8859-15?Q?Me=DFner?= <l.messner@physik.tu-berlin.de>
Subject: Re: btrfs mount segfaults or crashes after powerloss
Date: Wed, 16 Mar 2011 21:03:03 +0100
Message-ID: <20110316200303.GA5711@emmi.physik-pool.tu-berlin.de>
References: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de>
 <1300208269-sup-5260@think>
 <20110315172617.GD37926@emmi.physik-pool.tu-berlin.de>
 <1300304176-sup-1475@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Leon =?iso-8859-15?Q?Me=DFner?= <l.messner@physik.tu-berlin.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300304176-sup-1475@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2011 at 03:43:52PM -0400, Chris Mason wrote:
> Excerpts from Leon Me=DFner's message of 2011-03-15 13:26:17 -0400:
> > On Tue, Mar 15, 2011 at 12:58:43PM -0400, Chris Mason wrote:
> > > Excerpts from Leon Me=DFner's message of 2011-03-14 20:28:56 -040=
0:
> > > > Hi,
> > > >=20
> > > > i'm having a problem with a damaged btrfs after power loss. Whe=
n i try
> > > > to mount the fs mount either segfaults (trace at bottom) or han=
gs in=20
> > > > "D" state together with [btrfs-transacti].
> > > >=20
> > > > Please CC me as i'm not an the list.
> > > > # btrfsck -s 1 /dev/sdb2
> > >=20
> > > Does btrfsck /dev/sdb2 work?  -s 1 selects a different super, hop=
efully
> > > all the supers are the same.  If plain btrfsck runs without faili=
ng we
> > > can easily work around the log tree crash.
> >=20
> > Yes it does (i think), output is below.
>=20
> Ok, if you have the latest btrfs-progs from git, you can
>=20
> make btrfs-zero-log
> ./btrfs-zero-log /dev/xxx

That worked. I could mount the partition with the following log message=
:
# dmesg | tail -n 4
Btrfs loaded
device label rootext4 devid 1 transid 45013 /dev/sdb2
Btrfs detected SSD devices, enabling SSD mode
btrfs: unlinked 13 orphan

Thanks a lot,
leon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
