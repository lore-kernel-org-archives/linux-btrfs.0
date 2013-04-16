Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:58102 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017Ab3DPKoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:44:12 -0400
Message-ID: <516D293A.10502@jan-o-sch.net>
Date: Tue, 16 Apr 2013 12:34:34 +0200
From: Jan Schmidt <mail@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Btrfs: rescan for qgroups
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net> <516D2313.6050004@cn.fujitsu.com>
In-Reply-To: <516D2313.6050004@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 16, 2013 at 12:08 (+0200), Wang Shilong wrote:
> Hello Jan,
>  
> 
>>  	slot = path->slots[0];
>>  	ptr = btrfs_item_ptr(l, slot, struct btrfs_qgroup_status_item);
>> +	spin_lock(&fs_info->qgroup_lock);
> 
> 
> Why we need hold qgroup_lock here? would you please explain...

It would have been easier for me if you had left the relevant context in there,
but I finally found it.

Thinking again about it, as update_qgroup_status_item is only called from
transaction commit context, we can do without a spinlock here. I meant to
protect fs_info->qgroup_flags and fs_info->qgroup_rescan_progress, but it seems
not required.

Thanks,
-Jan
