Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2LQHYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 02:24:38 -0500
Message-ID: <50CEC8C5.8010201@cn.fujitsu.com>
Date: Mon, 17 Dec 2012 15:24:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix remount vs autodefrag
References: <50B32FE7.5080908@cn.fujitsu.com> <50B3362D.1030409@cn.fujitsu.com> <20121214175106.GH3152@localhost.localdomain>
In-Reply-To: <20121214175106.GH3152@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 14 Dec 2012 12:51:06 -0500, Josef Bacik wrote:
> On Mon, Nov 26, 2012 at 02:28:13AM -0700, Miao Xie wrote:
>> If we remount the fs to close the auto defragment or make the fs R/O, we should
>> stop the auto defragment.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> I'm dropping this patch, it causes a deadlock since defrag will need to reserve
> metadata which could call writeback_sb_nr_if_idle which does a
> down_read(&sb->s_umount).  Figure out another way to fix this and I'll apply it.
> Thanks,

Hi, Josef

I forget to point out this patch is based on my patches:
	[PATCH 1/2 RESEND] vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and rename them
	[PATCH 2/2 RESEND] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr() fails

But I found you implemented a new writeback_sb_nr_if_idle()(Btrfs: fix autodefrag and umount lockup),
with this new function, my patch(Btrfs: fix remount vs autodefrag) also can wrok well.

Thanks
Miao

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

