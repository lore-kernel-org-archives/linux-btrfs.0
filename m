Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbbKLJgT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 04:36:19 -0500
Date: Thu, 12 Nov 2015 12:36:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: extend balance filter usage to take minimum and maximum
Message-ID: <20151112093607.GA28337@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David Sterba,

The patch bc3094673f22: "btrfs: extend balance filter usage to take
minimum and maximum" from Oct 20, 2015, leads to the following static
checker warning:

	fs/btrfs/volumes.c:3063 update_balance_args()
	warn: we tested 'bctl->data.flags & (1 << 8)' before and it was 'false'

fs/btrfs/volumes.c
  3054          /*
  3055           * Turn on usage filter if is not already used.  The idea is
  3056           * that chunks that we have already balanced should be
  3057           * reasonably full.  Don't do it for chunks that are being
  3058           * converted - that will keep us from relocating unconverted
  3059           * (albeit full) chunks.
  3060           */
  3061          if (!(bctl->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
  3062              !(bctl->data.flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
  3063              !(bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT)) {

USAGE_RANGE and ARGS_CONVERT are both BIT(8) so this is duplicative.

  3064                  bctl->data.flags |= BTRFS_BALANCE_ARGS_USAGE;
  3065                  bctl->data.usage = 90;
  3066          }
  3067          if (!(bctl->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
  3068              !(bctl->sys.flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
  3069              !(bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT)) {

Same.

  3070                  bctl->sys.flags |= BTRFS_BALANCE_ARGS_USAGE;
  3071                  bctl->sys.usage = 90;
  3072          }
  3073          if (!(bctl->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
  3074              !(bctl->meta.flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
  3075              !(bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT)) {

Same.

  3076                  bctl->meta.flags |= BTRFS_BALANCE_ARGS_USAGE;
  3077                  bctl->meta.usage = 90;
  3078          }
  3079  }


regards,
dan carpenter
