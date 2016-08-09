Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37919 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbcHITJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 15:09:46 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: [PATCH 0/2][RFC] Provide accounting for dirty metadata
Date: Tue, 9 Aug 2016 15:08:25 -0400
Message-ID: <1470769707-26079-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has always had a dummy inode that we used to allocate pages for our
metadata.  This has allowed us to take advantage of balance_dirty_pages() since
our dirty metadata is unbounded otherwise.  This has worked fine for years, but
now we want to add sub pagesize blocksize support.  The easiest way to do this
would be to just kmalloc() our pages, since we already do all of our buffer
management ourselves anyway.  But in order to switch over to that we need to
kill the metadata inode and allow us to make our own allocations for metadata.

Enter these two patches.  The first one is fairly straightforward.
balance_dirty_pages() works on a per-bdi case, the only reason we pass mapping
around is so we can check and see if the fs we are working against has writeback
cgroups enabled.  So this change is just changing function arguments and has no
behavior change at all.

The second patch is where I'd like a little more attention.  I've added some
helpers to deal with the dirty metadata page accounting.  Basically this just
adds some page stats that balance_dirty_pages() can take into account when
deciding whether to kick the background writeback.  Then I've added a sb
callback to handle writing back dirty metadata, and I've added a list to the bdi
for the sb's attached to that bdi.  My plan is to just add/remove the btrfs sb
to it when we mount/umount.

Any suggestions are welcome, this is relatively self contained and doesn't
complicate things too much so I think works well, but I may not be thinking of
other cases.  Thanks,

Josef
