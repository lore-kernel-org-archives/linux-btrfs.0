Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48241 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbbJUUzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 16:55:13 -0400
Date: Wed, 21 Oct 2015 23:55:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: check unsupported filters in balance arguments
Message-ID: <20151021205500.GD9839@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David Sterba,

The patch 8eb934591f8b: "btrfs: check unsupported filters in balance
arguments" from Oct 12, 2015, leads to the following static checker
warning:

	fs/btrfs/ioctl.c:4673 btrfs_ioctl_balance()
	warn: possible memory leak of 'bctl'

fs/btrfs/ioctl.c
  4624          bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
  4625          if (!bctl) {
  4626                  ret = -ENOMEM;
  4627                  goto out_bargs;
  4628          }
  4629  
  4630          bctl->fs_info = fs_info;
  4631          if (arg) {
  4632                  memcpy(&bctl->data, &bargs->data, sizeof(bctl->data));
  4633                  memcpy(&bctl->meta, &bargs->meta, sizeof(bctl->meta));
  4634                  memcpy(&bctl->sys, &bargs->sys, sizeof(bctl->sys));
  4635  
  4636                  bctl->flags = bargs->flags;
  4637          } else {
  4638                  /* balance everything - no filters */
  4639                  bctl->flags |= BTRFS_BALANCE_TYPE_MASK;
  4640          }
  4641  
  4642          if (bctl->flags & ~(BTRFS_BALANCE_ARGS_MASK | BTRFS_BALANCE_TYPE_MASK)) {
  4643                  ret = -EINVAL;
  4644                  goto out_bargs;

Memory leak on this path.

  4645          }
  4646  
  4647  do_balance:
  4648          /*
  4649           * Ownership of bctl and mutually_exclusive_operation_running
  4650           * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
  4651           * or, if restriper was paused all the way until unmount, in
  4652           * free_fs_info.  mutually_exclusive_operation_running is
  4653           * cleared in __cancel_balance.
  4654           */
  4655          need_unlock = false;
  4656  
  4657          ret = btrfs_balance(bctl, bargs);

We free bctl in btrfs_balance() most times.

  4658  
  4659          if (arg) {
  4660                  if (copy_to_user(arg, bargs, sizeof(*bargs)))
  4661                          ret = -EFAULT;
  4662          }
  4663  
  4664  out_bargs:
  4665          kfree(bargs);
  4666  out_unlock:
  4667          mutex_unlock(&fs_info->balance_mutex);
  4668          mutex_unlock(&fs_info->volume_mutex);
  4669          if (need_unlock)
  4670                  atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
  4671  out:
  4672          mnt_drop_write_file(file);
  4673          return ret;
  4674  }

regards,
dan carpenter
