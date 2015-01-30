Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9399 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbbA3Qsn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 11:48:43 -0500
Date: Fri, 30 Jan 2015 11:48:27 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fix
Message-ID: <20150130164739.GA16014@ret.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have one more fix for btrfs in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This was a bug in the new raid5/6 scrubbing support.

Gui Hecheng (1) commits (+2/-0):
    btrfs: fix raid56 scrub failed in xfstests btrfs/072

Total: (1) commits (+2/-0)

 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)
