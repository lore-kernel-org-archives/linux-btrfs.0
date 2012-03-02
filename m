From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Fri, 2 Mar 2012 12:28:19 +0900
Message-ID: <4F503E53.6070309@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F471E80.2040809@parallels.com> <4F4B8B02.9080303@parallels.com> <CAAE6i0hmL5ZRaGYhWptt4qDvKz1SF=6L=Q_MF4Uow5txavTa1g@mail.gmail.com> <4F4C251E.7040601@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4C251E.7040601@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/28/2012 09:51 AM, dima wrote:
> On 02/28/2012 07:10 AM, Chester wrote:
>> On Mon, Feb 27, 2012 at 7:54 AM, dima<dolenin@parallels.com> wrote:
>>> Hello,
>>>
>>> Since several people asked to post the results, here they are.
>>> I tried raw virtio disk with and without -z -C set and also qcow2 virtio
>>> disk without -z -C set and did not notice any difference in
>>> performance at
>>> all - Redhat 6.2 Minimal installs in 10 minutes in each case. The
>>> "abysmal"
>>> performance as it was some several months ago (like 10 minutes just for
>>> virtual disk formatting) under the same conditions is no more at
>>> least on
>>> 3.3.0-rc5.
>>
>> Just to make sure, this is a _new_ virtual disk right? I can barely
>> contain my excitement right now. This is amazing progress.
>
> Yes, it is a newly created virtual disk. By the way, one thing that
> slipped out from my message - in case of raw I did pre-allocation of the
> entire image, but in case of qcow2 I unchecked this box in virt-manager
> and the disk was "growing" as the system was installing. Nevertheless I
> did not notice performance degradation during the install.


But still Virtualbox is faster. It installs Redhat 6 Minimal in just 
about 5 minutes. I observe that yum installations work faster.
WindowsXP install under KVM was a hell lasting for about 3 hours and the 
performance is awful with host HD indicator flashing all the time. There 
was no change whatsoever whether the image was with +C +z or not.
On Virtualbox WinXP install completed in about 25 minutes and the 
performance is excellent even w/o guest additions applied.
I wonder why such a big difference.
