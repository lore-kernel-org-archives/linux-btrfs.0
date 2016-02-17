Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46389 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030388AbcBQTCR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 14:02:17 -0500
Date: Wed, 17 Feb 2016 22:01:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zhaolei@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: reada: simplify dev->reada_in_flight processing
Message-ID: <20160217190152.GA10246@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Zhao Lei,

The patch 7aff519c04d2: "btrfs: reada: simplify dev->reada_in_flight
processing" from Jan 12, 2016, leads to the following static checker
warning:

	fs/btrfs/reada.c:697 reada_start_machine_dev()
	warn: inconsistent indenting

fs/btrfs/reada.c
   688                  spin_unlock(&fs_info->reada_lock);
   689                  return 0;
   690          }
   691          dev->reada_next = re->logical + fs_info->tree_root->nodesize;
   692          re->refcnt++;
   693  
   694          spin_unlock(&fs_info->reada_lock);
   695  
   696          spin_lock(&re->lock);
   697                  if (re->scheduled || list_empty(&re->extctl)) {

This is indented too much.

   698                          spin_unlock(&re->lock);
   699                          reada_extent_put(fs_info, re);
   700                          return 0;
   701                  }
   702                  re->scheduled = 1;
   703          spin_unlock(&re->lock);
   704  

regards,
dan carpenter
