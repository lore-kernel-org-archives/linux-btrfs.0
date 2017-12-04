Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753382AbdLDKVy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 05:21:54 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 009A448A1711
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 18:21:52 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: Mon, 4 Dec 2017 18:20:40 +0800
Message-ID: <20171204102044.25702-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [PATCH 0/4] qgroup cleanup and add show path feature
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first two patches are the rest of the qgroup cleanup, the two
remaining patches add show path feature.

Lu Fengqi (4):
  btrfs-progs: qgroup: move btrfs_show_qgroups's error handler to
    __qgroup_search
  btrfs-progs: qgroup: cleanup __qgroup_search
  btrfs-progs: qgroup: show subvol path when qgroup show
  btrfs-progs: qgroup: allow show qgroup in order of subvol path

 Documentation/btrfs-qgroup.asciidoc |   2 +-
 cmds-qgroup.c                       |   6 +-
 qgroup.c                            | 193 ++++++++++++++++++++++++++++++------
 qgroup.h                            |   2 +
 4 files changed, 167 insertions(+), 36 deletions(-)

-- 
2.14.3



