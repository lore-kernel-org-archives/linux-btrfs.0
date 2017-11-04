Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23882 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756700AbdKDO3E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 10:29:04 -0400
Date: Sat, 4 Nov 2017 22:28:06 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH 0/8] mkfs: Quota support
Message-ID: <20171104142805.GC513@fnst.localdomain>
References: <20171027072936.4697-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 03:29:28PM +0800, Qu Wenruo wrote:
>This patchset adds quota support, which means the result fs will have
>quota enabled by default, and its accounting is already consistent, no
>manually rescan or quota enable is needed.
>
>The overall design of such support is:
>1) Create needed tree
>   Both btrfs_root and real root item and tree root leaf.
>   For this, a new infrastructure, btrfs_create_tree(), is added for
>   this.
>
>2) Fill quota root with basic skeleton
>   Only 3 items are really needed
>   a) global quota status item
>   b) quota info for 0/5 qgroup
>   c) quota limit for 0/5 qgroup
>
>   The content doesn't matter at all.
>
>3) Repair qgroups using infrastructure from qgroup-verify
>   In fact, qgroup repair is just offline rescan.
>   Although the original qgroup-verify infrastructure is mostly noisy,
>   modify it a little to make it silent to function as offline quota
>   rescan.
>
>And such support is mainly designed for developers and QA guys.
>
>As to enable quota, we must normally mount the fs, enable quota (and
>rescan if needed).
>This ioctl based procedure is not common, and fstests doesn't provide
>such support.
>
>There are several attempts to make fstests to support it, but due to
>different reasons, all these attempts failed.
>
>To make it easier to test all existing test cases with btrfs quota
>enabled, the current best method is to support quota at mkfs time, and
>here comes the patchset.
>

In addition to some trivial problems mentioned earlier, all series of
patches look good to me.

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>Qu Wenruo (8):
>  btrfs-progs: qgroup-verify: Also repair qgroup status version
>  btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we
>    should repair qgroups
>  btrfs-progs: qgroup-verify: Move qgroup classification out of
>    report_qgroups
>  btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent
>    repair
>  btrfs-progs: ctree: Introduce function to create an empty tree
>  btrfs-progs: mkfs: Introduce function to insert qgroup info and limit
>    items
>  btrfs-progs: mkfs: Introduce option to enable quota at mkfs time
>  btrfs-progs: test/mkfs: Add test case for --enable-quota option
>
> Documentation/mkfs.btrfs.asciidoc           |   3 +
> cmds-check.c                                |   2 +-
> ctree.c                                     | 109 ++++++++++++++++++++++
> ctree.h                                     |   3 +
> mkfs/main.c                                 | 136 +++++++++++++++++++++++++++-
> qgroup-verify.c                             |  51 ++++++++---
> qgroup-verify.h                             |   2 +-
> tests/mkfs-tests/001-basic-profiles/test.sh |  10 ++
> 8 files changed, 302 insertions(+), 14 deletions(-)
>
>-- 
>2.14.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


