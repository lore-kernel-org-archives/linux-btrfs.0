Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbeHFIHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:07:40 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE1DFAE1A
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 06:00:11 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Minor qgroup subcommand usage update
Date: Mon,  6 Aug 2018 14:00:05 +0800
Message-Id: <20180806060008.9556-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It turns out even commit e5a6610c943b ("btrfs-progs: qgroup assign: add
option to schedule rescan") introduced the ability to auto rescan, it's
less known option and even some developer find it hard to understand.
(Well, the whole quota thing is already a little hard to understand)

Thus it makes more sense to make --rescan as default behavior, and add
more explanation on why quota rescan is needed, and under which case we
can skip the rescan.

Qu Wenruo (3):
  btrfs-progs: cmds-qgroup: Use bool to replace int for @rescan
  btrfs-progs: qgroup: make --rescan as the default behavior for assign
  btrfs-progs: Doc: Update btrfs-qgroup for the rescan condition

 Documentation/btrfs-qgroup.asciidoc | 26 +++++++++++++++++++++++---
 cmds-qgroup.c                       |  6 +++---
 2 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.18.0

