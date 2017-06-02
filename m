Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.univention.de ([82.198.197.8]:20014 "EHLO
        mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdFBKI2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 06:08:28 -0400
From: Philipp Hahn <hahn@univention.de>
To: linux-btrfs@vger.kernel.org
Cc: Philipp Hahn <hahn@univention.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] More nritems range checking
Date: Fri,  2 Jun 2017 12:08:12 +0200
Message-Id: <cover.1496397503.git.hahn@univention.de>
In-Reply-To: <20170529181900.GV14523@twin.jikos.cz>
References: <20170529181900.GV14523@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thank you for applying my last patch, but regarding my corrputed file system I
found two other cases were btrfs crashes:
- btrfs_del_items() was overlooked by me
- deleting from an empty node

Find attached two patches to improve that.
Please check the second patch hunk 2, as I'm unsure if "mid == nritems" is valid.

(If someone can give me a hand on how to get my FS fixed again, I would
appreciate that.)

Philipp Hahn (2):
  btrfs-progs: Check slot + nr >= nritems overflow
  btrfs-progs: Check nritems under-/overflow

 ctree.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.11.0

