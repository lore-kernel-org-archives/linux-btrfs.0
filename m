From: Michael Kofler <michael@kofler.info>
Subject: make snapshot main volume, delete all others?
Date: Tue, 03 Aug 2010 20:22:38 +0200
Message-ID: <4C585E6E.3060704@kofler.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fedora provides yum-fs-snapshot. If installed, on each package 
installation or update a snapshot of all btrfs filesystems is taken, so 
it is possible to revert the installation/update.

Suppose an update failed and I want to get back: with

# btrfs subvolume set-default yum-snapshot-whatever /

I define which snapshot to use at the next boot.

After rebooting I decide I really want to stay with this snapshot. I can 
delete all other snapshots, but can I also delete my previous main 
volume, thus defining the current default snapshot as my new base. (If 
not, a growing part of the filesystem is wasted for old data I don't 
need anymore.)

Any insight is appreciated!

	Michael Kofler

