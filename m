Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750970AbcJFM33 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 08:29:29 -0400
Date: Thu, 6 Oct 2016 08:29:28 -0400
From: Brian Foster <bfoster@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161006122927.GB16893@bfoster.bfoster>
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 04:12:56PM +0800, Qu Wenruo wrote:
> Hi,
> 
> Just as the title says, for some case(OK, btrfs again) we need to catch a
> file system in special timing.
> 
> In this specific case, we need to grab a btrfs image undergoing balancing,
> just before the balance finished.
> 
> Although we can use flakey to drop all write, we still don't have method to
> catch the timing of the that transaction.
> 
> 
> On the other hand, we can tweak our local kernel, adding msleep()/message
> and dump the disk during the sleep.
> And the image I dumped can easily trigger btrfs kernel and user-space bug.
> 
> So I'm wondering if I can just upload a zipped raw image as part of the test
> case?
> 

Doesn't necessarily bother me one way or the other, but something we've
done with XFS in such situations is introduce a DEBUG mode only sysfs
tunable that delays certain infrastructure (log recovery in our case) to
coordinate with test cases that try to reproduce such timing/racing
problems.

See test xfs/051 for an example..

Brian

> Thanks,
> Qu
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
