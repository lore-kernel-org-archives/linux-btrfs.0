Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40533 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754151AbcITU6e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 16:58:34 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>, <linux-mm@kvack.org>,
        <hannes@cmpxchg.org>
Subject: [PATCH 0/4][V3] metadata throttling in writeback patches
Date: Tue, 20 Sep 2016 16:57:44 -0400
Message-ID: <1474405068-27841-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the latest set of patches based on my conversations with Jan and
Johannes.  The biggest change has been changing the metadata accounting counters
to be in bytes intead of pages in order to better support varying blocksizes.
I've also stopped messing with the other pagecache related counters so we can
keep them truly separate.  Johannes suggested this change and I simply convert
the bytes counter to pages when calculating dirty limits and such.

The other big change is changing WB_WRITTEN/WB_DIRTIED to be in bytes instead of
pages as well.  This is just a name and accounting change, it doesn't really
change the core logic at all.

I'm sending this out ahead of my full battery of tests, but I want to get
feedback on this direction as soon as possible.  In the meantime I've changed my
btrfs specific patches to work with these patches and am running long running
tests now to verify everything still works.  Thanks,

Josef

