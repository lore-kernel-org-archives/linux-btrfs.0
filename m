Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25319 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbaKIBRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Nov 2014 20:17:17 -0500
Message-ID: <545EC097.2010005@fb.com>
Date: Sat, 8 Nov 2014 20:17:11 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

It's a one liner for an error cleanup path that leads to crashes.

Chris Mason (1) commits (+1/-1):
    Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Total: (1) commits (+1/-1)

 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
