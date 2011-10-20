From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/5] xfstests enhancement and bug fix
Date: Thu, 20 Oct 2011 23:41:17 +0800
Message-ID: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
Cc: Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (5):
  updating to fill files with random data
  Added SCRATCH_DEV_POOL to specify multiple disks for the btrfs RAID
  264: Functional test case for the btrfs snapshot
  265: Functional test case for the btrfs raid operations
  _populate_fs should use OPTIND when getopts is used

 264           |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out       |    2 +
 265           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out       |    2 +
 README        |   16 ++++-
 common.config |   11 +++
 common.rc     |   96 ++++++++++++++++++++++++++--
 group         |    2 +
 8 files changed, 498 insertions(+), 11 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out

-- 
1.7.7

