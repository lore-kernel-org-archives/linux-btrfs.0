Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48344 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab2LNRvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 12:51:09 -0500
Date: Fri, 14 Dec 2012 12:51:06 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix remount vs autodefrag
Message-ID: <20121214175106.GH3152@localhost.localdomain>
References: <50B32FE7.5080908@cn.fujitsu.com>
 <50B3362D.1030409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50B3362D.1030409@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 26, 2012 at 02:28:13AM -0700, Miao Xie wrote:
> If we remount the fs to close the auto defragment or make the fs R/O, we should
> stop the auto defragment.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

I'm dropping this patch, it causes a deadlock since defrag will need to reserve
metadata which could call writeback_sb_nr_if_idle which does a
down_read(&sb->s_umount).  Figure out another way to fix this and I'll apply it.
Thanks,

Josef
