From: Dave <dave@thekilempire.com>
Subject: Re: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
 failed.
Date: Tue, 2 Aug 2011 14:16:31 -0400
Message-ID: <20110802181630.GA5026@hendrix.borisch.local>
References: <20110802144452.GA15647@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110802144452.GA15647@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>

OK so on further investigation, I can see that btrfs-debug-tree is failing on:
ret = find_and_setup_root(tree_root, fs_info, BTRFS_CSUM_TREE_OBJECTID, csum_root);
(line 750 or so)

But the same call with extent_root and dev_root as arguments are successful.
Would this indicate that some branch on the tree holding the file checksums is
what's broken?  And if so, is there a way to mount the filesystem as read-only
while ignoring the checksum tree altogether?  Does this even make sense?
