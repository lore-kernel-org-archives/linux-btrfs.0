From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:03:32 -0400
Message-ID: <48FF24A4.4040108@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	<87vdvmdu36.fsf@basil.nowhere.org>	<20081021162249.30a25bcb.skraw@ithnet.com>	<48FDF67C.6080205@hp.com> <20081022133615.68b66b0e.skraw@ithnet.com> <48FF1976.1050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF1976.1050202@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity wrote:
> Stephan von Krawczynski wrote:
>>
>>>    - filesystem autodetects, isolates, and (possibly) repairs errors
>>>    - online "scan, check, repair filesystem" tool initiated by admin
>>>    - Reliability so high that they never run that check-and-fix tool
>>>     
>>
>> That is _wrong_ (to a certain extent). You _want to run_ diagnostic 
>> tools to
>> make sure that there is no problem. And you don't want some software 
>> (not even
>> HAL) to repair errors without prior admin knowledge/permission
>
> I think there's a place for a scrubber to continuously verify 
> filesystem data and metadata, at low io priority, and correct any 
> correctable errors.  The admin can read the error correction report at 
> their leisure, and then take any action that's outside the 
> filesystem's capabilities (like ordering and installing new disks).
>
Scrubbing is key for many scenarios since errors can "grow" even in 
places where previous IO has been completed without flagging an error.

Some neat tricks are:

    (1) use block level scrubbing to detect any media errors. If you can 
map that sector level error into a file system object (meta data, file 
data or unallocated space), tools can recover (fsck, get another copy of 
the file or just ignore it!). There is a special command called 
"READ_VERIFY" that can be used to validate the sectors without actually 
moving data from the target to the host, so you can scrub without 
consuming page cache, etc.

    (2) sign and validate the object at the file level, say by 
validating a digital signature. This can catch high level errors (say 
the app messed up).

Note that this scrubbing needs to be carefully tuned to not interfere 
with the foreground workload, using something like IO nice or the other 
IO controllers being kicked about might help :-)

ric

