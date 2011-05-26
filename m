From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't commit the transaction if we dont have enough
 pinned bytes V2
Date: Thu, 26 May 2011 09:25:57 -0400
Message-ID: <4DDE54E5.3020606@redhat.com>
References: <1306343490-26057-1-git-send-email-josef@redhat.com> <1306351800-3694-1-git-send-email-josef@redhat.com> <4DDE160A.9060803@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Adrian Hunter <adrian.hunter@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDE160A.9060803@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2011 04:57 AM, Adrian Hunter wrote:
> On 25/05/11 22:30, Josef Bacik wrote:
>> I noticed when running an enospc test that we would get stuck
>> committing the
>> transaction in check_data_space even though we truly didn't have
>> enough space.
>> So check to see if bytes_pinned is bigger than num_bytes, if it's not
>> don't
>> commit the transaction.  Thanks,
>>
>> Signed-off-by: Josef Bacik<josef@redhat.com>
>> ---
>> V1->V2: Make it so it actually compiles ;)
>>   fs/btrfs/extent-tree.c |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index c8c3184..b4f67e8 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3199,6 +3199,13 @@ alloc:
>>               }
>>               goto again;
>>           }
>> +
>> +        /*
>> +         * If we have less pinned bytes than we want to allocate then
>> +         * don't bother committing the transaction, it won't help us.
>> +         */
>> +        if (data_sinfo->bytes_pinned<  bytes)
>> +            committed = 1;
>>           spin_unlock(&data_sinfo->lock);
>>
>>           /* commit the current transaction and try again */
> 
> I tried that patch on 2.6.39 with the following:
> 
> sudo modprobe brd rd_size=262144
> sudo mkfs.btrfs /dev/ram0
> sudo mkdir -p /mnt/test
> sudo mount -t btrfs /dev/ram0 /mnt/test
> sudo mkdir -p /mnt/test/test
> sudo chown $USER /mnt/test/test
> sudo chgrp $USER /mnt/test/test
> sudo umount /mnt/test
> i=0
> while true; do
>     sudo mount -t btrfs /dev/ram0 /mnt/test
>     fsstress -c -r -d /mnt/test/test -p 3 -n 1000 -l 10
>     sudo umount /mnt/test
>     i=`expr $i \+ 1`
>     echo $i
> done
> 
> 
> After 3 iterations it got really slow and then after some minutes it
> still seems to lock up:
> 

Did you run without my patch?  I assume this will still happen even
without my patch.  The only possible negative side-effect of my patch is
we could ENOSPC early.  Thanks,

Josef
