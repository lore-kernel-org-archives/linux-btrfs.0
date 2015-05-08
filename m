Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51395 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbbEHVcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 17:32:04 -0400
Date: Fri, 8 May 2015 17:32:00 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fix
Message-ID: <20150508213152.GA2846@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

When an arm user reported crashes near page_address(page) in my new code,
it became clear that I can't be trusted with GFP masks.  Filipe beat me
to the patch, and I'll just be in the corner with my dunce cap on.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1

Filipe Manana (1) commits (+1/-1):
    Btrfs: fix wrong mapping flags for free space inode

Total: (1) commits (+1/-1)

 fs/btrfs/free-space-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
