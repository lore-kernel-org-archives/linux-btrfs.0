From: Josef Bacik <josef@redhat.com>
Subject: Re: 2.6.29-rc2 oops and assertion failure...
Date: Fri, 08 Apr 2011 09:37:02 -0400
Message-ID: <4D9F0F7E.3040509@redhat.com>
References: <BANLkTikJJFqEs0F_wPdTinct0k_4uLh1hQ@mail.gmail.com>	<4D9DE4F2.1050909@redhat.com> <BANLkTinm0eNdDWH42MB6VnYAdOOGi0P-bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinm0eNdDWH42MB6VnYAdOOGi0P-bw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2011 10:26 PM, Daniel J Blueman wrote:
> Hi Josef, Chris,
>
> On 8 April 2011 00:23, Josef Bacik<josef@redhat.com>  wrote:
>> On 04/07/2011 03:21 AM, Daniel J Blueman wrote:
>>>
>>> When running a practical stress-test on 2.6.29-rc2 trying to reproduce
>>> an older (extent refcounting) issue, I am consistently able to hit an
>>> oops [] and an assertion failure [].
>>
>> Sorry about that, please apply the patch I just sent this morning
>>
>> [PATCH] Btrfs: deal with the case that we run out of space in the cache
>
> Superb work - the btrfs_write_out_cache oops is addressed, so now we
> (separately) hit a few other assertions at: volumes.c:2013 [1],
> volumes.c:2063 [2] and volumes.c:2703 [3] with the previous
> reproducer.
>
> Let me know if adding any debugging or other testing may be useful.
>
> Thanks,
>    Daniel

Looks like the first 2 panics are basically the same thing.  You are 
getting -EIO back from btrfs_shrink_device(), which could either come 
from searching or it could come from the stuff in relocation.c.  So will 
you put printk's at the 2 places in relocation.c where we return -EIO 
and figure out which one is getting tripped?  Once we know who is 
returning EIO we can go from there.  As for the last one, that's just a 
normal ENOSPC, but it's because we're allocating a chunk in the 
submission path, so that's going to be a little trickier to deal with. 
Lets fix these first two panics first and then hopefully that last one 
will just go away :).  Thanks,

Josef
