From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/3] xfstest patch
Date: Wed, 12 Oct 2011 12:52:51 +0800
Message-ID: <1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
References: <4E3BA2F7.4080500@oracle.com>
Cc: chris.mason@oracle.com, Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (3):
  263: Functional test case for the btrfs snapshot
  264: Functional test case for the btrfs de-fragmentation
  265: Functional test case for the btrfs raid operations

 263           |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 263.out       |    2 +
 264           |   60 ++++++++++++++++++
 264.out       |    2 +
 265           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out       |    2 +
 README        |    7 ++-
 common.config |   14 ++++
 common.rc     |  122 ++++++++++++++++++++++++++++++++++++
 group         |    3 +
 10 files changed, 590 insertions(+), 1 deletions(-)
 create mode 100755 263
 create mode 100644 263.out
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out

-- 
1.7.7

