From: David Sterba <dave@jikos.cz>
Subject: [nico-lkml-20110623@schottelius.org: Mis-Design of Btrfs?]
Date: Fri, 24 Jun 2011 12:52:07 +0200
Message-ID: <20110624105207.GP12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

----- Forwarded message from Nico Schottelius <nico-lkml-20110623@schottelius.org> -----

To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 23 Jun 2011 12:53:37 +0200
From: Nico Schottelius <nico-lkml-20110623@schottelius.org>
Subject: Mis-Design of Btrfs?

Good morning devs,

I'm wondering whether the raid- and volume-management-builtin of btrfs is
actually a sane idea or not.
Currently we do have md/device-mapper support for raid
already, btrfs lacks raid5 support and re-implements stuff that
has already been done.

I'm aware of the fact that it is very useful to know on which devices
we are in a filesystem. But I'm wondering, whether it wouldn't be
smarter to generalise the information exposure through the VFS layer
instead of replicating functionality:

Physical:   USB-HD   SSD   USB-Flash          | Exposes information to
Raid:       Raid1, Raid5, Raid10, etc.        | higher levels
Crypto:     Luks                              |
LVM:        Groups/Volumes                    |
FS:         xfs/jfs/reiser/ext3               v

Thus a filesystem like ext3 could be aware that it is running
on a USB HD, enable -o sync be default or have the filesystem
to rewrite blocks when running on crypto or optimise for an SSD, ...

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----
