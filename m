Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f175.google.com ([209.85.208.175]:37912 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbeIOCWS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 22:22:18 -0400
Received: by mail-lj1-f175.google.com with SMTP id p6-v6so8594784ljc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 14:06:06 -0700 (PDT)
MIME-Version: 1.0
From: "James A. Robinson" <jim.robinson@gmail.com>
Date: Fri, 14 Sep 2018 14:05:29 -0700
Message-ID: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Subject: state of btrfs snapshot limitations?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mail archive seems to indicate this list is appropriate
for not only the technical coding issues, but also for user
questions, so I wanted to pose a question here.  If I'm
wrong about that, I apologize in advance.

The page

https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

talks about the basic snapshot capabilities of btrfs and led
me to look up what, if any, limits might apply.  I find some
threads from a few years ago that talk about limiting the
number of snapshots for a volume to 100.

The reason I'm curious is I wanted to try and use the
snapshot capability as a way of keeping a 'history' of a
backup volume I maintain.  The backup doesn't change a
lot overtime, but small changes are made to files within
it daily.

The Plan 9 OS has a nice archival filesystem that lets you
easily maintain snapshots, and has various tools that make
it simple to keep a /snapshot/yyyy/mmdd snapshot going back
for the life of the filesystem.

I wanted to try and replicate the basic functionality of
that history using a non-plan-9 filesystem.  At first I
tried rsnapshot but I find its technique of rotating and
deleting backups is thrashing the disks to the point that it
can't keep up with the rotations (the cp -al is fast, but
the periodic rm -rf of older snapshots kills the disk).

With btrfs I was thinking perhaps I could more efficiently
maintain the archive of changes over time using a snapshot.
If this is an awful thought and I should just go away,
please let me know.

If the limit is 100 or less I'd need use a more complicated
rotation scheme.  For example with a layout like the
following:

min/<mm>
hour/<hh>
day/<dd>
month/<mm>
year/<yyy>

The idea being each bucket, min, hour, day, month, would
be capped and older snapshots would be removed and replaced
with newer ones over time.

so with a 15-minute snapshot cycle I'd end up with

min/[00,15,30,45]
hour/[00-23]
day/[01-31]
month/[01-12]
year/[2018,2019,...]

(72+ snapshots with room for a few years worth of yearly's).

But if things have changed with btrfs over the past few
years and number of snapshots scales much higher, I would
use the easier scheme:

/min/[00,15,30,45]
/hourly/[00-23]
/daily/<yyyy>/<mmdd>

with 365 snapshots added per additional year.
