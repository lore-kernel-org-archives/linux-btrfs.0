Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaFIOkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 10:40:18 -0400
Date: Mon, 9 Jun 2014 17:40:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: split up __extent_writepage to lower stack usage
Message-ID: <20140609144014.GA8771@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris Mason,

The patch 263524b4ac6b: "Btrfs: split up __extent_writepage to lower
stack usage" from May 21, 2014, leads to the following static checker
warning:

	fs/btrfs/extent_io.c:4071 try_release_extent_state()
	warn: use 'mask' here instead of GFP_XXX?

fs/btrfs/extent_io.c
  4053  static int try_release_extent_state(struct extent_map_tree *map,
  4054                                      struct extent_io_tree *tree,
  4055                                      struct page *page, gfp_t mask)
  4056  {
  4057          u64 start = page_offset(page);
  4058          u64 end = start + PAGE_CACHE_SIZE - 1;
  4059          int ret = 1;
  4060  
  4061          if (test_range_bit(tree, start, end,
  4062                             EXTENT_IOBITS, 0, NULL))
  4063                  ret = 0;
  4064          else {
  4065                  if ((mask & GFP_NOFS) == GFP_NOFS)
  4066                          mask = GFP_NOFS;
  4067                  /*
  4068                   * at this point we can safely clear everything except the
  4069                   * locked bit and the nodatasum bit
  4070                   */
  4071                  ret = clear_extent_bit(tree, start, end,
  4072                                   ~(EXTENT_LOCKED | EXTENT_NODATASUM),
  4073                                   0, 0, NULL, GFP_ATOMIC);
                                                     ^^^^^^^^^^
It upsets the static checkers to keep "mask" around when we don't use it
anymore.

  4074  
  4075                  /* if clear_extent_bit failed for enomem reasons,
  4076                   * we can't allow the release to continue.
  4077                   */
  4078                  if (ret < 0)
  4079                          ret = 0;
  4080                  else
  4081                          ret = 1;
  4082          }
  4083          return ret;
  4084  }

regards,
dan carpenter
