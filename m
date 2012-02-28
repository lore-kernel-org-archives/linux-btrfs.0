From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Tue, 28 Feb 2012 09:51:42 +0900
Message-ID: <4F4C251E.7040601@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F471E80.2040809@parallels.com> <4F4B8B02.9080303@parallels.com> <CAAE6i0hmL5ZRaGYhWptt4qDvKz1SF=6L=Q_MF4Uow5txavTa1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0hmL5ZRaGYhWptt4qDvKz1SF=6L=Q_MF4Uow5txavTa1g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/28/2012 07:10 AM, Chester wrote:
> On Mon, Feb 27, 2012 at 7:54 AM, dima<dolenin@parallels.com>  wrote:
>> Hello,
>>
>> Since several people asked to post the results, here they are.
>> I tried raw virtio disk with and without -z -C set and also qcow2 virtio
>> disk without -z -C set and did not notice any difference in performance at
>> all - Redhat 6.2 Minimal installs in 10 minutes in each case. The "abysmal"
>> performance as it was some several months ago (like 10 minutes just for
>> virtual disk formatting) under the same conditions is no more at least on
>> 3.3.0-rc5.
>
> Just to make sure, this is a _new_ virtual disk right? I can barely
> contain my excitement right now. This is amazing progress.

Yes, it is a newly created virtual disk. By the way, one thing that 
slipped out from my message - in case of raw I did pre-allocation of the 
entire image, but in case of qcow2 I unchecked this box in virt-manager 
and the disk was "growing" as the system was installing. Nevertheless I 
did not notice performance degradation during the install.

best
~dima
