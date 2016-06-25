Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4541 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751249AbcFYNmN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 09:42:13 -0400
Date: Sat, 25 Jun 2016 09:42:06 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL 2/2] Btrfs
Message-ID: <20160625134206.rch4rrhqt35fkmq3@floor.thefacebook.com>
References: <20160625131317.orm7k3dvt4mbfqof@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160625131317.orm7k3dvt4mbfqof@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Btrfs part two was supposed to be a single patch on part of v4.7-rc4.
Somehow I didn't notice that my part2 branch repeated a few of the
patches in part 1 when I set it up earlier this week.  Cherry-picking
gone wrong as I folded a fix into Dave Sterba's original integration.

I've been testing the git-merged result of part1, part2 and your
master for a while, but I just rebased part2 so it didn't include
any duplicates.  I ran git diff to verify the merged result of
today's pull is exactly the same as the one I've been testing.

My for-linus-4.7-part2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7-part2

Has one patch from Omar to bring iterate_shared back to btrfs.  We have
a tree of work we queue up for directory items and it doesn't
lend itself well to shared access.  While we're cleaning it up, Omar
has changed things to use an exclusive lock when there are delayed
items.

Omar Sandoval (1) commits (+34/-13):
    Btrfs: fix ->iterate_shared() by upgrading i_rwsem for delayed nodes

Total: (1) commits (+34/-13)

 fs/btrfs/delayed-inode.c | 27 ++++++++++++++++++++++-----
 fs/btrfs/delayed-inode.h | 10 ++++++----
 fs/btrfs/inode.c         | 10 ++++++----
 3 files changed, 34 insertions(+), 13 deletions(-)
