Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46859 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaJNDfv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 23:35:51 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so7029280pab.32
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 20:35:50 -0700 (PDT)
Date: Tue, 14 Oct 2014 11:35:45 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: return failure if
 btrfs_dev_replace_finishing() failed
Message-ID: <20141014033545.GL13950@dhcp-13-216.nay.redhat.com>
References: <1413175333-26095-1-git-send-email-guaneryu@gmail.com>
 <543B6FFD.5070409@oracle.com>
 <20141013065938.GJ13950@dhcp-13-216.nay.redhat.com>
 <543BA6DC.9060106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <543BA6DC.9060106@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 06:18:04PM +0800, Anand Jain wrote:
> 
> 
> On 10/13/14 14:59, Eryu Guan wrote:
> >On Mon, Oct 13, 2014 at 02:23:57PM +0800, Anand Jain wrote:
> >>
> >>
> >>comments below..
> >>
> >>
> >>On 10/13/14 12:42, Eryu Guan wrote:
> >>>device replace could fail due to another running scrub process or any
> >>>other errors btrfs_scrub_dev() may hit, but this failure doesn't get
> >>>returned to userspace.
> >>>
> >>>The following steps could reproduce this issue
> >>>
> >>>	mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
> >>>	mount /dev/sdb1 /mnt/btrfs
> >>>	while true; do btrfs scrub start -B /mnt/btrfs >/dev/null 2>&1; done &
> >>>	btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs
> >>>	# if this replace succeeded, do the following and repeat until
> >>>	# you see this log in dmesg
> >>>	# BTRFS: btrfs_scrub_dev(/dev/sdb2, 2, /dev/sdb3) failed -115
> >>>	#btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs
> >>>
> >>>	# once you see the error log in dmesg, check return value of
> >>>	# replace
> >>>	echo $?
> >>>
> >>>Introduce a new dev replace result
> >>>
> >>>BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS
> >>>
> >>>to catch -EINPROGRESS explicitly and return other errors directly to
> >>>userspace.
> >>>
> >>>Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> >>>---
> >>>
> >>>v2:
> >>>- set result to SCRUB_INPROGRESS if btrfs_scrub_dev returned -EINPROGRESS
> >>>   and return 0 as Miao Xie suggested
> >>>
> >>>  fs/btrfs/dev-replace.c     | 12 +++++++++---
> >>>  include/uapi/linux/btrfs.h |  1 +
> >>>  2 files changed, 10 insertions(+), 3 deletions(-)
> >>>
> >>>diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> >>>index eea26e1..a141f8b 100644
> >>>--- a/fs/btrfs/dev-replace.c
> >>>+++ b/fs/btrfs/dev-replace.c
> >>>@@ -418,9 +418,15 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
> >>>  			      &dev_replace->scrub_progress, 0, 1);
> >>>
> >>>  	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
> >>>-	WARN_ON(ret);
> >>>+	/* don't warn if EINPROGRESS, someone else might be running scrub */
> >>>+	if (ret == -EINPROGRESS) {
> >>>+		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
> >>>+		ret = 0;
> >>>+	} else {
> >>>+		WARN_ON(ret);
> >>>+	}
> 
> 
>  I am bit concerned, why these racing threads here aren't excluding
>  each other using "mutually_exclusive_operation_running" ? as most
>  of the other device operation thread does.
> 
> Thanks, Anand

btrfs_ioctl_scrub() doesn't use mutually_exclusive_operation_running
as other device operations do, I'm not sure if it should(seems scrub
should do it too to me).

But I think that's a different problem from the one I'm trying to fix
here. The main purpose is to return error to userspace when
btrfs_scrub_dev() hit some error. Dealing with -EINPROGRESS is to
match the current behavior(replace and scrub could run at the same
time).

Thanks,
Eryu
> 
> >>  looks like was are trying to manage EINPROGRESS returned by
> >
> >Yes, that's right.
> >
> >>  btrfs_dev_replace_finishing(). In btrfs_dev_replace_finishing()
> >>  which specific func call is returning EINPROGRESS ? I didn't go
> >>  deep enough.
> >
> >btrfs_dev_replace_finishing() will check the scrub_ret(the last
> >argument), and return scrub_ret if (!scrub_ret). It was returning 0
> >unconditionally before this patch.
> >
> >btrfs_dev_replace_start@fs/btrfs/dev-replace.c
> >    416          ret = btrfs_scrub_dev(fs_info, src_device->devid, 0,
> >    417                                src_device->total_bytes,
> >    418                                &dev_replace->scrub_progress, 0, 1);
> >    419
> >    420          ret = btrfs_dev_replace_finishing(root->fs_info, ret);
> >
> >and btrfs_dev_replace_finishing@fs/btrfs/dev-replace.c
> >    529          if (!scrub_ret) {
> >    530                  btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
> >    531                                                                  src_device,
> >    532                                                                  tgt_device);
> >    533          } else {
> >......
> >    547                  return scrub_ret;
> >    548          }
> 
> 
> 
> 
> 
> >>
> >>  And how do we handle if replace is intervened by balance
> >>  instead of scrub ?
> >
> >Based on my test, replace ioctl would return -ENOENT if balance is
> >running
> >
> >ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/testarea/scratch": No such file or directory, no error
> >
> >(I haven't gone through this codepath yet and don't know where -ENOENT
> >comes from, but I don't think it's a proper errno,
> >/mnt/testarea/scratch is definitely there)
> >>
> >>  sorry if I missed something.
> >>
> >>Anand
> >
> >Thanks for the review!
> >
> >Eryu
> >>
> >>
> >>>-	return 0;
> >>>+	return ret;
> >>>
> >>>  leave:
> >>>  	dev_replace->srcdev = NULL;
> >>>@@ -538,7 +544,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
> >>>  			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> >>>  		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> >>>
> >>>-		return 0;
> >>>+		return scrub_ret;
> >>>  	}
> >>>
> >>>  	printk_in_rcu(KERN_INFO
> >>>diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> >>>index 2f47824..611e1c5 100644
> >>>--- a/include/uapi/linux/btrfs.h
> >>>+++ b/include/uapi/linux/btrfs.h
> >>>@@ -157,6 +157,7 @@ struct btrfs_ioctl_dev_replace_status_params {
> >>>  #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR			0
> >>>  #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED		1
> >>>  #define BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED		2
> >>>+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS		3
> >>>  struct btrfs_ioctl_dev_replace_args {
> >>>  	__u64 cmd;	/* in */
> >>>  	__u64 result;	/* out */
> >>>
