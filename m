From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Sun, 17 Apr 2011 17:12:51 +0200
Message-ID: <201104171712.51928.hka@qbs.com.pl>
References: <chaz20110321162450.GB918@seebyte.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110321162450.GB918@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 21 of March 2011 17:24:50 Stephane Chazelas wrote:
> Hiya,
>=20
> I'm trying to move a btrfs FS that's on a hardware raid 5 (6TB
> large, 4 of which are in use) to another machine with 3 3TB HDs
> and preserve all the subvolumes/snapshots.
>=20
> Is there a way to do that without using a software/hardware raid
> on the new machine (that is just use btrfs multi-device).
>=20
> If fewer than 3TB were occupied, I suppose I could just resize
> it so that it fits on one 3TB hd, then copy device to device
> onto a 3TB disk, add the 2 other ones and do a "balance", but
> here, I can't do that.
>=20
> I suspect that if compression was enabled, the FS could fit on
> 3 TB, but AFAICT, compression is enabled at mount time and would
> only apply to newly created files. Is there a way to compress
> files already in a btrfs filesystem?

You can compress files already on disk using
btrfs filesystem defragment -c /path/to/file
but defragmenting breaks snapshotting (at least it did 2 months ago, du=
nno if=20
it's still true)

>=20
> Any help would be appreciated.
> Stephane

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
