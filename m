Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36002 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbdBGTzQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 14:55:16 -0500
Received: by mail-it0-f67.google.com with SMTP id f200so13464396itf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 11:54:21 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
 <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fb3187d8-16f5-9a84-d0ce-d048f1ac5cc7@gmail.com>
Date: Tue, 7 Feb 2017 14:54:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 13:59, Peter Zaitsev wrote:
> Jeff,
>
> Thank you very much for explanations. Indeed it was not clear in the
> documentation - I read it simply as "if you have snapshots enabled
> nodatacow makes no difference"
>
> I will rebuild the database in this mode from scratch and see how
> performance changes.
>
> So far the most frustating for me was periodic stalls for many seconds
>  (running sysbench workload).  What was the most puzzling  I get this
> even if I run workload at the  50% or less of the full load  -  Ie
> database can handle 1000 transactions/sec and I only inject 500/sec
> and I still have those stalls.
>
> This is where it looks to me like some work is being delayed and when
> it requires stall for a few seconds to catch up.    I wonder  if there
> are some configuration options available to play with.
>
> So far I found BTRFS rather  "zero configuration" which is great if it
> works but it is also great to have more levers to pull if you're
> having some troubles.
It's worth keeping in mind that there is more to the storage stack than 
just the filesystem, and BTRFS tends to be more sensitive to the 
behavior of other components in the stack than most other filesystems 
are.  The stalls you're describing sound more like a symptom of the 
brain-dead writeback buffering defaults used by the VFS layer than they 
do an issue with BTRFS (although BTRFS tends to be a  bit more heavily 
impacted by this than most other filesystems).  Try fiddling with the 
/proc/sys/vm/dirty_* sysctls (there is some pretty good documentation in 
Documentation/sysctl/vm.txt in the kernel source) and see if that helps. 
  The default values it uses are at most 20% of RAM, which is an insane 
amount of data to buffer before starting writeback when you're talking 
about systems with 16GB of RAM.
>
>
> On Tue, Feb 7, 2017 at 1:27 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 2/7/17 8:53 AM, Peter Zaitsev wrote:
>>> Hi,
>>>
>>> I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MySQL
>>> Workload.
>>>
>>> It did not go very well ranging from multi-seconds stalls where no
>>> transactions are completed to the finally kernel OOPS with "no space left
>>> on device" error message and filesystem going read only.
>>>
>>> I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.
>>>
>>> Do you have any advice on how BTRFS should be tuned for OLTP workload
>>> (large files having a lot of random writes)  ?    Or is this the case where
>>> one should simply stay away from BTRFS and use something else ?
>>>
>>> One item recommended in some places is "nodatacow"  this however defeats
>>> the main purpose I'm looking at BTRFS -  I am interested in "free"
>>> snapshots which look very attractive to use for database recovery scenarios
>>> allow instant rollback to the previous state.
>>>
>>
>> Hi Peter -
>>
>> There seems to be some misunderstanding around how nodatacow works.
>> Nodatacow doesn't prohibit snapshot use.  Snapshots are still allowed
>> and, of course, will cause CoW to happen when a write occurs, but only
>> on the first write.  Subsequent writes will not CoW again.  This does
>> mean you don't get CRC protection for data, though.  Since most
>> databases do this internally, that is probably no great loss.  You will
>> get fragmentation, but that's true of any random-write workload on btrfs.
>>
>> Timothy's comment about how extents are accounted is more-or-less
>> correct.  The file extents in the file system trees reference data
>> extents in the extent tree.  When portions of the data extent are
>> unreferenced, they're not necessarily released.  A balance operation
>> will usually split the data extents so that the unused space is released.
>>
>> As for the Oopses with ENOSPC, that's something we'd want to look into
>> if it can be reproduced with a more recent kernel.  We shouldn't be
>> getting ENOSPC anywhere sensitive anymore.
>>
>> -Jeff
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>>
>
>
>

