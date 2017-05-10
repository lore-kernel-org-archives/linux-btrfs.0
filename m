Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:59437 "EHLO
        smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751638AbdEJHYP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 03:24:15 -0400
Received: from smtp15.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp15.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 8B13B5396
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 03:24:04 -0400 (EDT)
Received: by smtp15.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 3D82D526B
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 03:24:04 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 8EDDB8617
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 07:24:01 +0000 (UTC)
Subject: Re: runtime btrfsck
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <50233481-757c-62f3-602d-1b3b2a9c630c@rqc.ru>
Date: Wed, 10 May 2017 10:24:01 +0300
MIME-Version: 1.0
In-Reply-To: <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

(Warning: I'm a user, not a developer here.)

In my experience (on kernel 4.4) it processed larger and slower devices 
within a day, BUT according to some recent topics the runaway 
fragmentation (meaning in this case large number of small extents 
regardless of their relative location) can significantly slow down BTRFS 
operations to the point of making them infeasible. Possible reasons for 
fragmentations are snapshotting volumes too often and/or running VM 
images from BTRFS without taking some precautions.

On top of this, mount device name makes one suspicious there's another 
layer between BTRFS and hardware. Are you sure it's not the bottleneck 
in this case?

--

With Best Regards,
Marat Khalili

On 10/05/17 10:02, Stefan Priebe - Profihost AG wrote:
> I'm now trying btrfs progs 4.10.2. Is anybody out there who can tell me
> something about the expected runtime or how to fix bad key ordering?
>
> Greets,
> Stefan
>
> Am 06.05.2017 um 07:56 schrieb Stefan Priebe - Profihost AG:
>> It's still running. Is this the normal behaviour? Is there any other way
>> to fix the bad key ordering?
>>
>> Greets,
>> Stefan
>>
>> Am 02.05.2017 um 08:29 schrieb Stefan Priebe - Profihost AG:
>>> Hello list,
>>>
>>> i wanted to check an fs cause it has bad key ordering.
>>>
>>> But btrfscheck is now running since 7 days. Current output:
>>> # btrfsck -p --repair /dev/mapper/crypt_md0
>>> enabling repair mode
>>> Checking filesystem on /dev/mapper/crypt_md0
>>> UUID: 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
>>> bad key ordering 39 40
>>> checking extents [O]
>>>
>>> FS is a 12TB BTRFS Raid 0 over 3 mdadm Raid 5 devices. How long should
>>> btrfsck run and is there any way to speed it up? btrfs tools is 4.8.5
>>>
>>> Thanks!
>>>
>>> Greets,
>>> Stefan
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

