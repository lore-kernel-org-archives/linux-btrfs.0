Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1034533AbcIVRuv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:50:51 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "Jeff Mahoney" <jeffm@suse.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
 <1472844353.3083.1.camel@gmail.com>
 <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
 <1473359094.7190.1.camel@gmail.com>
 <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
 <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
 <08737c8d-9f1b-5f18-61a0-d3bb501eb950@fb.com>
 <9221d4d9-d114-4ffb-d2f8-6dc2d1cdb79c@suse.com>
 <57DF4E44.2040506@cn.fujitsu.com> <1474550402.3206.4.camel@gmail.com>
 <6ae8684e-a671-1f8d-9ad3-1299b442bd3c@gmail.com>
 <1474552982.3206.12.camel@gmail.com>
 <ea4797a6-87af-1b52-ccf0-4139186491b0@fb.com>
 <1474563967.3206.16.camel@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <949294ac-fe4a-10b1-70aa-e9a65530d0d5@fb.com>
Date: Thu, 22 Sep 2016 13:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <1474563967.3206.16.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2016 01:06 PM, Ronan Arraes Jardim Chagas wrote:
> Hi Josef,
>
> Em qui, 2016-09-22 às 10:39 -0400, Josef Bacik escreveu:
>> This is what fixed it.  I thought it was in 4.7 which is why I
>> started paying
>> attention, but I guess I was wrong.  Glad your problem is
>> resolved.  Thanks,
>
> Do you have any explanations why the problem solved by the patch was
> causing me the ENOSPC? Also, is it necessary to format my partition or
> should I consider it good for use after the installation of the new
> kernel?

That patch fixed a problem where we would screw up the ENOSPC accounting, and 
would slowly leak space into one of the counters.  So eventually (or often in 
your case) you'd hit ENOSPC, but have plenty of space available.  If you 
unmounted and mounted again, or simply rebooted, everything would have been 
fine.  You can still use the fs, the accounting is purely in memory so it's not 
like your FS is permanently screwed.  Thanks,

Josef

