From: Miao Xie <miaox@cn.fujitsu.com>
Subject: the idea for improving the performance of b-tree search
Date: Wed, 13 Oct 2010 17:00:56 +0800
Message-ID: <4CB57548.7000304@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

When I investigated the performance problem of file creation/deletion, I found
btrfs spends lots of time in the b-tree search, so I consider whether we can use
the latest search result in the same transaction or not.

My idea follows:
we can add mask or time stamp into b-tree's node and leaf, then we know whether
the node/leaf is COWed by the other task. If not, we check if the node/leaf of
the latest search result contains the key that we want to search. By this way,
we can reuse the latest search result in the same transaction and reduce the CPU
time spent in the b-tree search.

Chris, how do you think about it?

Regards
Miao
