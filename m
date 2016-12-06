Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36584 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLFEgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 23:36:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] recursive defrag cleanup
Date: Tue,  6 Dec 2016 12:39:37 +0800
Message-Id: <20161206043938.3249-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The command,
   btrfs fi defrag -v /btrfs
 does nothing, it won't defrag the files under /btrfs as user
 may expect. The command with recursive option
   btrfs fi defrag -vr /btrfs
 would defrag all the files under /btrfs including files in
 its sub directories.

 While attempting to fix this. The patch below 1/1 provides
 a cleanup. And the actual fix is pending, as to my understanding
 of nfwt() it does not provide the list of file without
 files under its sub directories.

Anand Jain (1):
  btrfs-progs: recursive defrag cleanup remove duplicate code

 cmds-filesystem.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
2.10.0

