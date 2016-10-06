Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12086 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751027AbcJFINF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Oct 2016 04:13:05 -0400
To: <fstests@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Is is possible to submit binary image as fstest test case?
Message-ID: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
Date: Thu, 6 Oct 2016 16:12:56 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just as the title says, for some case(OK, btrfs again) we need to catch 
a file system in special timing.

In this specific case, we need to grab a btrfs image undergoing 
balancing, just before the balance finished.

Although we can use flakey to drop all write, we still don't have method 
to catch the timing of the that transaction.


On the other hand, we can tweak our local kernel, adding 
msleep()/message and dump the disk during the sleep.
And the image I dumped can easily trigger btrfs kernel and user-space bug.

So I'm wondering if I can just upload a zipped raw image as part of the 
test case?

Thanks,
Qu


