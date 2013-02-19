Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3BSKyx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 05:54:53 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 87258A4386
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 11:54:52 +0100 (CET)
Date: Tue, 19 Feb 2013 11:54:51 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-02-19
Message-ID: <20130219105451.GU12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a set of updates and fixes, plus two libify patches left out for
now (*):

btrfs-progs: libify some parts of btrfs-progs
btrfs-progs: don't link binaries to a dynamic library

* http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg22293.html

In the near-todo are the label patches as the kernel functionality is
going to land in 3.9, otherwise I'm still processing the remaining old
patches and will pick up recent fixes eventually.

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130219


Thanks for testing,
david

---
Shortlog (only new patches on top of previous integration):

Eric Sandeen (1):
      btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table

Liu Bo (1):
      Btrfs-progs: fix segmentation fault of 'btrfs-debug-tree -e'

Mark Fasheh (1):
      btrfs-progs: Fix pointer math in __ino_to_path_fd

Tsutomu Itoh (1):
      Btrfs-progs: check out if the swap device
