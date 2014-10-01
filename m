Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaJAQtN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 12:49:13 -0400
Date: Wed, 1 Oct 2014 18:49:10 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs 3.16.2
Message-ID: <20141001164910.GT11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

several important fixes appeared recently and the 3.17 branch is not
finalized so I'm doing another minor release, including nonintrusive
patches and documentation updates.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/

---

David Disseldorp (1):
      btrfs-progs: fix typo in subvol list usage

Dimitri John Ledkov (1):
      btrfs-progs: Properly cast to avoid compiler warnings, fixes FTBFS on alpha and ia64

Gui Hecheng (1):
      btrfs-progs: update manpage with new option -f for btrfstune

Josef Bacik (5):
      Btrfs-progs: make BUG*() be more verbose
      Btrfs-progs: don't assert when we have an invalid mapping
      Btrfs-progs: let btrfs-image actually work on a balanced fs
      btrfs-progs: add root to dirty list when fixing bad keys
      Btrfs-progs: check all slots in leaves

Naohiro Aota (1):
      btrfs-progs: fix many typos in documents

Qu Wenruo (2):
      btrfs-progs: Add human readable incompat flags output for btrfs-show-super
      btrfs-progs: Check the csum tree node before go through the csum tree
