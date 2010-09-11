From: Jean Sacren <sakiwit@gmail.com>
Subject: [PATCH 0/1] btrfs: Fix warning: 'prev' may be used uninitialized
 in this function
Date: Sat, 11 Sep 2010 00:08:48 -0600
Message-ID: <20100911060848.GA18516@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux BTRFS Filesystem Discussion <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Self-explanatory warning message.


Jean Sacren (1):
  btrfs: Fix warning: 'prev' may be used uninitialized in this function

 fs/btrfs/ordered-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Jean Sacren
Bring LAMP To People
