Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10114 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850AbcEMDss (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 23:48:48 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id C711542B670F
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 11:48:24 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs-progs: autogen: Some compatibility fixs
Date: Fri, 13 May 2016 11:44:50 +0800
Message-ID: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changelog v1->v2:
1: btrfs-progs: autogen: Make build success in CentOS 6 and 7
   Add AC_SUBST(UDEVDIR), suggested by: Jeff Mahoney <jeffm@suse.com>

Zhao Lei (3):
  btrfs-progs: autogen: Avoid chdir fail on dirname with blank
  btrfs-progs: autogen: Make build success in CentOS 6 and 7
  btrfs-progs: autogen: Don't show success message on fail

 autogen.sh   | 9 +++++----
 configure.ac | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.5.1



