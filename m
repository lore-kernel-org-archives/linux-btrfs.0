Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3975 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751581AbdF3P2f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 11:28:35 -0400
Date: Fri, 30 Jun 2017 23:28:28 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear header rev
Message-ID: <20170630152828.GD7046@lufq.5F>
References: <20170626235502.26267-1-bo.li.liu@oracle.com>
 <20170627190712.GC1886@lim.localdomain>
 <20170630145253.GV2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170630145253.GV2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 30, 2017 at 04:52:54PM +0200, David Sterba wrote:
>On Tue, Jun 27, 2017 at 12:07:13PM -0700, Liu Bo wrote:
>> On Mon, Jun 26, 2017 at 05:55:02PM -0600, Liu Bo wrote:
>> > So btrfs_set_header_flags() vs btrfs_set_header_flag, the difference is sort of
>> > similar to "=" vs "|=", when creating and initialising a new extent buffer,
>> > convert uses the former one which clears header_rev by accident.
>> >
>> 
>> Here is the regression test script,
>> 
>> mkfs.ext4 -F /disk
>> btrfs-convert -d /disk
>> mount /disk /mnt
>> xfs_io -f -c "pwrite 0 4K" /mnt/foobar
>> umount /disk
>> 
>> ---------------
>> It'd end up with 'unable to find ref blabla" shown in dmesg log.
>
>I can't reproduce it, is there something else needed? Tested kernel is
>4.11.6. Check does not complain either.

Excuse me, is your btrfs-progs already applied this patch?

I'm sure that I can reproduce it in my test environment.
1. kernel 4.11.6
2. btrfs-progs kdave/devel(drop this patch)

-- 
Thanks,
Lu


