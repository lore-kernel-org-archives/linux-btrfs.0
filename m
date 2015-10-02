Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51427 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbJBIgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 04:36:03 -0400
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
To: Dave Chinner <david@fromorbit.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929215135.GZ3902@dastard>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <560E41E9.2020204@gmx.com>
Date: Fri, 2 Oct 2015 16:35:53 +0800
MIME-Version: 1.0
In-Reply-To: <20150929215135.GZ3902@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave, I updated the patch and moved it to btrfs.

But I still has some question about the fallocate behavior.

Just as the new btrfs test case, I changed the fallocate range, not to 
cover the last part, to make the problem more obvious:

Btrfs will truncate beyond EOF even that's *not covered* by the 
fallocate range.

It's OK for a fs to modify the extent layout during fallocate, but is it 
OK to modify extent layout completely *out* of the fallocate range?

Thanks,
Qu

在 2015年09月30日 05:51, Dave Chinner 写道:
> On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
>> Normally, a bull fallocate call on a fully written and synced file
>> should not add an extent.
>
> Why not? Filesystems can do whatever they want with extents during
> a fallocate call. e.g. if the blocks are shared, then fallocate
> might break the block sharing so future overwrites don't get
> ENOSPC. This is a requirement set down by posix_fallocate(3)
>
> "After a successful call to posix_fallocate(), subsequent writes to
> bytes in the specified range are guaranteed not  to fail because of
> lack of disk space."
>
> Hence if you've got a file with shared blocks, a "full fallocate"
> must change the extent layout to break the sharing. As such, the
> premise of this test is wrong.
>
> That's not to say that btrfs has a bug:
>
>> Btrfs has a bug to always truncate the last page if the fallocate start
>> offset is smaller than inode size.
>
> But it' not clear that this behaviour is actually a bug if it's not
> changing the file data.
>
> Cheers,
>
> Dave.
>
