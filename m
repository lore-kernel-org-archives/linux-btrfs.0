Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaJTQyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 12:54:17 -0400
Date: Mon, 20 Oct 2014 18:54:15 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs-progs release 3.17
Message-ID: <20141020165415.GX22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the version 3.17 of btrfs-progs has been released.

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git v3.17
https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v3.17.tar.xz

Among other fixes and updates, there are many fsck improvements, most notably a
fix for the bug introduced in 3.17 regarding inconsistencies after read-only
snapshots (fix https://patchwork.kernel.org/patch/5086521/).

User visible changes:
 * check: --init-csum-tree acutally does something useful, rebuilds the whole
   csum tree
 * /dev scanning for btrfs devices is gone
 * /proc/partitions scanning is gone, blkid is used exclusively
 * new subcommand 'subvolume sync'
 * filesystem df: new options to set unit format
 * convert: allow to copy label from the origin, or specify a new one
