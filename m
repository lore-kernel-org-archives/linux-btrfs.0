From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs mount segfaults or crashes after powerloss
Date: Tue, 15 Mar 2011 12:58:43 -0400
Message-ID: <1300208269-sup-5260@think>
References: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?utf-8?q?Leon_Me=C3=9Fner?= <l.messner@physik.tu-berlin.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Leon Me=C3=9Fner's message of 2011-03-14 20:28:56 -0400:
> Hi,
>=20
> i'm having a problem with a damaged btrfs after power loss. When i tr=
y
> to mount the fs mount either segfaults (trace at bottom) or hangs in=20
> "D" state together with [btrfs-transacti]. I tried to btrfsck the=20
> filesystem multiple times. It didn't help. Btrfs tools are from today=
s=20
> git. The fs got created about half a year ago.
>=20
> Please CC me as i'm not an the list.
>=20
> Thanks,
> Leon
>=20
> # btrfsck -s 1 /dev/sdb2

Does btrfsck /dev/sdb2 work?  -s 1 selects a different super, hopefully
all the supers are the same.  If plain btrfsck runs without failing we
can easily work around the log tree crash.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
