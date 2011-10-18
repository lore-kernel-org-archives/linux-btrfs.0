From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/3] xfstests patches
Date: Tue, 18 Oct 2011 14:28:53 +0800
Message-ID: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
References: <20111013005652.GM3159@dastard>
Cc: Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111013005652.GM3159@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

Looks like there are no further comments.
Changes per Dave pointing out to reuse _populate_fs.
Thanks for the review.

Anand Jain (3):
  264: Functional test case for the btrfs snapshot
  265: Functional test case for the btrfs de-fragmentation
  266: Functional test case for the btrfs raid operations

 264           |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out       |    2 +
 265           |   60 ++++++++++++++++++
 265.out       |    2 +
 266           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 266.out       |    2 +
 README        |    7 ++-
 common.config |   14 ++++
 common.rc     |   95 +++++++++++++++++++++++++++-
 group         |    3 +
 10 files changed, 559 insertions(+), 5 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out
 create mode 100755 266
 create mode 100644 266.out

-- 
1.7.7

