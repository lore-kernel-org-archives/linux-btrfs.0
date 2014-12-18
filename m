Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaLRO1m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 276F2AD2C
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:41 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6] Btrfs-progs, add units to 'usage' subcommands
Date: Thu, 18 Dec 2014 15:27:40 +0100
Message-Id: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy from 'fi df' to 'fi usage' and 'dev usage'.

David Sterba (6):
  btrfs-progs: fi usage, change option for tabular output to T
  btrfs-progs: fi usage, add switches to set output units
  btrfs-progs: fi usage, update manpage
  btrfs-progs: dev usage, add switches to set output units
  btrfs-progs: dev usage, update manpage
  btrfs-progs: unify unit mode parameters and variables

 Documentation/btrfs-device.txt     |  26 ++++++++
 Documentation/btrfs-filesystem.txt |  28 ++++++++
 cmds-device.c                      |  66 ++++++++++++++----
 cmds-fi-disk_usage.c               | 133 ++++++++++++++++++++++++-------------
 cmds-fi-disk_usage.h               |   4 +-
 5 files changed, 197 insertions(+), 60 deletions(-)

-- 
2.1.3

