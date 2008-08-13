From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/3] Introduce btrfs_iget helper
Date: Wed, 13 Aug 2008 10:07:14 +0100
Message-ID: <1218618434.2977.237.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
	 <1218548800.2977.178.camel@pmac.infradead.org>
	 <20080812184654.GA29426@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080812184654.GA29426@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-12 at 14:46 -0400, Christoph Hellwig wrote:
> Please leave the unlock_new_inode to the caller and kill the is_new
> parameter. Gives much nicer to read code, and generally making sure the
> inode is 100% ready and correct before unlocking it is a good idea, too
> so that e.g. no one can actually access an inode marked bad due to a
> generation number mismatch before it's marked bad.

Unconvinced -- I don't like the idea that we'd sometimes return a locked
inode, sometimes not, and force the callers to handle that.

And the inode _is_ ready and correct. We don't mark inodes bad because
of a generation number mismatch -- we just return -ESTALE and drop our
refcount on the inode. The inode itself is fine and there's no issue
with it being unlocked.

The code in btrfs_lookup() which goes...
		/* the inode and parent dir are two different roots */
		if (new && root != sub_root) {
			igrab(inode);
			sub_root->inode = inode;
			do_orphan = 1;
		}
... should also be fine when the inode is unlocked, too.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



