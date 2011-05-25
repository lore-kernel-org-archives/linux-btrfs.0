From: Gregory L Shomo <greg@techsquare.com>
Subject: Re: parent transid troubles
Date: Wed, 25 May 2011 14:03:01 -0400
Message-ID: <sa24o4iejze.fsf@techsquare.com>
References: <1303332799-sup-9175@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303332799-sup-9175@think> (message from Chris Mason on Wed, 20 Apr 2011 16:54:23 -0400)
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

>> OK, we've re-compiled linux-2.6.38 patched up to btrfs-unstable
>> commit f65647c29b14f5a32ff6f3237b0ef3b375ed5a79 and can now mount 
>> the filesystem. 
>> 
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

Now that we've copied-off what we need, shall we just
take the plunge and mount read-write ? Is there some
way in can clear out the parent transid failures so that
we will not have to look at them in the future ? 

- greg 


