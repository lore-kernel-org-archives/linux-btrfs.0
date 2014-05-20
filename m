Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16656 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbaETTX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 15:23:26 -0400
Message-ID: <537BAC0C.4020705@fb.com>
Date: Tue, 20 May 2014 15:25:00 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

It has two fixes that we've been testing for 3.16, but since both are safe 
and fix real bugs, it makes sense to send for 3.15 instead

Liu Bo (1) commits (+5/-1):
    Btrfs: fix EIO on reading file after ioctl clone works on it

Filipe Manana (1) commits (+1/-1):
    Btrfs: send, fix incorrect ref access when using extrefs

Total: (2) commits (+6/-2)

 fs/btrfs/ioctl.c | 6 +++++-
 fs/btrfs/send.c  | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)
