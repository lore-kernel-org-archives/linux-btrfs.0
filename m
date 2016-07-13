Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34474 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbcGMSHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 14:07:32 -0400
Date: Wed, 13 Jul 2016 14:07:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Nikolay Borisov <kernel@kyup.com>
Cc: Jan Kara <jack@suse.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        dvyukov@google.com, linux-btrfs@vger.kernel.org,
        SiteGround Operations <operations@siteground.com>
Subject: Re: GPF in __mark_inode_dirty due to
 locked_inode_to_wb_and_lock_list returning NULL
Message-ID: <20160713180724.GI4065@mtj.duckdns.org>
References: <5774FFF6.3030408@kyup.com>
 <20160701100050.GC22922@quack2.suse.cz>
 <20160701173827.GE28719@htj.duckdns.org>
 <577A6177.60602@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <577A6177.60602@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Mon, Jul 04, 2016 at 04:15:35PM +0300, Nikolay Borisov wrote:
> So the btrfs fs was created inside a loop device and mounted with -o loop. 
> Evidently from the oops it seems that this is the normal umount path, meaning 
> that no device hot plugging was in action. Unfortunately I don't have a reproducer. 
> However, the workload looks like the following: 
> 
> 1. mount -t btrfs -o compress=zlib -o subvol="${subvol}" -o loop "${storage_file}" "${mount_point}"
> 2. Do reads/writes (rsync) (dirtying some pages)
> 3. umount "${mount_point}"

I see.  Yeah, normal umount path does destroy the block device and can
trigger the bug.  Please ping if the issue happens again with the
patches applied.

Thanks.

-- 
tejun
