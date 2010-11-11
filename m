From: Josh Berry <des@condordes.net>
Subject: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 12:04:44 -0800
Message-ID: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a cron script that runs periodically, taking new snapshots and
cleaning up old ones when space gets low on my filesystem.  This
morning, the script suddenly stopped being able to remove snapshots.
When I tried to remove one manually, I got the following:

# btrfs subvol del 2010-11-07-01:17:01
Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'

There is nothing in dmesg or in the above output to tell me what the
problem is, how to fix it, etc.  I'm running kernel 2.6.36, and I
updated btrfs-progs-unstable to the lastest Git revision
(1b444cd2e6...), with the same result.

How do I diagnose this issue?  I'm not even sure where to start.

Thanks,
Josh
