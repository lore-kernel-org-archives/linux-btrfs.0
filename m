Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0053.outbound.protection.outlook.com ([104.47.42.53]:10240
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751797AbeBWQ3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 11:29:51 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
 <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
 <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <98d70452-a643-b0e6-5372-c524b9bf2ff0@panasas.com>
Date: Fri, 23 Feb 2018 11:29:42 -0500
MIME-Version: 1.0
In-Reply-To: <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/2018 06:37 PM, Qu Wenruo wrote:
> On 2018年02月23日 00:31, Ellis H. Wilson III wrote:
>> On 02/21/2018 11:56 PM, Qu Wenruo wrote:
>>> On 2018年02月22日 12:52, Qu Wenruo wrote:
>>>> btrfs_read_block_groups() is used to build up the block group cache for
>>>> all block groups, so it will iterate all block group items in extent
>>>> tree.
>>>>
>>>> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
>>>> thousands times, which is the most time consuming part of mounting
>>>> btrfs.
>>>>
>>>> So this patch will try to speed it up by:
>>>>
>>>> 1) Avoid unnecessary readahead
>>>>      We were using READA_FORWARD to search for block group item.
>>>>      However block group items are in fact scattered across quite a
>>>> lot of
>>>>      leaves. Doing readahead will just waste our IO (especially important
>>>>      for HDD).
>>>>
>>>>      In real world case, for a filesystem with 3T used space, it would
>>>>      have about 50K extent tree leaves, but only have 3K block group
>>>>      items. Meaning we need to iterate 16 leaves to meet one block group
>>>>      on average.
>>>>
>>>>      So readahead won't help but waste slow HDD seeks.
>>>>
>>>> 2) Use chunk mapping to locate block group items
>>>>      Since one block group item always has one corresponding chunk item,
>>>>      we could use chunk mapping to get the block group item size.
>>>>
>>>>      With block group item size, we can do a pinpoint tree search,
>>>> instead
>>>>      of searching with some uncertain value and do forward search.
>>>>
>>>>      In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>>>>      current path, we could save such unnecessary tree block read.
>>>>
>>>> Cc: Ellis H. Wilson III <ellisw@panasas.com>
>>>
>>> Hi Ellis,
>>>
>>> Would you please try this patch to see if it helps to speedup the mount
>>> of your large filesystem?
>>
>> I will try either tomorrow or over the weekend.  I'm waiting on hardware
>> to be able to build and load a custom kernel on.
> 
> If you're using Archlinux, I could build the package for you.
> 
> (For other distributions, unfortunately I'm not that familiar with)
> 
> Thanks,
> Qu

No sweat.  I'm not running arch anywhere, so was glad to handle this myself.

Short story: It doesn't appear to have any notable impact on mount time.

Long story:
#Built a modern kernel:
git clone https://github.com/kdave/btrfs-devel
cd'd into btrfs-devel
copied my current kernel config in /boot to .config
make olddefconfig
make -j16
make modules_install
make install
grub2-mkconfig -o /boot/grub/grub.cfg
reboot

#Reran tests with vanilla 4.16.0-rc1+ kernel
As root, of the form: time mount /dev/sdb /mnt/btrfs
5 iteration average: 16.869s

#Applied your patch, rebuild, switched kernel module
wget -O - 'https://patchwork.kernel.org/patch/10234619/mbox' | git am -
make -j16
make modules_install
rmmod btrfs
modprobe btrfs

#Reran tests with patched 4.16.0-rc1+ kernel
As root, of the form: time mount /dev/sdb /mnt/btrfs
5 iteration average: 16.642s

So, there's a slight improvement against vanilla 4.16.0-rc1+, but it's 
still slightly slower than my original runs in 4.5.5, which got me 
16.553s.  In any event, most of this is statistically unsignificant 
since the standard deviation is about two tenths of a second.

So, my conclusion here is this problem needs to be handled at an 
architectural level to be truly solved (read: have mounts that few 
seconds at worst), which either requires:
a) On-disk format changes like you (Qu) suggested some time back for a 
tree of block groups or
b) Lazy block group walking post-mount and algorithms that can cope with 
making sub-optimal choices.  One would likely want to stonewall out 
certain operations until the lazy post-mount walk completed like 
balance, defrag, etc, that have more reason to require complete 
knowledge of the usage of each block group.

I may take a stab at b), but I'm first going to do the tests I promised 
relating to how mount times scale with increased capacity consumption 
for varying filesizes.

Best,

ellis
