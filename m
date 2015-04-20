Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbbDTF2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:28:17 -0400
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Date: Mon, 20 Apr 2015 15:27:52 +1000
Subject: [PATCH 0/3] Allow fscache to work on BTRFS
Cc: linux-cachefs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <20150420052558.26554.97143.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following three patches allow fs to "cachefiles" in a BTRFS
filesystem.

The first is a minor cleanup to cachefiles.
The second is the main change - it teaches cachefile to use
lseek(SEEK_DATA) to find allocated blocks in a file, rather than bmap.
The third patch simply enables this for btrfs.

Thanks,
NeilBrown


---

NeilBrown (3):
      cachefiles: perform test on s_blocksize when opening cache file.
      fscache/cachefiles: optionally use SEEK_DATA instead of ->bmap.
      btrfs: set FS_SUPPORTS_SEEK_HOLE flag.


 fs/btrfs/super.c      |    3 +
 fs/cachefiles/namei.c |   13 ++++-
 fs/cachefiles/rdwr.c  |  125 ++++++++++++++++++++++++++++++-------------------
 include/linux/fs.h    |    1 
 4 files changed, 88 insertions(+), 54 deletions(-)

--
Signature

