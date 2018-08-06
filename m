Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbeHFEoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 00:44:03 -0400
Message-ID: <5B67B454.1050604@huawei.com>
Date: Mon, 6 Aug 2018 10:37:08 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Nikolay Borisov <nborisov@suse.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove uneeded variable "err"
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com> <c9f07f02-38c0-7491-3b48-0dda20f60d13@suse.com>
In-Reply-To: <c9f07f02-38c0-7491-3b48-0dda20f60d13@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/8/6 3:14, Nikolay Borisov wrote:
>
> On  5.08.2018 18:02, zhong jiang wrote:
>> zhong jiang (3):
>>   fs/btrfs/disk-io: Remove unneeded variable "err"
>>   fs/btrfs/extent-tree: remove redudant variable "err"
>>   fs/btrfs/tree-log: remove the unneeded variable "err"
>>
>>  fs/btrfs/disk-io.c     | 12 ++++--------
>>  fs/btrfs/extent-tree.c |  6 ++----
>>  fs/btrfs/tree-log.c    |  5 +----
>>  fs/btrfs/tree-log.h    |  2 +-
>>  4 files changed, 8 insertions(+), 17 deletions(-)
>>
>
> NAK on the whole series on the basis of using a bulk commit message
> which doesn't really describe the changes of each individual commit. If
> you want those changes to eventually be merged resubmit the series with
> individual reasoning for every commit.
>
>
 It's sorry for using a bulk commit message. I will repost with a patch
 because it solves the same issue.

Thanks,
zhong jiang

