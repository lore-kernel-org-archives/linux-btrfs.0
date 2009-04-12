From: =?ISO-8859-1?Q?S=E9bastien_Wacquiez?= <sw@enix.org>
Subject: Btrfs and raw zvol-like partition
Date: Sun, 12 Apr 2009 09:26:52 +0200
Message-ID: <49E197BC.40703@enix.org>
Reply-To: sw@enix.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A nice feature is ZFS is the "ZVOL" layer, that permit you to export=20
(directly) a raw device from your zfs pool of disc, with the benefit of=
=20
powerful (growing!) snapshot and easy raid management from zfs. It's=20
particulary usefull when you use it with virtual server, allowing you t=
o=20
centralize all your backup problematic, etc

Does btrfs plan to support this kind of feature ? (please, don't tell m=
e=20
that lvm do, lvm just sucks when you make a snapshot of your disk, and=20
lack of the "growing", commit, rollback, diffsend feature).

Thanks !


S=E9bastien Wacquiez

PS : see http://opensolaris.org/os/community/zfs/source/zfstour.png if=20
you don't know what zvol do.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
