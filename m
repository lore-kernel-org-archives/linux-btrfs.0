Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826AbaLJPGu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:06:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3A288AB09
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 15:06:49 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] Btrfs-progs: subvolume deletion commit mode update
Date: Wed, 10 Dec 2014 16:06:48 +0100
Message-Id: <cover.1418223710.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Minor change in the output of 'subvolume delete' command, the commit mode is
printed inline with the subvolume and the global message is moved under the
newly added 'verbose' option.

David Sterba (3):
  btrfs-progs: let subvol delete print commit mode inline
  btrfs-progs: subvol delete: add verbosity option
  btrfs-progs: subvol delete: rename variable to match the option name

 cmds-subvolume.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

-- 
2.1.3

