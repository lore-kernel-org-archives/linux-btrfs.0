Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40910 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMU7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 15:59:42 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so877176eek.15
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 12:59:41 -0800 (PST)
From: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 0/2] Two small patches for the raid56 code
Date: Wed, 13 Feb 2013 21:59:22 +0100
Message-Id: <cover.1360786935.git.philipp.andreas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The last few days I have been playing around with Chris Mason's
raid56-experimental branch (Thanks!) and discovered two minor issues.

Thanks,
Andreas

Andreas Philipp (2):
  Minor format cleanup.
  Correct allowed raid levels on balance.

 fs/btrfs/ctree.h   |  4 ++--
 fs/btrfs/volumes.c | 11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

-- 
1.7.12.4

