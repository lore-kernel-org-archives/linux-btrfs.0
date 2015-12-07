Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39618 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859AbbLGPjB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 10:39:01 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 8 Dec 2015 01:38:58 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 056032CE8052
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 02:38:56 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tB7Fcd9g29229074
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Dec 2015 02:38:48 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tB7FcN4S020976
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Dec 2015 02:38:23 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log replay
Date: Mon, 07 Dec 2015 21:08:04 +0530
Message-ID: <8056366.2GdjmACnsD@localhost.localdomain>
In-Reply-To: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 07 Dec 2015 14:06:42 Qu Wenruo wrote:
> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> option to get real readonly mount, like "norecovery" in ext* and xfs.
> 
> Since the new parse_options() need to check new flags at remount time,
> so add a new parameter for parse_options().
>

Hello Qu,
The patch should add an entry into btrfs_show_options() for 'mount' command to
be able to display an entry corresponding to 'nologreplay' mount option.

Even after adding such an entry to btrfs_show_options(),
the following occurs,
# mount -o nologreplay,ro /dev/loop6 /mnt/
# mount | grep loop6
/dev/loop6 on /mnt type btrfs (ro,relatime,seclabel,nologreplay,space_cache,subvolid=5,subvol=/)
# mount -o remount,rw /dev/loop6 /mnt/
# mount | grep loop6
/dev/loop6 on /mnt type btrfs (rw,relatime,seclabel,nologreplay,space_cache,subvolid=5,subvol=/)

As can be seen from the last line, both 'rw' and 'nologreplay' options are set.

-- 
chandan

