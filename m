Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaFRRX5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 13:23:57 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: kamal.mostafa@canonical.com
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [3.13.y][SRU][PATCH 0/1] btrfs: fix defrag 32-bit integer overflow
Date: Wed, 18 Jun 2014 13:23:53 -0400
Message-Id: <cover.1403107937.git.joseph.salisbury@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BugLink: http://bugs.launchpad.net/bugs/1324953


Hello,

Please consider including upstream commit c41570c9 in the next v3.13.y release.  It was included upstream as of v3.14-rc2.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1324953 .

commit c41570c9d29764f797fa35490d72b7395a0105c3
Author: Justin Maggard <jmaggard10@gmail.com>
Date:   Tue Jan 21 11:18:29 2014 -0800

    btrfs: fix defrag 32-bit integer overflow

This commit is a clean cherry-pick against 3.13.y.

Sincerely,
Joseph Salisbury


Justin Maggard (1):
  btrfs: fix defrag 32-bit integer overflow

 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.0.0

