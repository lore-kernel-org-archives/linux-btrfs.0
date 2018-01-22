Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46901 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750886AbeAVMU1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 07:20:27 -0500
Subject: Re: [PATCH] btrfs: remove spurious WARN_ON(ref->count) in
 find_parent_nodes
To: Nikolay Borisov <nborisov@suse.com>, <enadolski@suse.com>
CC: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        <linux-btrfs@vger.kernel.org>
References: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
 <20180122033452.GA532@fnst.localdomain>
 <9151459e-8db2-bdd1-a21e-23d730cb52a4@suse.com>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <87ed4d9c-9af4-4425-5a35-b0ccd9305e76@cn.fujitsu.com>
Date: Mon, 22 Jan 2018 20:19:28 +0800
MIME-Version: 1.0
In-Reply-To: <9151459e-8db2-bdd1-a21e-23d730cb52a4@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/22/2018 04:46 PM, Nikolay Borisov wrote:
> 
> 
> On 22.01.2018 05:34, Lu Fengqi wrote:
>> According to my bisect result, The frequency of the warning occurrence
>> increased to the detectable degree after this patch
> 
> That sentence implies that even before Ed's patch it was possible to
> trigger those warnings, is that true? Personally I've never seen such
> warnings while executing btrfs/004. How do you configure the filesystem
> for the test runs?
> 

Just only default mount option.

➜  xfstests-dev git:(master) for i in $(seq 1 100); do echo $i; if ! 
sudo ./check btrfs/004; then break; fi; done 

1 
 

FSTYP         -- btrfs 
 

PLATFORM      -- Linux/x86_64 sarch 4.15.0-rc9 
 

MKFS_OPTIONS  -- /dev/vdd1 
 

MOUNT_OPTIONS -- /dev/vdd1 /mnt/scratch 
 

 
 

btrfs/004 47s ... 49s 
 

Ran: btrfs/004 
 

Passed all 1 tests 
 

 
 

2 
 

FSTYP         -- btrfs 
 

PLATFORM      -- Linux/x86_64 sarch 4.15.0-rc9 
 

MKFS_OPTIONS  -- /dev/vdd1 
 

MOUNT_OPTIONS -- /dev/vdd1 /mnt/scratch 
 

 
 

btrfs/004 49s ... 52s 
 

_check_dmesg: something found in dmesg (see 
/home/luke/workspace/xfstests-dev/results//btrfs/004.dmesg) 
 

Ran: btrfs/004 
 

Failures: btrfs/004 
 

Failed 1 of 1 tests

The probability of this warning appearing is rather low, and I only 
encountered 52 warnings when I looped 1008 times btrfs/004 for 20 hours 
in 4.15-rc6 (IOW, the probability is nearly 5%). So you want to trigger 
warning also need more luck or patience.

>> 86d5f9944252 ("btrfs: convert prelimary reference tracking to use rbtrees")
>> is committed. I understand that this does not mean that this patch caused
>> the problem, but maybe Edmund can give us some help, so I added him to the
>> recipient.
> 
> 


-- 
Thanks,
Lu


