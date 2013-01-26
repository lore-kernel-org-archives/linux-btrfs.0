Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab3AZAz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 19:55:29 -0500
Date: Sat, 26 Jan 2013 01:55:25 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: Integration branch of btrfs-progs 2013-01-26 [pullable]
Message-ID: <20130126005525.GZ28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here goes another set of fixes, a mix of old patches and some of them
sent during last week.  Part of it was included in the previous
integration branch and thus has the ssd detection, device-ready
support and superblock dump tool.

There are lots of small fixes or cleanups and help string updates, and
the "pretty/quiet build" which makes warnings really easy to spot.

Next I'd like to add the missing userspace support for features that are
in current kernels (device stats, device replace). I'm aware of the
other patch series and will go through them, also the first pile of
fixes based on coverity reports is about to arrive.

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130126

(top commit 3ec4f73635b2569, based on current master 6cd836d7d95a)

I did basic testing, please reply to this mail with bugs you find.


Thanks!
david

---

Anand Jain (1):
      Btrfs-progs: we need to have the string null terminated

Andreas Fischer (1):
      Btrfs-progs: Fix typo in balance start usage; filetrs -> filters.

Arne Jansen (1):
      Btrfs-progs: bugfix for scrubbing single devices

Arvin Schnell (1):
      btrfs-progs: initialize data before send ioctl

Chen Yang (1):
      Btrfs-prog/send: fix wrong best-parent assignment in, find_good_parent()

Christian Hesse (1):
      btrfs-progs: fix build, manpage compression command

Danny Kukawka (1):
      btrfs-progs: Handle errors returned from open_ctree

Eric Sandeen (2):
      btrfs-progs: Use sysconf instead of getpagesize
      btrfs-progs pretty/quiet build

Goffredo Baroncelli (1):
      Ignore the error ENXIO and ENOMEDIUM during a devs scan

Jan Schmidt (2):
      Btrfs-progs: correcting misnamed parameter options for btrfs send
      Btrfs-progs: bugfix for subvolume parent determination in btrfs send

Josef Bacik (3):
      Btrfs-progs: detect if the disk we are formatting is a ssd
      Btrfs-progs: add btrfs device ready command
      btrfs-progs: kill check for /'s in labels

Nirbheek Chauhan (1):
      Btrfs-progs: fix resolving of loop devices

Stefan Behrens (2):
      Btrfs-progs: fix an off-by-one in write_dev_supers()
      btrfs-progs: Add btrfs-show-super

Ulrik (1):
      Btrfs-progs: correct btrfs receive usage string

Wang Sheng-Hui (2):
      btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
      btrfs-progs: update options in find-root.c

Wang Shilong (3):
      Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
      Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi with strtoull
      Btrfs-progs: check the relation of two group by real level numbers
