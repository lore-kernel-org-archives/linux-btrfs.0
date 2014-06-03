Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaFCNjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 09:39:23 -0400
Date: Tue, 3 Jun 2014 15:39:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 3/4] btrfs: dev replace should replace the sysfs entry
Message-ID: <20140603133921.GL22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-4-git-send-email-anand.jain@oracle.com>
 <20140529132939.GD29992@twin.jikos.cz>
 <538835DB.5040900@oracle.com>
 <538D455E.90507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538D455E.90507@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:47:42AM +0800, Anand Jain wrote:
> >>>+    /* replace the sysfs entry */
> >>>+    rm_device_membership(fs_info, src_device);
> >>>+    add_device_membership(fs_info, tgt_device);
> >>>+
> >>>      btrfs_rm_dev_replace_blocked(fs_info);
> >>>
> >>>      btrfs_rm_dev_replace_srcdev(fs_info, src_device);
> >>
> >>569         btrfs_rm_dev_replace_unblocked(fs_info);
> >>570
> >>
> >>The comment that follows says
> >>
> >>571         /*
> >>572          * this is again a consistent state where no dev_replace
> >>procedure
> >>573          * is running, the target device is part of the
> >>filesystem, the
> >>574          * source device is not part of the filesystem anymore and
> >>its 1st
> >>575          * superblock is scratched out so that it is no longer
> >>marked to
> >>576          * belong to this filesystem.
> >>577          */
> >>
> >>and I think this is the right place to put the sysfs updates, because the
> >>srcdev is processed.
> >
> >Looking into this, will update. Thanks for the review.
> 
>  btrfs_rm_dev_replace_srcdev()  would destroy the btrfs_device of
>  src_device, and I am removing its sys/fs entry before we destroy
>  btrfs_device of src_device. Which is logically correct.

I agree, my analysis was wrong.
