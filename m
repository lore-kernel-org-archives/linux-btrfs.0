Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58632 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3DFGUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 02:20:17 -0400
Received: by mail-pa0-f48.google.com with SMTP id lj1so2370871pab.7
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2013 23:20:16 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 0/2] Btrfs: quota rescan for 3.10
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Sat, 6 Apr 2013 14:20:12 +0800
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Message-Id: <372DEC00-3109-4B46-84DD-9D19FC34F98B@gmail.com>
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

	Would you please add more lines to the changelog(Just as what you have taught me~~)
It will be easier for us to review and test the patch before it comes into 3.10.


Thanks,
Wang
> The kernel side for rescan, which is needed if you want to enable qgroup
> tracking on a non-empty volume.
> 
> User space patches to come.
> 
> Jan Schmidt (2):
>  Btrfs: rescan for qgroups
>  Btrfs: automatic rescan after "quota enable" command
> 
> fs/btrfs/ctree.h           |   17 ++-
> fs/btrfs/disk-io.c         |    6 +
> fs/btrfs/ioctl.c           |   83 +++++++++++--
> fs/btrfs/qgroup.c          |  281 ++++++++++++++++++++++++++++++++++++++++++--
> include/uapi/linux/btrfs.h |   11 ++-
> 5 files changed, 364 insertions(+), 34 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

