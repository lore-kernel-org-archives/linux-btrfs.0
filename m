From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH v2 0/3] xfstests: Add a group of reservation space test
Date: Tue, 08 Nov 2011 11:38:41 +0800
Message-ID: <4EB8A441.7090506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Changes v1->v2:
- Make test-set support generic

This patch set add a group of reservation space test. Especailly for btrfs.
It includes three parts: copy workload, prealloc and write posix.

For test 273, I hope it's usefull for Josef's reserve improve work.
For test 274 and 275, the current btrfs is not pass yet.

Wu Bo (3):
  xfstests 273: add a copy and reserve test
  xfstests 274: add a prealloc and reserve test
  xfstests 275: add a write and reserve test

 273     |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 273.out |    4 ++
 274     |   91 +++++++++++++++++++++++++++++++++++++++
 274.out |    5 ++
 275     |   89 ++++++++++++++++++++++++++++++++++++++
 275.out |    5 ++
 group   |    3 +
 7 files changed, 342 insertions(+), 0 deletions(-)
 create mode 100755 273
 create mode 100644 273.out
 create mode 100755 274
 create mode 100644 274.out
 create mode 100755 275
 create mode 100644 275.out

-- 
1.7.3.1
