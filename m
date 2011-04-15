From: Josef Bacik <josef@redhat.com>
Subject: [RFC] Add a new file op for fsync to give fs's more control
Date: Fri, 15 Apr 2011 15:09:40 -0400
Message-ID: <1302894582-24341-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs needs to be able to control how data is submitted in the case of fsync to
make it a little faster, and really we could get rid of holding the i_mutex
altogether as well.  So introduce a ->fsync_nolock helper that pushes the
responsibility of locking the inode and doing the filemap_write_and_wait_range
down into the fs so we can have better control of how we submit the io and do
our locking.  It looks like ext4 and probably xfs could get away with not taking
the i_mutex either, so they may benefit from this as well.  Really I could just
change ->fsync() to do this and push everything down into all the filesystems,
but I wasn't sure how well that would be recieved, so I'm taking this approach.
Thanks,

Josef
