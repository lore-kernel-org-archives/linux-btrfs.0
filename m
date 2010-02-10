From: Robert Pankowecki <robert@cubiware.com>
Subject: Using snapshots as quick restore point
Date: Wed, 10 Feb 2010 11:09:22 +0100
Message-ID: <1265796562.8697.110.camel@rupert-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible to use snapshot as some kind of point in time that i can
go back into? Here is what i would like to do:

* create snapshot
* mount it somewhere (read-write)
* operate on the snapshot, change some files etc...
* revert changes made to the snapshot to its original state with or
without unmounting it.

If not, is there any filesystem that can do that ?

Robert Pankowecki


