Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47375 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760983Ab3DCNFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 09:05:44 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7DF2A9A0680
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 07:05:43 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <515B838A.7020000@jp.fujitsu.com>
In-Reply-To: <515B838A.7020000@jp.fujitsu.com>
Message-ID: <20130403130541.27335.23925@localhost.localdomain>
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction
Date: Wed, 3 Apr 2013 09:05:41 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Tsutomu Itoh (2013-04-02 21:19:06)
> Hi,
> 
> When inode_cache was specified for the mount option, I encountered the
> following messages at umount.
> 
> Step to reproduce:
> 
>  mkfs.btrfs -f /dev/sdc4
>  mount -o compress=lzo,autodefrag,inode_cache /dev/sdc4 /test1
>  dd if=/dev/zero of=/test1/file1 bs=1M count=8192
>  dd if=/test1/file1 of=/dev/null bs=1M
>  rm -f /test1/file1
>  umount /test1
> Apr  3 09:43:12 luna kernel: [  554.639149] BTRFS error (device sdc4) in btrfs_save_ino_cache:471: error 28

We're running out of space while saving the inode cache.  Strictly
speaking this should not abort the FS.  I'll take a look.

-chris
