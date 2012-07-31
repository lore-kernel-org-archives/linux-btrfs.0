Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47118 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2GaRMC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 13:12:02 -0400
Received: by wibhm11 with SMTP id hm11so3121365wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 10:12:00 -0700 (PDT)
From: Alexander Karbstein <alexander.karbstein@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Karbstein <alexander.karbstein@gmail.com>
Subject: [PATCH V2] Btrfs-progs: Enabled setting root subvolume with subvolid=0
Date: Tue, 31 Jul 2012 19:11:20 +0200
Message-Id: <1343754681-4454-1-git-send-email-alexander.karbstein@gmail.com>
In-Reply-To: <50173463.5060405@cn.fujitsu.com>
References: <50173463.5060405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

here is my revised patch free from checkpatch warnings and based on the right
git tree.

Alexander Karbstein (1):
  Btrfs-progs: Enabled setting root subvolume with subvolid=0

 cmds-subvolume.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

-- 
1.7.2.5

