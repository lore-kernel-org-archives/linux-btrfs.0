Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755868AbcHVRfi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 13:35:38 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>, <linux-mm@kvack.org>
Subject: [PATCH 0/3][V2] Provide accounting for dirty metadata
Date: Mon, 22 Aug 2016 13:34:59 -0400
Message-ID: <1471887302-12730-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is my updated set of patches for providing a way for fs'es to do their own
accounting for their dirty metadata pages.  The changes since V1 include

-Split the accounting + ->write_metadata patches out into their own patches.
-Added a few more account_metadata* helpers that I hadn't thought about
previously.
-Changed the bdi->sb_list to bdi->dirty_sb_list.  This is to avoid confusion
about the purpose of the list.  I do a splice of this list when processing it as
we have to drop the list lock and I didn't want to worry about umounts screwing
up the list while we were writing metadata.
-Added the dirty metadata counter to the various places we output those counters
(meminfo, oom messages, etc).

I've also actually changed btrfs to use these interfaces and have been testing
that code for almost a week now and have fixed up the various problems that
happend with V1 of this code.  Thanks,

Josef
