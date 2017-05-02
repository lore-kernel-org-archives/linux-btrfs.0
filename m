Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38845 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751368AbdEBPEC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:04:02 -0400
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        reiserfs-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH 0/7] Fix fallout from changes to FUA and PREFLUSH definitions
Date: Tue,  2 May 2017 17:03:44 +0200
Message-Id: <20170502150351.29452-1-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

this series addresses a performance issue caused by commit b685d3d65ac7 "block:
treat REQ_FUA and REQ_PREFLUSH as synchronous". We know for certain this
problem significanly regresses (over 10%, in some cases up to 100%) ext4 and
btrfs for dbench4 and reaim benchmarks.  Based on this I have fixed up also
other places which suffer from the same problem however those changes are
untested so maintainers please have a look whether the change makes sense to
you and also whether I possibly didn't miss some cases where REQ_SYNC should be
also added. Patches in this series are completely independent so if maintainers
agree with the change, feel free to take it through your tree.

The core of the problem is that above mentioned commit removed REQ_SYNC flag
from WRITE_{FUA|PREFLUSH|...} definitions.  generic_make_request_checks()
however strips REQ_FUA and REQ_PREFLUSH flags from a bio when the storage
doesn't report volatile write cache and thus write effectively becomes
asynchronous which can lead to performance regressions.

A side note for ext4: The two patches for ext4 & jbd2 are on top of the change
that got merged in the ext4 tree already.

								Honza
