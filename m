From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format pushed out
Date: Tue, 02 Dec 2008 10:29:03 -0500
Message-ID: <1228231743.24825.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out Josef's updates to make the checksum selectable at mkfs
time (right now there's only one choice, but we now have the disk format
bits for more).

This means both kernel and progs have a new disk format.  The format
will change a few more times this week as we try to hammer out the 1.0
format.

-chris



