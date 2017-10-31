Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751524AbdJaJOc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:14:32 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 0/3] add_qgroup/update_qgroup/__qgroup_search cleanup
Date: Tue, 31 Oct 2017 17:13:42 +0800
Message-ID: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 just remove the redundant function add_qgroup.
Patch 2 separate QGROUP_INFO/QGROUP_LIMIT/QGROUP_RELATION process from
the update_qgroup.
Patch 3 mainly the coding style adjustment.

Lu Fengqi (3):
  btrfs-progs: qgroup: cleanup the redundant function add_qgroup
  btrfs-progs: qgroup: split update_qgroup to reduce arguments
  btrfs-progs: qgroup: cleanup __qgroup_search, no functional change

 cmds-qgroup.c |   4 -
 qgroup.c      | 374 ++++++++++++++++++++++++++++------------------------------
 2 files changed, 180 insertions(+), 198 deletions(-)

-- 
2.14.3



