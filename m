Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57901 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752228AbeAQJZ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 04:25:26 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 8FE5549F19A3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 17:25:20 +0800 (CST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: xfstests/btrfs/125 with space_cache=v2 fails
Message-ID: <063975fc-ae59-0f11-e583-31df92e30af4@cn.fujitsu.com>
Date: Wed, 17 Jan 2018 17:29:47 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

While running xfstests/btrfs/125 with mount option 'space_cache=v2' on
Linux-4.10-rc1, 4.15-rc1 and 4.15-rc7, it *may* fail due to failure of
btrfs balance then hungs.

Btrfs progs version is 4.14.
And log:

https://drive.google.com/file/d/1HcurPjc9PfILg2Zj5z0VvF7g-OqgJnUK/view?usp=sharing
https://drive.google.com/file/d/16GtaFoXnDsoH2psxtXu905CvnJB5HzR6/view?usp=sharing
https://drive.google.com/file/d/1YWQIgnG1f7REO146VGiv4N-jD8uThdU3/view?usp=sharing

I wonder it is a bug of btrfs balance or something.

Thanks,
Su



