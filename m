Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752129AbdK2Sin (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 13:38:43 -0500
Subject: Re: [PATCHSET v2] cgroup, writeback, btrfs: make sure btrfs issues
 metadata IOs from the root cgroup
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>
CC: <axboe@kernel.dk>, <jbacik@fb.com>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20171010155441.753966-1-tj@kernel.org>
 <20171129165608.GA26740@quack2.suse.cz>
 <20171129170330.GV983427@devbig577.frc2.facebook.com>
 <20171129170501.GW983427@devbig577.frc2.facebook.com>
From: Chris Mason <clm@fb.com>
Message-ID: <fff25924-f632-8a6c-9e48-765971b09cca@fb.com>
Date: Wed, 29 Nov 2017 13:38:26 -0500
MIME-Version: 1.0
In-Reply-To: <20171129170501.GW983427@devbig577.frc2.facebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2017 12:05 PM, Tejun Heo wrote:
> On Wed, Nov 29, 2017 at 09:03:30AM -0800, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, Nov 29, 2017 at 05:56:08PM +0100, Jan Kara wrote:
>>> What has happened with this patch set?
>>
>> No idea.  cc'ing Chris directly.  Chris, if the patchset looks good,
>> can you please route them through the btrfs tree?
> 
> lol looking at the patchset again, I'm not sure that's obviously the
> right tree.  It can either be cgroup, block or btrfs.  If no one
> objects, I'll just route them through cgroup.

We'll have to coordinate a bit during the next merge window but I don't 
have a problem with these going in through cgroup.  Dave does this sound 
good to you?

I'd like to include my patch to do all crcs inline (instead of handing 
off to helper threads) when io controls are in place.  By the merge 
window we should have some good data on how much it's all helping.

-chris

