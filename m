From: Arne Jansen <sensille@gmx.net>
Subject: Re: Safe fsck / consistent backup while mounted
Date: Sat, 04 Jun 2011 16:13:14 +0200
Message-ID: <4DEA3D7A.40003@gmx.net>
References: <201106041225.56028.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106041225.56028.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 04.06.2011 12:25, Martin Steigerwald wrote:
> Hi!
>
> In mailing list debian-user-german we are discussing safe ways to do =
a
> fsck when mounted.
>
> I tested with Ext4 that fsck -nf works either with mount -o remount,r=
o or
> fsfreeze -f while writing with:
>
> I=3D0; while true ; let I=3DI+1 ; do touch /boot/test$I ; sleep 0.2 ;=
 done
>
> In the read only mount case the write application returns errors, in =
the
> fsfreeze case Linux kernel stacks the changes in memory, but the fsck
> reports no errors like it should.


for online fsck you can use scrub, it checks at least partially the
consistency.


>
>
> Now I thought about a way to safely backup a MySQL or other database =
-
> without long service interruption:
>
> - Tell DB to turn itself into consistent state and freeze there
> - sync / btrfs filesystem sync ; fsfreeze -f /mountpoint
> - btrfs subvolume snapshot
> - fsfreeze -u /mountpoint
> - Tell DB to continue business as usual

I'd just take a snapshot and backup from there. As a snapshot is a
consistent image of the filesystem at the time the snapshot is taken,
and every database is required to always have an at least recoverable
state on disk, the snapshot represents a state where your DB can
recover from.

>
> My questions are:
>
> 1) Would this work?
>
> 2) Is the sync needed? And if so how to avoid the race condition betw=
een
> the sync and the fsfreeze invocation? Reading from the fsfreeze manpa=
ge I
> understand that fsfreeze allows all ongoing transactions to complete.=
 But
> does that include everything what sync would bring to disk?
>
> 3) Is the fsfreeze needed at all? Does btrfs subvolume freeze the
> filesystem prior to the snapshot? The manpage doesn=B4t tell it.
>
> Thanks,

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
