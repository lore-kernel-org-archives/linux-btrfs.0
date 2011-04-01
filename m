From: Peter Stuge <peter@stuge.se>
Subject: Re: another messed-up btrfs
Date: Fri, 1 Apr 2011 22:01:46 +0200
Message-ID: <20110401200147.23440.qmail@stuge.se>
References: <20110401194713.6990@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110401194713.6990@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Fahr wrote:
> btrfsck: disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)' failed.

My fs is also broken this way, though for me it happened after
resizing the fs and then partition. I still need to go back to the
list thread and do some work on my image.


> The usual questions: Is there anything I could do to help analyze
> and fix the problem? Is there hope to restore the data any time
> soon, or should I better use the backup I have (and possibly move
> to an ext4 file system)?

It seems the root node is a bit of a sore point with btrfs. :\


//Peter
