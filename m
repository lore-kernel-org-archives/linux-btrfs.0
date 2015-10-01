Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35321 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbbJAMgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 08:36:51 -0400
Received: by ioiz6 with SMTP id z6so83054429ioi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2015 05:36:50 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151001115712.GA5885@twin.jikos.cz>
References: <1443696595-20641-1-git-send-email-chandan@linux.vnet.ibm.com>
	<20151001115712.GA5885@twin.jikos.cz>
Date: Thu, 1 Oct 2015 13:36:50 +0100
Message-ID: <CAL3q7H5BA8=32dt2k553gtTa6usOOGkNZj5Z5QY27omnF4hpAg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: create_subvol: Commit the current transaction if
 stale root entry exists.
From: Filipe Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 1, 2015 at 12:57 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Oct 01, 2015 at 04:19:55PM +0530, Chandan Rajendra wrote:
>> This occurs because,
>>
>> Mount filesystem
>> Create subvol with ID 257
>> Unmount filesystem
>> Mount filesystem
>> Delete subvol with ID 257
>>   btrfs_drop_snapshot()
>>     Add root corresponding to subvol 257 into
>>     btrfs_transaction->dropped_roots list
>> Create new subvol (i.e. create_subvol())
>>   257 is returned as the next free objectid
>
> How is this possible? We do not intentionally reuse the subvol ids so
> this means that the bug is in the id assignment code.

Very simple. Just look at inode-map.c's btrfs_find_free_objectid and
btrfs_find_highest_objectid...
As long as the deleted subvolume as the highest object id and before
deleting it no one called  btrfs_find_free_objectid() against the root
of tree roots.

If we do the initialization of a root's highest object id when we load
the root, instead of when we need to get an object id, the problem
shouldn't happen anymore.

>
>>   btrfs_read_fs_root_no_name()
>>     Finds the btrfs_root instance corresponding to the old subvol with ID 257
>>     in btrfs_fs_info->fs_roots_radix.
>>     Returns error since btrfs_root_item->refs has the value of 0.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
