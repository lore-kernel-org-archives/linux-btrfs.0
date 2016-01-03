Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34463 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcACFCU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 00:02:20 -0500
Received: by mail-lf0-f41.google.com with SMTP id y184so260529946lfc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 21:02:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8703019.0plYdL21k7@localhost.localdomain>
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com>
	<20151007092503.GG7734@twin.jikos.cz>
	<8703019.0plYdL21k7@localhost.localdomain>
Date: Sun, 3 Jan 2016 00:02:18 -0500
Message-ID: <CA+X5Wn5EKaSwD1B1H9Sd+QRcKezOMmE6GaGMVjPFZRNAwhe4oA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when
 loading tree root and subvolume roots
From: james harvey <jamespharvey20@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@gmail.com,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bump.

Pretty sure I just ran into this, outside of a testing scenario.  See
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/51796

Looks like the patch was never committed.

On Wed, Oct 7, 2015 at 10:10 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Wednesday 07 Oct 2015 11:25:03 David Sterba wrote:
>> On Mon, Oct 05, 2015 at 10:14:24PM +0530, Chandan Rajendra wrote:
>> > +   if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
>> > +           mutex_unlock(&root->objectid_mutex);
>> > +           ret = -ENOSPC;
>>
>> ENOSPC ... I don't think it's right as this could be with a normal
>> enospc during subvolume creation. The problem is that theh inode number
>> space is exhausted, the closest error code I see is EOVERFLOW. As this
>> is an ioctl we can afford to define the meaning of this return value as
>> such (unlike for eg. creat()/open()).
>>
>> > +           goto free_root_dev;
>> > +   }
>> > +
>> > +   mutex_unlock(&root->objectid_mutex);
>> > +
>> >
>> >     return 0;
>
> David, Are you suggesting that we return -EOVERFLOW from within
> btrfs_init_fs_root() and continue returning -ENOSPC in case of error
> (i.e. tree_root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID) from
> open_ctree()?
>
> If yes, btrfs_init_fs_root() gets invoked from open_ctree() via
> btrfs_read_fs_root_no_name() and hence we may end up returning -EOVERFLOW when
> servicing the mount() syscall.
>
> --
> chandan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
