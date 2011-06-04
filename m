From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Safe fsck / consistent backup while mounted
Date: Sat, 04 Jun 2011 12:07:31 -0400
Message-ID: <1307203653.3582.3.camel@ayu>
References: <201106041225.56028.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106041225.56028.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-06-04 at 12:25 +0200, Martin Steigerwald wrote:
> Hi!
>=20
> Now I thought about a way to safely backup a MySQL or other database =
-=20
> without long service interruption:
>=20
> - Tell DB to turn itself into consistent state and freeze there
> - sync / btrfs filesystem sync ; fsfreeze -f /mountpoint
> - btrfs subvolume snapshot
> - fsfreeze -u /mountpoint
> - Tell DB to continue business as usual
>=20
> My questions are:
> 2) Is the sync needed?

I'm not sure. In some cases it might not be: E.g. If the database uses
fsync() to save the data when you tell it to go into a consistent state=
,
there would be no need to have a separate sync. It shouldn't hurt,
however.

> 3) Is the fsfreeze needed at all? Does btrfs subvolume freeze the=20
> filesystem prior to the snapshot? The manpage doesn=C2=B4t tell it.

The fsfreeze should not be needed. The btrfs subvolume snapshot command
takes an atomic snapshot of the current subvolume state.

--=20
Calvin Walton <calvin.walton@kepstin.ca>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
