Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37539 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbeA2PJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 10:09:08 -0500
Received: by mail-wm0-f41.google.com with SMTP id v71so34365032wmv.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 07:09:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com> <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com> <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com> <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com> <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com> <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com> <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
 <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com> <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
From: "^m'e" <marcoep@gmail.com>
Date: Mon, 29 Jan 2018 15:08:46 +0000
Message-ID: <CAAxOLF8f0RWtLQdsaMFYq=0q4yWZTo_d7zso9nBsVSp65Ekscg@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem check on my backup pool reports dozens of 'backref lost' on
extents... Excerpt:
----------------------------------------------------------
# ./btrfsck.static check --mode=lowmem /dev/sda1
checking extents
ERROR: data extent[33866182656 4096] backref lost
ERROR: data extent[37102219264 114688] backref lost
ERROR: data extent[37090353152 45056] backref lost
ERROR: data extent[37193342976 114688] backref lost
ERROR: data extent[50151686144 53248] backref lost
ERROR: data extent[49782943744 126976] backref lost
ERROR: data extent[49718861824 77824] backref lost
ERROR: data extent[33853538304 4096] backref lost
ERROR: data extent[41170333696 692224] backref lost
ERROR: data extent[37550239744 4096] backref lost
ERROR: data extent[33866182656 4096] backref lost
ERROR: data extent[37102219264 114688] backref lost
...

ERROR: data extent[37193342976 114688] backref lost
ERROR: data extent[50151686144 53248] backref lost
ERROR: data extent[49782943744 126976] backref lost
ERROR: data extent[49718861824 77824] backref lost
ERROR: data extent[33853538304 4096] backref lost
ERROR: data extent[41170333696 692224] backref lost
ERROR: data extent[37550239744 4096] backref lost
ERROR: data extent[44122832896 8192] backref lost
ERROR: data extent[45874237440 40960] backref lost
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
block group 112772251648 has wrong amount of free space
failed to load free space cache for block group 112772251648
Wanted offset 127268339712, found 127268323328
Wanted offset 127268339712, found 127268323328
cache appears valid but isn't 127267766272
block group 133173346304 has wrong amount of free space
failed to load free space cache for block group 133173346304
Wanted offset 142837039104, found 142837022720
Wanted offset 142837039104, found 142837022720
cache appears valid but isn't 142837022720
ERROR: errors found in free space cache
Checking filesystem on /dev/sda1
UUID: 854e1bf5-7a98-4bcb-b971-0d9f2ac9452a
found 200684883968 bytes used, error(s) found
total csum bytes: 186712500
total tree bytes: 40191000576
total fs tree bytes: 39574110208
total extent tree bytes: 359038976
btree space waste bytes: 7605597010
file data blocks allocated: 946099404800
 referenced 1091731312640
----------------------------------------------------------

Is that related to flawed snapshots of the ailing rootfs vol?
Is it safe to try to rollback from it?

Cheers,

  M.


On Mon, Jan 29, 2018 at 2:49 PM, ^m'e <marcoep@gmail.com> wrote:
> On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2018年01月29日 21:58, ^m'e wrote:
>>> Thanks for the advice, Qu!
>>>
>>> I used the system for a while, did some package upgrades -- writing in
>>> the suspect corrupted area. Then tried a btrfs-send to my backup vol,
>>> and it failed miserably with a nice kernel oops.
>>>
>>> So I went for a lowmem repair:
>>> ----------------------------------------------------------------------------------------
>>> # ./btrfsck.static check --repair --mode=lowmem /dev/sdb3 2>&1 | tee
>>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>>> WARNING: low-memory mode repair support is only partial
>>> Fixed 0 roots.
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> ERROR: failed to add inode 28891726 as orphan item root 257
>>> ERROR: root 257 INODE[28891726] is orphan item
>>
>> At least I need dig the kernel code further to determine if the orphan
>> inode handling in btrfs-progs is correct or not.
>>
>> So there won't be more dirty fix soon.
>>
>> Hopefully you could get some good backup and restore the system.
>>
>> At least the problem is limited to a very small range, and it's
>> something we could handle easily.
>>
>> Thanks for all your report,
>> Qu
>>
>>
>
> Right.
>
> Meanwhile, could you please suggest the best course of action? btrfs
> rescue or restore?
> I have snapshots of my two subvols (rootfs, home -- now fs-checking
> them  just in case...)
>
> Cheers,
>
>   Marco



-- 
^m'e
