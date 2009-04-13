From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs and raw zvol-like partition
Date: Mon, 13 Apr 2009 09:56:26 -0400
Message-ID: <1239630986.24841.18.camel@think.oraclecorp.com>
References: <49E197BC.40703@enix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: sw@enix.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49E197BC.40703@enix.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-04-12 at 09:26 +0200, S=C3=A9bastien Wacquiez wrote:
> Hi,
>=20
> A nice feature is ZFS is the "ZVOL" layer, that permit you to export=20
> (directly) a raw device from your zfs pool of disc, with the benefit =
of=20
> powerful (growing!) snapshot and easy raid management from zfs. It's=20
> particulary usefull when you use it with virtual server, allowing you=
 to=20
> centralize all your backup problematic, etc
>=20
> Does btrfs plan to support this kind of feature ? (please, don't tell=
 me=20
> that lvm do, lvm just sucks when you make a snapshot of your disk, an=
d=20
> lack of the "growing", commit, rollback, diffsend feature).
>=20

I've always been interested in a btrfs export via loop or dm.  The
problem with loop is that it needs to be switched over to O_DIRECT or
something similar.

At any rate, it would be a fun project for someone looking to know dm
better.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
