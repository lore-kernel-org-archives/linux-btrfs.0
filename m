Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbJPQS6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:18:58 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3976EAAC8
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:18:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/8 v2] Btrfs-progs, balance filters: stripes, limits
Date: Fri, 16 Oct 2015 18:17:46 +0200
Message-Id: <cover.1445011409.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An updated version that actually works.

David Sterba (7):
  btrfs-progs: cleanup and comment parse_range
  btrfs-progs: do not modify the string in parse_range
  btrfs-progs: extend parse_range API to accept a relaxed range
  btrfs-progs: add helpers for parsing 32bit ranges
  btrfs-progs: add helpers to print ranges
  btrfs-progs: extend balance args to take min/max limit filter
  btrfs-progs: balance: enhance the limit fiter with range

Gabríel Arthúr Pétursson (1):
  btrfs-progs: balance: add stripes filter

 Documentation/btrfs-balance.asciidoc |   8 ++
 cmds-balance.c                       | 167 +++++++++++++++++++++++++++++------
 ioctl.h                              |  17 +++-
 volumes.h                            |   2 +
 4 files changed, 164 insertions(+), 30 deletions(-)

-- 
2.6.1

