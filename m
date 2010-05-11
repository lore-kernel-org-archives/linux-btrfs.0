From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [RFC] log mode COW
Date: Tue, 11 May 2010 16:23:33 +0800
Message-ID: <4BE91405.6080006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The aim of log mode COW is solve extent tree performance issue when
free metadata space are scarce and fragmented. The basic idea is:
when cowing a non-shared block, we insert a log entry that maps
the new block to the old block into a special log tree, and do not
update the extent tree. After transaction is fully committed, copy
the new block back to the old location.

Log mode COW can be enabled/disabled by log_mode=%d mount option.
'0' means disable log mode COW; '1' means enable log for tree blocks
that are not reference counted; '2' means enable log for all tree
blocks are not shared.

NOTE: The patch series base on current btrfs-unstable. They are for
      test and review only. Enable log mode COW changes disk format.

Regards
Yan, Zheng
