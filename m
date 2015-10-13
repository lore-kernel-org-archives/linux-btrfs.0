Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbbJMPn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:43:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A3BF7ABCC
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 15:43:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Btrfs-progs, balance filters: stripes, limits
Date: Tue, 13 Oct 2015 17:42:16 +0200
Message-Id: <cover.1444750808.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's the userspace part that enables the use of stripes and enhanced limit
filters.

David Sterba (6):
  btrfs-progs: cleanup and comment parse_range
  btrfs-progs: extend parse_range API to accept a relaxed range
  btrfs-progs: add helpers for parsing 32bit ranges
  btrfs-progs: add helpers to print ranges
  btrfs-progs: extend balance args to take min/max limit filter
  btrfs-progs: balance: enhance the limit fiter with range

Gabríel Arthúr Pétursson (1):
  btrfs-progs: balance: add stripes filter

 Documentation/btrfs-balance.asciidoc |   8 ++
 cmds-balance.c                       | 172 +++++++++++++++++++++++++++++------
 ioctl.h                              |  17 +++-
 volumes.h                            |   2 +
 4 files changed, 168 insertions(+), 31 deletions(-)

-- 
2.6.1

