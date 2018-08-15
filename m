Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728896AbeHOP7F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 11:59:05 -0400
Message-ID: <5B742568.4000202@huawei.com>
Date: Wed, 15 Aug 2018 21:06:48 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 0/3] change some function to be void function
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com> <20180815125340.GN24025@twin.jikos.cz>
In-Reply-To: <20180815125340.GN24025@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/8/15 20:53, David Sterba wrote:
> On Wed, Aug 08, 2018 at 09:47:52PM +0800, zhong jiang wrote:
>> v3->v2:
>>  - Repost the patches with detailed changelog.
>> v1->v2:
>>  - Fix v1 issue that forget to return after remove the variable "ret".
>>
>> zhong jiang (3):
>>   fs/btrfs/disk-io: change btrfs_destroy_delayed_refs to be void
>>     function
>>   fs/btrfs/extent-tree: change btrfs_free_reserved_bytes to be void
>>     funtion
>>   fs/btrfs/tree-log: change btrfs_pin_log_trans to be void function
> The patches 2 and 3 can be applied, but please update che subject and
> put just "btrfs: " there, not the full file path. That we can find in
> the diff. The changelogs can be still improved to be clear about callers
> vs callees. Please update and resend.
>
> .
>
 Thank you for review and  suggestion.   I will repost v3.

Sincerely,
zhong jiang
