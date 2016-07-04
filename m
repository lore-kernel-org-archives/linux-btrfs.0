Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35135 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbcGDNPj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 09:15:39 -0400
Received: by mail-wm0-f42.google.com with SMTP id z126so41654069wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 06:15:38 -0700 (PDT)
Subject: Re: GPF in __mark_inode_dirty due to locked_inode_to_wb_and_lock_list
 returning NULL
To: Tejun Heo <tj@kernel.org>
References: <5774FFF6.3030408@kyup.com>
 <20160701100050.GC22922@quack2.suse.cz>
 <20160701173827.GE28719@htj.duckdns.org>
Cc: Jan Kara <jack@suse.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        dvyukov@google.com, linux-btrfs@vger.kernel.org,
        SiteGround Operations <operations@siteground.com>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <577A6177.60602@kyup.com>
Date: Mon, 4 Jul 2016 16:15:35 +0300
MIME-Version: 1.0
In-Reply-To: <20160701173827.GE28719@htj.duckdns.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/01/2016 08:38 PM, Tejun Heo wrote:
> On Fri, Jul 01, 2016 at 12:00:50PM +0200, Jan Kara wrote:
>> Hello,
>>
>> On Thu 30-06-16 14:18:14, Nikolay Borisov wrote:
>>> In light of the discussion in https://patchwork.kernel.org/patch/9187411/ and 
>>> the discussion at https://groups.google.com/forum/#!topic/syzkaller/XvxH3cBQ134
>>
>> Well, it looks it is also some bdi_writeback lifetime issue but I don't see
>> how it would be related to I_DIRTY_TIME issues. There were couple of fixes
>> related to bdi_writeback issues from Tejun since 4.4. Maybe Tejun can tell
>> you whether he's seen this or not...
> 
> Yeah, this could be the same problem from the blkdev detach path.
> Nikolay, was there any block device hot unplugging going on?  If not,
> do you have a reproducer?

So the btrfs fs was created inside a loop device and mounted with -o loop. 
Evidently from the oops it seems that this is the normal umount path, meaning 
that no device hot plugging was in action. Unfortunately I don't have a reproducer. 
However, the workload looks like the following: 

1. mount -t btrfs -o compress=zlib -o subvol="${subvol}" -o loop "${storage_file}" "${mount_point}"
2. Do reads/writes (rsync) (dirtying some pages)
3. umount "${mount_point}"


> 
> Thanks.
> 
