Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51250 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbeFTRDe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:03:34 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 0/3] Three patches that address static analyzer reports
Date: Wed, 20 Jun 2018 10:03:30 -0700
Message-Id: <20180620170333.29182-1-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris and Josef,

The three patches in this series address complaints reported by static
analyzers (gcc + W=1, sparse, smatch). These patches do not change any
functionality. Please consider these for inclusion in the upstream
kernel.

Thanks,

Bart.

Bart Van Assche (3):
  btrfs: Fix indentation
  btrfs: Annotate fall-through
  btrfs: Fix a C compliance issue

 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/ioctl.c       | 4 ++--
 fs/btrfs/reada.c       | 2 +-
 fs/btrfs/super.c       | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.17.1

