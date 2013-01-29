Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:38594 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3A2UiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 15:38:16 -0500
Message-ID: <5108331A.2090705@sandia.gov>
Date: Tue, 29 Jan 2013 13:37:46 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <510817C6.5070007@sandia.gov>
 <20130129200415.GE3660@localhost.localdomain>
In-Reply-To: <20130129200415.GE3660@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/29/2013 01:04 PM, Josef Bacik wrote:
> On Tue, Jan 29, 2013 at 11:41:10AM -0700, Jim Schutt wrote:
>> On 01/28/2013 02:23 PM, Josef Bacik wrote:
>>> On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
>>>> Hi Josef,
>>>>
>>>> Thanks for the patch - sorry for the long delay in testing...
>>>>
>>>
>>> Jim,
>>>
>>> I've been trying to reason out how this happens, could you do a btrfs fi df on
>>> the filesystem thats giving you trouble so I can see if what I think is
>>> happening is what's actually happening.  Thanks,
>>
>> Here's an example, using a slightly different kernel than
>> my previous report.  It's your btrfs-next master branch
>> (commit 8f139e59d5 "Btrfs: use bit operation for ->fs_state")
>> with ceph 3.8 for-linus (commit 0fa6ebc600 from linus' tree).
>>
>>
>> Here I'm finding the file system in question:
>>
>> # ls -l /dev/mapper | grep dm-93
>> lrwxrwxrwx 1 root root       8 Jan 29 11:13 cs53s19p2 -> ../dm-93
>>
>> # df -h | grep -A 1 cs53s19p2
>> /dev/mapper/cs53s19p2
>>                       896G  1.1G  896G   1% /ram/mnt/ceph/data.osd.522
>>
>>
>> Here's the info you asked for:
>>
>> # btrfs fi df /ram/mnt/ceph/data.osd.522
>> Data: total=2.01GB, used=1.00GB
>> System: total=4.00MB, used=64.00KB
>> Metadata: total=8.00MB, used=7.56MB
>>
> 
> How big is the disk you are using, and what mount options? 

The partition is ~900 GiB, and the mount options according
to /proc/mount are: rw,noatime,nospace_cache

Also, in case it matters, I build the file systems
with -l 65536 -n 65536.

> I have a patch to
> keep the panic from happening and hopefully the abort, could you try this?  I
> still want to keep the underlying error from happening because it shouldn't be,
> but no reason I can't fix the error case while you can easily reproduce it :).

I'm happy to try it - but I probably won't have results
for you until tomorrow, due to other time pressures.

Thanks for taking a look.

-- Jim

> Thanks,
> 
> Josef
> 

