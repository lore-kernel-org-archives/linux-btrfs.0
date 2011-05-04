From: Gregory L Shomo <greg@techsquare.com>
Subject: Re: parent transid troubles
Date: Wed, 04 May 2011 14:04:51 -0400
Message-ID: <sa239ku8hq4.fsf@techsquare.com>
References: <1303332799-sup-9175@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303332799-sup-9175@think> (message from Chris Mason on Wed, 20 Apr 2011 16:54:23 -0400)
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

>> Mounting the filesystem read-only from /dev/sdd1 fails, but
>> succeeds from /dev/sdc1... after about 4855 parent transid 
>> verification failures. 
>> 
>>   kernel: [  293.827069] Btrfs loaded
>>   kernel: [  293.828014] device fsid 2e4187db574846d8-404f05c2e6ec579d devid 2 transid 176065 /dev/sdd1
>>   kernel: [  293.828781] btrfs: failed to read the system array on sdd1
>>   kernel: [  293.835956] btrfs: open_ctree failed 
>> 
>>   kernel: [  305.296345] device fsid 2e4187db574846d8-404f05c2e6ec579d devid 1 transid 176066 /dev/sdc1
>>   kernel: [  305.476360] parent transid verify failed on 20403515125760 wanted 176066 found 174710
>>   kernel: [  305.476608] parent transid verify failed on 20403515125760 wanted 176066 found 174710
>>   !-- snip
>> 
>> Is there any chance we can resolve some of the parent transid 
>> verification failures ? What should our next steps be ? 
>> 
>> Thank you very much for all your help. 
>
> The failures won't get resolved easily.  Many of them will be duplicates
> because of the way we do readahead.
>
> Step one is to copy off the data that you can.  dmesg -n 1 will help
> prevent performance problems from message floods.
>
> -chris

So we've copied off all the data, what's the next step ? 

Losing all files that were open for writing at the time 
of the failure is no problem, as those data sets will have
to be re-computed anywise. Does that work in our favour
to resolve this issue ? 

- greg 


