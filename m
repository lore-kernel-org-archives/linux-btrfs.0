Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54749 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753105AbeGCWxA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 18:53:00 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
 <20180703042241.GI5567@merlins.org>
 <e72a5fe6-a6fc-ee70-870e-f98d4c7b8221@gmx.com>
 <CAJCQCtQVQryoycCORen=m26AtN+5__f2RnsjVP4vupSb9+0Tkw@mail.gmail.com>
 <20180703220025.jxevcqzstx23o6vf@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <db260625-c89d-b820-8fa2-1d5d4c03ae64@gmx.com>
Date: Wed, 4 Jul 2018 06:52:44 +0800
MIME-Version: 1.0
In-Reply-To: <20180703220025.jxevcqzstx23o6vf@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月04日 06:00, Marc MERLIN wrote:
> On Tue, Jul 03, 2018 at 03:46:59PM -0600, Chris Murphy wrote:
>> On Tue, Jul 3, 2018 at 2:50 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> There must be something wrong, however due to the size of the fs, and
>>> the complexity of extent tree, I can't tell.
>>
>> Right, which is why I'm asking if any of the metadata integrity
>> checker mask options might reveal what's going wrong?
>>
>> I guess the big issues are:
>> a. compile kernel with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y is necessary
>> b. it can come with a high resource burden depending on the mask and
>> where the log is being written (write system logs to a different file
>> system for sure)
>> c. the granularity offered in the integrity checker might not be enough.
>> d. might take a while before corruptions are injected before
>> corruption is noticed and flagged.
> 
> Back to where I'm at right now. I'm going to delete this filesystem and
> start over very soon. Tomorrow or the day after.
> I'm happy to get more data off it if someone wants it for posterity, but
> I indeed need to recover soon since being with a dead backup server is
> not a good place to be in :)

Feel free to recover asap, as the extent tree is really too large for
human to analyse manually.

Thanks,
Qu

> 
> Thanks,
> Marc
> 
