Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:64950 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab3DGLTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 07:19:55 -0400
Received: by mail-da0-f46.google.com with SMTP id y19so2197653dan.5
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 04:19:55 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V3 0/5] introduce a mutex lock and fix missing checks
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1365331558-848-1-git-send-email-wangshilong1991@gmail.com>
Date: Sun, 7 Apr 2013 19:19:49 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <2A914F48-498A-47FF-AEAC-F9529EDCDD37@gmail.com>
References: <1365331558-848-1-git-send-email-wangshilong1991@gmail.com>
To: "sensille@gmx.net Jansen" <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Arne,
	
	This patch-set mainly do two kind of things:
	1> introduce a mutex lock to avoid race conditions
	2> fix missing check before creating qgroup relations and
	btrfs_qgroup_inherit().

	I think the above two things should be fixed. However,
	this patch-set don't have ioctl checks, i want to make it
	a RFC patch:

	all the quota configurations are loaded in memory,
	so before operating in disk we can have a check if
	it is really necessary to operate in disk.[for example, creating
	a group has been existed].

	However, if we don't have this check, it should work
	ok for us too. Maybe to have a check in memory before will
        speed up the operations if operation should return errors.

	What do you think of ioctls checks?


Thanks,
Wang
	 
> between operations in disk and in memory.
> 
> Holding mutex lock, we can fix missing check before creating
> a qgroup(whether 'src' and 'dst' exist).And we can guarantee
> that all the qgroups in 'inherit' dose exist before tracking
> qgroup.
> 
> V2->V3:
> 	rename 'quota_lock' to 'qgroup_ioctl_lock' and holding
> 	'qgroup_ioctl_lock' inside qgroup.c to avoid serializing
> 	operations.
> V1->V2:
> 	use quota configurations in memory to speed up checks.
> 
> Wang Shilong (5):
>  Btrfs: introduce a mutex lock for btrfs quota operations
>  Btrfs: remove some unnecessary spin_lock usages
>  Btrfs: fix missing check before creating a qgroup relation
>  Btrfs: fix missing check in the btrfs_qgroup_inherit()
>  Btrfs: fix a warning when updating qgroup limit
> 
> fs/btrfs/ctree.h   |   3 ++
> fs/btrfs/disk-io.c |   1 +
> fs/btrfs/qgroup.c  | 136 ++++++++++++++++++++++++++++++++++-------------------
> 3 files changed, 92 insertions(+), 48 deletions(-)
> 
> -- 
> 1.7.11.7
> 

