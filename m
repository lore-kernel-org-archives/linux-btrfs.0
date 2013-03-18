Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab3CRRd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 13:33:28 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 70BB1A5230
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 18:33:27 +0100 (CET)
Date: Mon, 18 Mar 2013 18:33:27 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-03-18
Message-ID: <20130318173326.GO7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

shortdesc: core code fixes, more static build targets, restore updates,
doc/help updates.

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130318

shortlog:
Anand Jain (2):
      btrfs-progs: update .gitignore file
      btrfs-progs: print errno string when /dev/btrfs-control open fails

Antoine Sirinelli (1):
      btrfs-progs: Add a rule to build a static mkfs.btrfs

David Marcin (1):
      btrfs-progs: Fix error handling for failed reads in restore tool when mirrors exist

Eric Sandeen (5):
      btrfs-progs: close fd on return from label get/set functions
      btrfs-progs: three new device/path helpers
      btrfs-progs: don't open-code mountpoint discovery in scrub cancel
      btrfs-progs: rework get_fs_info to remove side effects
      btrfs-progs: document force option in mkfs usage(); add long opt

Hugo Mills (1):
      btrfs-progs: add Makefile rule for static build of btrfs-find-root

Josef Bacik (6):
      Btrfs-progs: alloc our super copy in btrfs-find-root
      Btrfs-progs: add an option for specifying the root to restore
      Btrfs-progs: try other mirrors if decompression fails
      Btrfs-progs: try other mirrors on read failure
      btrfs-progs: add lzo compression support to restore
      Btrfs-progs: give restore a list roots option

Matias Bjørling (1):
      btrfs-progs: mkfs: add missing raid5/6 description

Peter Stuge (1):
      restore: Split output directory and btrfs-local path search_dir() parameters


short unsigned mail;
