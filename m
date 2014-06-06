Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54355 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaFFV5p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 17:57:45 -0400
Message-ID: <539239EF.3090006@fb.com>
Date: Fri, 6 Jun 2014 18:00:15 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for 3.15
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I had this in my 3.16 merge window queue, but it is small and obvious
enough for 3.15.  I cherry-picked and retested against current rc8.

Please pull from my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus


Filipe Manana (1) commits (+5/-2):
    Btrfs: send, fix corrupted path strings for long paths

Total: (1) commits (+5/-2)

 fs/btrfs/send.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


