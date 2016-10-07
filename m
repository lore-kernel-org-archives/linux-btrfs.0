Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34174 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751990AbcJGJ0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Oct 2016 05:26:44 -0400
Subject: Re: Is is possible to submit binary image as fstest test case?
To: Dave Chinner <david@fromorbit.com>
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161007091838.GG9806@dastard>
CC: <fstests@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f5f273e4-6d78-9ccd-64bf-480be7f05fbc@cn.fujitsu.com>
Date: Fri, 7 Oct 2016 17:26:27 +0800
MIME-Version: 1.0
In-Reply-To: <20161007091838.GG9806@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/07/2016 05:18 PM, Dave Chinner wrote:
> On Thu, Oct 06, 2016 at 04:12:56PM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> Just as the title says, for some case(OK, btrfs again) we need to
>> catch a file system in special timing.
>>
>> In this specific case, we need to grab a btrfs image undergoing
>> balancing, just before the balance finished.
>>
>> Although we can use flakey to drop all write, we still don't have
>> method to catch the timing of the that transaction.
>>
>>
>> On the other hand, we can tweak our local kernel, adding
>> msleep()/message and dump the disk during the sleep.
>> And the image I dumped can easily trigger btrfs kernel and user-space bug.
>>
>> So I'm wondering if I can just upload a zipped raw image as part of
>> the test case?
>
> Preferably not. We've managed to avoid pre-built images in xfstests
> for 15 years, so there'd have to be a really good reason to start
> doing this, especially as once we open that floodgate we'll end up
> with everyone wanting to do this and it will blow out the size of
> the repository in now time.

Makes sense.
For btrfs-progs, which includes test images, it already takes about 77M, 
even we have tried our best to reduce image size.

>
> If the issue is just timing or being unable to trigger an error
> at the right time, this is what error injection frameworks or
> debug-only sysfs hooks are for. The XFS kernel code has both,
> xfstests use both, and they pretty much do away with the need for
> custom binary filesystem images for such testing...

So again, btrfs is lacking infrastructure for debug.
It seems that we can only rely on images out of xfstest tree, created by 
some customized kernel for a long time.

Thanks for the reply.
Qu


>
> Cheers,
>
> Dave.
>


