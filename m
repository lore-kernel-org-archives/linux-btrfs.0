Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13019 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbbFHDGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 23:06:39 -0400
Message-ID: <557506BC.701@cn.fujitsu.com>
Date: Mon, 8 Jun 2015 11:06:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <adam900710@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Qgroup rework with other Fujitsu fix.
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Please pull the 19 patchset from my branch for_chris_4.2.
We have tested it in a week.

Although it is originally based on 4.1-rc5, not the integration branch.
Quick tests shows no new bugs, although we will rerun the full test,
I'll send the patchset first for your reviewing:

https://github.com/adam900710/linux.git for_chris_4.2

This contains the following patches.

1. Qgroup rework (first 18 commits)
These commits rework the qgroup framework.
Now, quota won't need to do per-delayed-ref accounting.
But only need to record dirty delayed-ref, and account quota at 
transaction time.

The good thing is, at transaction time, we have no other interruption or
concurrency, account can be quite accurate and only need to account once
for every dirty extent.(especially faster for shared extents)

And clearer codes and logic. Codes changes from 1K to 0.5K, even a lot
of comments are added.

With the patchset, btrfs can pass all qgroup test in fstests.
No longer minus number now.

The only problem left is, we need a new mechanism to account subvolume 
deletion. But this is the long-existing problem, I'd prefer to address
it in next merge windows if we have a pretty method to solve it.

Or maybe a small patch to mark qgroup inconsistent when delete subvolume 
with level higher than 0.

2. write-rm-loop fixes from Zhao Lei.
Other patches from Zhao Lei and Forrest Liu have already been merged
into mainline, but this is the one still unmerged.

This patch fixes the last super rare problem we found in write-rm-loop
case.
And the patch will only modify the minor routine, so it won't affect the 
normal routine.

Thanks,
Qu
