Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeCPQUV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:20:21 -0400
Subject: Re: [PATCH 4.14 024/110] btrfs: use proper endianness accessors for
 super_copy
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dsterba@suse.cz,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        David Sterba <dsterba@suse.com>
References: <20180307191039.748351103@linuxfoundation.org>
 <20180307191042.810088712@linuxfoundation.org>
 <1521139304@msgid.manchmal.in-ulm.de> <20180316123049.GC25079@kroah.com>
 <20180316132202.GB8297@twin.jikos.cz> <20180316140256.GA9735@kroah.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8ebec52c-0953-aa6c-3e77-876097aaa353@oracle.com>
Date: Sat, 17 Mar 2018 00:21:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180316140256.GA9735@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/16/2018 10:02 PM, Greg Kroah-Hartman wrote:
> On Fri, Mar 16, 2018 at 02:22:02PM +0100, David Sterba wrote:
>> On Fri, Mar 16, 2018 at 01:30:49PM +0100, Greg Kroah-Hartman wrote:
>>> On Thu, Mar 15, 2018 at 07:55:42PM +0100, Christoph Biedl wrote:
>>>> Greg Kroah-Hartman wrote...
>>>>
>>>>> 4.14-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>>> commit 3c181c12c431fe33b669410d663beb9cceefcd1b upstream.
>>>> (...)
>>>>
>>>>> If the filesystem is always used on a same endian host, this will not
>>>>> be a problem.
>>>>
>>>> >From my observations I cannot quite subscribe to that.
>>>>
>>>> On big-endian systems, this change intruduces severe corruption,
>>>> resulting in complete loss of the data on the used block device.
>>>>
>>>> Steps to reproduce (tested on ppc/powerpc and parisc/hppa):
>>>>
>>>> # mkfs.btrfs $DEV
>>>> # mount $DEV /mnt/tmp/
>>>> # umount /mnt/tmp/
>>>>
>>>> This simple umount corrupts the file system:
>>>>
>>>> # mount $DEV /mnt/tmp/
>>>> mount: /mnt/tmp: wrong fs type, bad option, bad superblock on $DEV, missing codepage or helper program, or other error.
>>>>
>>>> # dmesg:
>>>> BTRFS critical (device <dev>): unable to find logical 4294967296 length 4096
>>>> BTRFS critical (device <dev>): unable to find logical 4294967296 length 4096
>>>> BTRFS critical (device <dev>): unable to find logical 18102363734671360 length 16384
>>>> BTRFS error (device <dev>): failed to read chunk root
>>>> BTRFS error (device <dev>): open_ctree failed
>>>>
>>>> Also fsck is of no help:
>>>>
>>>> # btrfsck $DEV
>>>> Couldn't map the block 18102363734671360
>>>> No mapping for 18102363734671360-18102363734687744
>>>> Couldn't map the block 18102363734671360
>>>> bytenr mismatch, want=18102363734671360, have=0
>>>> ERROR: cannot read chunk root
>>>> ERROR: cannot open file system
>>>>
>>>>
>>>> Trying mount or fsck on a little-endian system does not help either. So
>>>> I consider the data on that device lost - luckily I use btrfs only for
>>>> files where a backup exists all the time.
>>>>
>>>>
>>>> Reverting that change restored the previous error-free behaviour. I
>>>> didn't check HEAD, i.e. v4.16-rc5, since the upstream commt was the last
>>>> that affected these files. Still I could give this a try if anybody
>>>> wishes so.
>>>
>>> That sucks.  Can you test Linus's tree to verify the problem is there?
>>> I'll gladly revert this if Linus's tree also gets the revert, I don't
>>> want you to hit this when you upgrade to a newer kernel.
>>
>> I'll push a fix for the upcoming rc but I think it would be better to
>> remove the broken patch from stable kernels ASAP, so I'd recommend to
>> revert it now.
> 
> Now reverted, thanks.

  Thanks ! Sorry for the mess.

-Anand

> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
