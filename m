Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35447 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752374AbdK2T3b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 14:29:31 -0500
Received: by mail-lf0-f66.google.com with SMTP id j124so5199814lfg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 11:29:30 -0800 (PST)
Subject: Re: Read before you deploy btrfs + zstd
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        Nick Terrell <terrelln@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com> <20171121162239.GO3553@suse.cz>
 <5BB834FC-A54C-4448-8D86-1D2F22806096@fb.com> <20171128234937.GG3553@suse.cz>
 <7736f752-5c07-fffd-652d-1aaa8a3193b0@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ca0964d0-66f4-45e3-cdbe-410c9707d7ee@gmail.com>
Date: Wed, 29 Nov 2017 22:29:27 +0300
MIME-Version: 1.0
In-Reply-To: <7736f752-5c07-fffd-652d-1aaa8a3193b0@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

29.11.2017 16:24, Austin S. Hemmelgarn пишет:
> On 2017-11-28 18:49, David Sterba wrote:
>> On Tue, Nov 28, 2017 at 09:31:57PM +0000, Nick Terrell wrote:
>>>
>>>> On Nov 21, 2017, at 8:22 AM, David Sterba <dsterba@suse.cz> wrote:
>>>>
>>>> On Wed, Nov 15, 2017 at 08:09:15PM +0000, Nick Terrell wrote:
>>>>> On 11/15/17, 6:41 AM, "David Sterba" <dsterba@suse.cz> wrote:
>>>>>> The branch is now in a state that can be tested. Turns out the memory
>>>>>> requirements are too much for grub, so the boot fails with "not
>>>>>> enough
>>>>>> memory". The calculated value
>>>>>>
>>>>>> ZSTD_BTRFS_MAX_INPUT: 131072
>>>>>> ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
>>>>>>
>>>>>> This is not something I could fix easily, we'd probalby need a tuned
>>>>>> version of ZSTD for grub constraints. Adding Nick to CC.
>>>>>
>>>>> If I understand the grub code correctly, we only need to read, and
>>>>> we have
>>>>> the entire input and output buffer in one segment. In that case you
>>>>> can use
>>>>> ZSTD_initDCtx(), and ZSTD_decompressDCtx().
>>>>> ZSTD_DCtxWorkspaceBound() is
>>>>> only 155984. See decompress_single() in
>>>>> https://patchwork.kernel.org/patch/9997909/ for an example.
>>>>
>>>> Does not help, still ENOMEM.
>>>
>>> It looks like XZ had the same issue, and they make the decompression
>>> context a static object (grep for GRUB_EMBED_DECOMPRESSOR). We could
>>> potentially do the same and statically allocate the workspace:
>>>
>>> ```
>>> /* Could also be size_t */
>>> #define BTRFS_ZSTD_WORKSPACE_SIZE_U64 (155984 / sizeof(uint64_t))
>>> static uint64_t workspace[BTRFS_ZSTD_WORKSPACE_SIZE_U64];
>>>
>>> /* ... */
>>>
>>> assert(sizeof(workspace) >= ZSTD_DCtxWorkspaceBound());
>>> ```
>>
>> Interesting, thanks for the tip, I'll try it next.
>>
>> I've meanwhile tried to tweak the numbers, the maximum block for zstd,
>> that squeezed the DCtx somewhere under 48k, with block size 8k. Still
>> enomem.
>>
>> I've tried to add some debugging prints to see what numbers get actually
>> passed to the allocator, but did not see anything printed.  I'm sure
>> there is a more intelligent way to test the grub changes.  So far each
>> test loop takes quite some time, as I build the rpm package, test it in
>> a VM and have to recreate the environmet each time.
> On the note of testing, have you tried writing up a module to just test
> the decompressor?  If so, you could probably use the 'emu' platform to
> save the need to handle the RPM package and the VM until you get the
> decompressor working by itself, at which point the FUSE modules used to
> test the GRUB filesystem modules may be of some use (or you might be
> able to just use them directly).

There is also grub-fstest which directly calls filesystem drivers; usage
is something like "grub-fstest /dev/sdb1 cat /foo". Replace /dev/sdb1
with any btrfs image. As this is user space it is easy to single step if
needed.
