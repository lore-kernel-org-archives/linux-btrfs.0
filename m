From: liubo <liubo2009@cn.fujitsu.com>
Subject: Fullfil the bmap operation
Date: Wed, 19 May 2010 16:09:21 +0800
Message-ID: <4BF39CB1.8040607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When we tested btrfs with Josef's test-tools, a FAIL
came to us.

After looking into it, we found that aops->bmap had
been deleted because btrfs's COW + swapfile led to
corruption.

So, is there a plan for this bmap operation?

