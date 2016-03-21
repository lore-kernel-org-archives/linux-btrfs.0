Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbcCUHV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/6 v3] btrfs-progs: subvolume functions reorg
Date: Mon, 21 Mar 2016 15:20:59 +0800
Message-Id: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need subvolume helper functions easily accessible for features
around subvolume. This patch set is just a cleanup of subvolume
functions.

This is tested fine with fstests group subvol and subvol hand tests.

v3: Separate changes into 6 commits,
    Drops the idea of creating subvolume.c, instead update utils.c.
    Adds 1/5 a minor func mv and 3/5 remove of a duplicate func and
    6/6 rename of get_subvol_name as per review comment.

v2: Update commit log. Separate this patch from the encryption
    patch set.


Anand Jain (6):
  btrfs-progs: spatial rearrange subvolume functions together
  btrfs-progs: move test_issubvolume() to utils.c
  btrfs-progs: remove duplicate function __is_subvol()
  btrfs-progs: move get_subvol_name() to utils.c
  btrfs-progs: create get_subvol_info()
  btrfs-progs: rename get_subvol_name() to subvol_minus_mnt()

 cmds-send.c      |  15 +-----
 cmds-subvolume.c | 107 +++++++++----------------------------
 utils.c          | 157 ++++++++++++++++++++++++++++++++++++++++++++-----------
 utils.h          |   4 ++
 4 files changed, 157 insertions(+), 126 deletions(-)

-- 
2.7.0

>From 22a64f723b6563785276d27b0ae4f7b8ded6febe Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Mon, 21 Mar 2016 13:55:10 +0800

Anand Jain (5):
  btrfs-progs: spatial rearrange subvolume functions together
  btrfs-progs: move test_issubvolume() to utils.c
  btrfs-progs: remove duplicate function __is_subvol()
  btrfs-progs: move get_subvol_name() to utils.c
  btrfs-progs: create get_subvol_info()

 cmds-send.c      |  11 ----
 cmds-subvolume.c | 101 +++++++------------------------------
 utils.c          | 151 +++++++++++++++++++++++++++++++++++++++++++------------
 utils.h          |   4 ++
 4 files changed, 141 insertions(+), 126 deletions(-)

-- 
2.7.0

