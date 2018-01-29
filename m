Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:45948 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbeA2OuJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 09:50:09 -0500
Received: by mail-wr0-f178.google.com with SMTP id 16so7476765wry.12
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 06:50:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
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
 <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Mon, 29 Jan 2018 14:49:48 +0000
Message-ID: <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年01月29日 21:58, ^m'e wrote:
>> Thanks for the advice, Qu!
>>
>> I used the system for a while, did some package upgrades -- writing in
>> the suspect corrupted area. Then tried a btrfs-send to my backup vol,
>> and it failed miserably with a nice kernel oops.
>>
>> So I went for a lowmem repair:
>> ----------------------------------------------------------------------------------------
>> # ./btrfsck.static check --repair --mode=lowmem /dev/sdb3 2>&1 | tee
>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>> WARNING: low-memory mode repair support is only partial
>> Fixed 0 roots.
>> checking extents
>> checking free space cache
>> checking fs roots
>> ERROR: failed to add inode 28891726 as orphan item root 257
>> ERROR: root 257 INODE[28891726] is orphan item
>
> At least I need dig the kernel code further to determine if the orphan
> inode handling in btrfs-progs is correct or not.
>
> So there won't be more dirty fix soon.
>
> Hopefully you could get some good backup and restore the system.
>
> At least the problem is limited to a very small range, and it's
> something we could handle easily.
>
> Thanks for all your report,
> Qu
>
>

Right.

Meanwhile, could you please suggest the best course of action? btrfs
rescue or restore?
I have snapshots of my two subvols (rootfs, home -- now fs-checking
them  just in case...)

Cheers,

  Marco
