From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH 0/3] xfstests: Add a group of reservation space test
Date: Thu, 03 Nov 2011 11:05:41 +0800
Message-ID: <4EB20505.7070005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch set add a group of reservation space test. Especailly for btrfs.
It includes three parts: copy workload, prealloc and write posix.

For test 264, I hope it's usefull for Josef's reserve improve work.
For test 265 and 266, the current btrfs is not pass yet.

TO avoid fill the huge disk, I just resize the filesystem size which NOT 
all filesystems supportted. Here I just make these tests support btrfs only,
but it's can ream to ext3/4 if needed.

Wu Bo (3):
  xfstests 264: add a copy and reserve test
  xfstests 265: add a prealloc and reserve test
  xfstests 266: add a write and reserve test

 264     |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out |    6 ++
 265     |  107 ++++++++++++++++++++++++++++++++++++++++++
 265.out |    5 ++
 266     |  104 +++++++++++++++++++++++++++++++++++++++++
 266.out |    5 ++
 group   |    3 +
 7 files changed, 388 insertions(+), 0 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out
 create mode 100755 266
 create mode 100644 266.out

-- 
1.7.3.1


