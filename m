From: Chris Mason <chris.mason@oracle.com>
Subject: Most pending patches in btrfs-unstable
Date: Thu, 24 Jul 2008 14:08:43 -0400
Message-ID: <1216922923.6932.201.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

There are still a few pending patches on the mailing list for me to pull
in, but btrfs-unstable now has a shiny new disk format including:

* ACL support
* Orphan inode prevention
* A new directory format

I think I'll code name v0.16 the Josef Bacik disk format special.
Thanks Josef for all the time reworking these patches as I changed
things underneath you.

There are also a few fixes from Yan Zheng and some data=ordered fixes.
Hopefully this is pretty close to where I can run it on the desktop.

-chris


