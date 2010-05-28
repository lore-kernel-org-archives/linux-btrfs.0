From: Dan Carpenter <error27@gmail.com>
Subject: dereferencing freed variable in "add basic DIO read/write support"
Date: Fri, 28 May 2010 12:33:59 +0200
Message-ID: <20100528103359.GW22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Smatch complains about a possible freed pointer deref introduced by:
4b46fce2334 "Btrfs: add basic DIO read/write support".  Could you take a
look?

fs/btrfs/inode.c +5716 btrfs_submit_direct(79)
  5705  out_err:
  5706          kfree(dip->csums);
  5707          kfree(dip);
                ^^^^^^^^^^^

	dip is freed here.

  5708  free_ordered:
  5709          /*
  5710           * If this is a write, we need to clean up the reserved space and kill
  5711           * the ordered extent.
  5712           */
  5713          if (write) {
  5714                  struct btrfs_ordered_extent *ordered;
  5715                  ordered = btrfs_lookup_ordered_extent(inode,
  5716				dip->logical_offset);
                                ^^^^^^^^^^^^^^^^^^^

	dereferenced here.  Actually, dip could also be null here if the
	kmalloc failed()


regards,
dan carpenter
