Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50083 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752543AbdFPLj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 07:39:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 036DAAB09
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Jun 2017 11:39:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/2] Ensure size values are rounded down
Date: Fri, 16 Jun 2017 14:39:18 +0300
Message-Id: <1497613160-3074-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is a small series which fixes an issue that got reported internally to 
Suse and which affects devices whose size is not multiple of sectorsize. More
information can be found in the changelog for patch 2

The first patch in the series re-implements the btrfs_device_total_bytes
getter/setters manually so that we can add a WARN_ON to catch future offenders. 
I haven't implemented all 4 function that the macros do since we only ever use
the getter and setter. 

The second patch ensures that all the values passed to the setter are rounded 
down to a multiple of sectorsize. I also have an xfstest patch which passes
after this series is applied. 

Changes since v1: 
 * Moved some of the text from previous cover letter, into patch 2 to make 
 explanation of the bug more coherent. 
 * The first patch now only implements getter/setter while the 2nd patch 
 adds the WARN_ON 

Nikolay Borisov (2):
  btrfs: Manually implement device_total_bytes getter/setter
  btrfs: Round down values which are written for total_bytes_size

 fs/btrfs/ctree.h   | 21 ++++++++++++++++++++-
 fs/btrfs/volumes.c | 18 +++++++++++++-----
 2 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.7.4

