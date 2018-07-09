Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750996AbeGIGmG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jul 2018 02:42:06 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96D2EACBB
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2018 06:42:05 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: chunk and dev-extent related error handler enhancement
Date: Mon,  9 Jul 2018 14:42:01 +0800
Message-Id: <20180709064203.32409-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched with all existing tree-checker/bg<->chunk error detector
from github:
https://github.com/adam900710/linux/tree/tree_checker_enhance

Still some fuzzed images reported from Xu Wen.
This time, 2 can be fixed by chunk <-> dev extent mapping verification.
One BUG_ON() can be removed.

The remaining 2 images are all mostly about extent tree corruption,
which is not as easy to detect, since extent tree has way more complex
reference relationship.

At least, fix what we can first.

And for chunk <-> dev extent mapping verification, it will trigger
read on the whole device tree, to iterate through all DEV_EXTENT items.
This will introduce an extra overhead on mount.

However since device tree is pretty small (the same level as chunk tree),
and according to previous analyse on mount time, chunk tree iteration is
only a pretty small fraction of the whole mount time (less than 5%), it
shouldn't bring obvious impact to users.

Qu Wenruo (2):
  btrfs: Introduce mount time chunk <-> dev extent mapping check
  btrfs: Exit gracefully when failed to add chunk map

 fs/btrfs/disk-io.c |   7 ++
 fs/btrfs/volumes.c | 181 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h |   2 +
 3 files changed, 188 insertions(+), 2 deletions(-)

-- 
2.18.0

