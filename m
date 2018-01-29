Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41634 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeA2SQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 13:16:22 -0500
Received: by mail-wr0-f193.google.com with SMTP id v15so8281801wrb.8
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 10:16:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com> <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com> <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com> <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com> <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com> <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com> <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
 <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com> <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
 <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Mon, 29 Jan 2018 18:16:00 +0000
Message-ID: <CAAxOLF_45qefY7d8zz3LzbPGXY_xt5D9YS5H6m1e0FcRE_iBMA@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks!

Got these

  # ./btrfs.static inspect dump-super -fFa /dev/sdb3 |grep
backup_tree_root: | sort -u
        backup_tree_root:    180410073088    gen: 463765    level: 1
        backup_tree_root:    180415758336    gen: 463766    level: 1
        backup_tree_root:    180416364544    gen: 463767    level: 1
        backup_tree_root:    4194304    gen: 463764    level: 1

but, nada: all have transid failures...

The backup snapshots are OK as per original check.


On Mon, Jan 29, 2018 at 3:09 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年01月29日 22:49, ^m'e wrote:
>> On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2018年01月29日 21:58, ^m'e wrote:
>>>> Thanks for the advice, Qu!
>>>>
>>>> I used the system for a while, did some package upgrades -- writing in
>>>> the suspect corrupted area. Then tried a btrfs-send to my backup vol,
>>>> and it failed miserably with a nice kernel oops.
>>>>
>>>> So I went for a lowmem repair:
>>>> ----------------------------------------------------------------------------------------
>>>> # ./btrfsck.static check --repair --mode=lowmem /dev/sdb3 2>&1 | tee
>>>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>>>> WARNING: low-memory mode repair support is only partial
>>>> Fixed 0 roots.
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>>> ERROR: failed to add inode 28891726 as orphan item root 257
>>>> ERROR: root 257 INODE[28891726] is orphan item
>>>
>>> At least I need dig the kernel code further to determine if the orphan
>>> inode handling in btrfs-progs is correct or not.
>>>
>>> So there won't be more dirty fix soon.
>>>
>>> Hopefully you could get some good backup and restore the system.
>>>
>>> At least the problem is limited to a very small range, and it's
>>> something we could handle easily.
>>>
>>> Thanks for all your report,
>>> Qu
>>>
>>>
>>
>> Right.
>>
>> Meanwhile, could you please suggest the best course of action? btrfs
>> rescue or restore?
>> I have snapshots of my two subvols (rootfs, home -- now fs-checking
>> them  just in case...)
>
> Don't run --repair any more.
> It seems to make the case worse.
>
> While the RW mount with orphan cleanup abort seems to screwed up the
> filesystem.
>
> In this case, it's pretty hard to recover, but still has small chance.
>
> Use btrfs inspec dump-super to get backup roots:
>
> # btrfs inspect dump-super -fFa <device> |grep backup_tree_root: | sort
> | uniq
>
> And try all the 4 numbers in the following commands:
>
> # btrfs check --tree-root <number> <device>
>
> To see if is there any good one without transid error.
>
> Thanks,
> Qu
>
>>
>> Cheers,
>>
>>   Marco
>>
>



-- 
^m'e
