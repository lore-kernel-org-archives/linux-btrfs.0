Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:53174 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751087AbdEITZj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 15:25:39 -0400
To: bo.li.liu@oracle.com
References: <22795.14626.978819.534566@tree.ty.sabi.co.uk>
 <f1bbe501-0897-c8e0-36ff-2f4cf005fa45@techsquare.com>
 <20170509191444.GE17312@lim.localdomain>
Cc: pg@btrfs.list.sabi.co.UK, linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <d883bdfa-aecd-4329-8afd-4f2d0f13a538@techsquare.com>
Date: Tue, 9 May 2017 15:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <20170509191444.GE17312@lim.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: Struggling with file system slowness
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Those snapshots were created using Marc Merlin's script (thanks, Marc). 
They don't do anything except sit around on the file system for a week 
or so and then are removed.

I'm now doing quarter-hourly snaps instead of nightly since I have 
nightly backups of the filesytem going off-site.  So far the 
btrfs-transaction and memory spikes have not returned.

-Matt





On 05/09/2017 03:14 PM, Liu Bo wrote:
> On Fri, May 05, 2017 at 09:24:32AM -0400, Matt McKinnon wrote:
>>> Too little information. Is IO happening at the same time? Is
>>> compression on? Deduplicated? Lots of subvolumes? SSD? What
>>> kind of workload and file size/distribution profile?
>>
>> Only write IO during the load spikes.  No compression, no deduplication.  12
>> volumes (including snapshots).  Spinning disks.  Medium workload; file sizes
>> are all over the map since this hold about 30 user home directories.
>>
>> Interestingly enough, the problems which had persisted for many weeks went
>> away when all snapshots were removed.  btrfs-transaction spikes disappeared.
>> Memory usage went from 30G to under 2G.
>>
>
> Were those snapshots served as backup?
>
> Could you please elaborate how you create snapshots?  We could
> probably hammer out a testcase to improve the situation.
>
> Thanks,
>
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
