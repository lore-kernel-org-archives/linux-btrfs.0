From: Josef Bacik <josef@redhat.com>
Subject: [RFE] Add a new super operation for finding block devices in a super
Date: Mon, 14 Mar 2011 11:37:38 -0400
Message-ID: <1300117060-13613-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs can span multiple devices, so sb->s_bdev will not always point to the
block device that we are looking to freeze.  This isn't a huge issue since the
only thing that freezes per-bdev is device-mapper, but if btrfs spans multiple
dm devices then we could run into corruption issues as we could end up not
actually freezing the super properly.  So enter contains_bdev.  This will be
used by get_active_super, if the sb implements contains_bdev we just ask the fs
if it has the bdev we want and if so we are good to go.  I'm not married to the
name, so if anybody has any better suggestions I'm open to them.  Comments?
Thanks,

Josef
