Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62613 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750890AbdIKGqt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:46:49 -0400
Subject: Re: BTRFS Deduplication
To: shally verma <shallyvermacavium@gmail.com>, linux-btrfs@vger.kernel.org
Cc: "Verma, Shally" <shally.verma@cavium.com>
References: <CAP9W88gEje_unDuNTGCZXn5PKoDwHtTgrjc7Cwzn0a_2KWtWow@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <03f4db85-bd2c-679d-e369-65ccc5d61ad7@gmx.com>
Date: Mon, 11 Sep 2017 14:46:37 +0800
MIME-Version: 1.0
In-Reply-To: <CAP9W88gEje_unDuNTGCZXn5PKoDwHtTgrjc7Cwzn0a_2KWtWow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月11日 14:05, shally verma wrote:
> I was going through  BTRFS Deduplication page
> (https://btrfs.wiki.kernel.org/index.php/Deduplication) and I read
> 
> "As such, xfs_io, is able to perform deduplication on a BTRFS file system," ..
> 
> following this, I followed on to xfs_io link https://linux.die.net/man/8/xfs_io
> 
> As I understand, these are set of commands allow us to do different
> operations on "xfs" filesystem.

Nope, it's just a tool triggering different read/write or ioctls.
In fact most of its command is fs independent.
Only a limited number of operations are only supported by XFS.

It's just due to historical reasons it's still named as xfs_io.

I won't be surprised if one day it's split as an independent tool.

> and command set mentioned here, couldn't see which is command to
> invoke dedupe task.

"dedupe" and "reflink" command.

> and how this works with BTRFS.

Fs support FIDEDUPERANGE or BTRFS_IOC_FILE_EXTENT_SAME ioctl can use it 
to determine if two ranges are containing identical data.

And if they are identical, we use FICLONERANGE or BTRFS_IOC_CLONE_RANGE 
ioctl to reflink one to another, freeing one of them.

BTW nowadays, such dedupe and reflink ioctl is genericized in VFS.
file_operations structure now includes both clone_file_range() and 
dedupe_file_range() callbacks now.

Thanks,
Qu
> 
> So, can anyone help here and point me what am I missing here.
> 
> Thanks
> Shally
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
