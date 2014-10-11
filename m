Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45521 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaJKGpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 02:45:36 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so2807129pdi.19
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 23:45:35 -0700 (PDT)
Date: Sat, 11 Oct 2014 14:45:29 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: return failure if btrfs_dev_replace_finishing()
 failed
Message-ID: <20141011064529.GI13950@dhcp-13-216.nay.redhat.com>
References: <1411640894-5160-1-git-send-email-guaneryu@gmail.com>
 <20141010071331.GG13950@dhcp-13-216.nay.redhat.com>
 <543797BA.3090103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <543797BA.3090103@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 10, 2014 at 04:24:26PM +0800, Miao Xie wrote:
> On Fri, 10 Oct 2014 15:13:31 +0800, Eryu Guan wrote:
> > On Thu, Sep 25, 2014 at 06:28:14PM +0800, Eryu Guan wrote:
> >> device replace could fail due to another running scrub process, but this
> >> failure doesn't get returned to userspace.
> >>
> >> The following steps could reproduce this issue
> >>
> >> 	mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
> >> 	mount /dev/sdb1 /mnt/btrfs
> >> 	while true; do
> >> 		btrfs scrub start -B /mnt/btrfs >/dev/null 2>&1
> >> 	done &
> >> 	btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs
> >> 	# if this replace succeeded, do the following and repeat until
> >> 	# you see this log in dmesg
> >> 	# BTRFS: btrfs_scrub_dev(/dev/sdb2, 2, /dev/sdb3) failed -115
> >> 	#btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs
> >>
> >> 	# once you see the error log in dmesg, check return value of
> >> 	# replace
> >> 	echo $?
> >>
> >> Also only WARN_ON if the return code is not -EINPROGRESS.
> >>
> >> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> > 
> > Ping, any comments on this patch?
> > 
> > Thanks,
> > Eryu
> >> ---
> >>  fs/btrfs/dev-replace.c | 8 +++++---
> >>  1 file changed, 5 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> >> index eea26e1..44d32ab 100644
> >> --- a/fs/btrfs/dev-replace.c
> >> +++ b/fs/btrfs/dev-replace.c
> >> @@ -418,9 +418,11 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
> >>  			      &dev_replace->scrub_progress, 0, 1);
> >>  
> >>  	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
> >> -	WARN_ON(ret);
> >> +	/* don't warn if EINPROGRESS, someone else might be running scrub */
> >> +	if (ret != -EINPROGRESS)
> >> +		WARN_ON(ret);
> 
> picky comment
> 
> I prefer WARN_ON(ret && ret != -EINPROGRESS).

Yes, this is simpler :)
> 
> >>  
> >> -	return 0;
> >> +	return ret;
> 
> here we will return -EINPROGRESS if scrub is running, I think it better that
> we assign some special number to args->result, and then return 0, just like
> the case the device replace is running.

Seems that requires a new result type, say,

#define BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS          3

and assign this result to args->result if btrfs_scrub_dev() returned -EINPROGRESS

But I don't think returning 0 unconditionally is a good idea, since
btrfs_dev_replace_finishing() could return other errors too, that way
these errors will be lost, and userspace still won't catch the
errors ($? is 0)

What I'm thinking about is something like:

	ret = btrfs_scrub_dev(...);
	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
	if (ret == -EINPROGRESS) {
		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
		ret = 0;
	} else {
		WARN_ON(ret);
	}

	return ret;

What do you think? If no objection I'll work on v2.

Thanks for your review!

Eryu
> 
> Thanks
> Miao
> 
> >>  
> >>  leave:
> >>  	dev_replace->srcdev = NULL;
> >> @@ -538,7 +540,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
> >>  			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> >>  		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> >>  
> >> -		return 0;
> >> +		return scrub_ret;
> >>  	}
> >>  
> >>  	printk_in_rcu(KERN_INFO
> >> -- 
> >> 1.8.3.1
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
