Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751923AbdHBSsK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 14:48:10 -0400
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Roman Mamedov <rm@romanrm.net>, Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801222547.35d1bd03@natsu>
 <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <5800c104-5b03-8d48-bb49-b1710be05cd0@fb.com>
Date: Wed, 2 Aug 2017 14:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/01/2017 01:39 PM, Austin S. Hemmelgarn wrote:
> On 2017-08-01 13:25, Roman Mamedov wrote:
>> On Tue,  1 Aug 2017 10:14:23 -0600
>> Liu Bo <bo.li.liu@oracle.com> wrote:
>>
>>> This aims to fix write hole issue on btrfs raid5/6 setup by adding a
>>> separate disk as a journal (aka raid5/6 log), so that after unclean
>>> shutdown we can make sure data and parity are consistent on the raid
>>> array by replaying the journal.
>>
>> Could it be possible to designate areas on the in-array devices to be 
>> used as
>> journal?
>>
>> While md doesn't have much spare room in its metadata for extraneous 
>> things
>> like this, Btrfs could use almost as much as it wants to, adding to 
>> size of the
>> FS metadata areas. Reliability-wise, the log could be stored as RAID1 
>> chunks.
>>
>> It doesn't seem convenient to need having an additional storage device 
>> around
>> just for the log, and also needing to maintain its fault tolerance 
>> yourself (so
>> the log device would better be on a mirror, such as mdadm RAID1? more 
>> expense
>> and maintenance complexity).
>>
> I agree, MD pretty much needs a separate device simply because they 
> can't allocate arbitrary space on the other array members.  BTRFS can do 
> that though, and I would actually think that that would be _easier_ to 
> implement than having a separate device.
> 
> That said, I do think that it would need to be a separate chunk type, 
> because things could get really complicated if the metadata is itself 
> using a parity raid profile.

Thanks for running with this Liu, I'm reading through all the patches. 
I do agree that it's better to put the logging into a dedicated chunk 
type, that way we can have it default to either double or triple mirroring.

-chris

