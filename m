Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751389AbdK2Aor (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 19:44:47 -0500
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Date: Wed, 29 Nov 2017 00:44:32 +0000
Message-ID: <EF0643B4-092E-4D82-BA5B-9B02DFDEACA6@fb.com>
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com> <20171121162239.GO3553@suse.cz>
 <5BB834FC-A54C-4448-8D86-1D2F22806096@fb.com> <20171128234937.GG3553@suse.cz>
In-Reply-To: <20171128234937.GG3553@suse.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Nov 28, 2017, at 3:49 PM, David Sterba <dsterba@suse.cz> wrote:
> 
> On Tue, Nov 28, 2017 at 09:31:57PM +0000, Nick Terrell wrote:
>> 
>>> On Nov 21, 2017, at 8:22 AM, David Sterba <dsterba@suse.cz> wrote:
>>> 
>>> On Wed, Nov 15, 2017 at 08:09:15PM +0000, Nick Terrell wrote:
>>>> On 11/15/17, 6:41 AM, "David Sterba" <dsterba@suse.cz> wrote:
>>>>> The branch is now in a state that can be tested. Turns out the memory
>>>>> requirements are too much for grub, so the boot fails with "not enough
>>>>> memory". The calculated value
>>>>> 
>>>>> ZSTD_BTRFS_MAX_INPUT: 131072
>>>>> ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
>>>>> 
>>>>> This is not something I could fix easily, we'd probalby need a tuned
>>>>> version of ZSTD for grub constraints. Adding Nick to CC.
>>>> 
>>>> If I understand the grub code correctly, we only need to read, and we have
>>>> the entire input and output buffer in one segment. In that case you can use
>>>> ZSTD_initDCtx(), and ZSTD_decompressDCtx(). ZSTD_DCtxWorkspaceBound() is
>>>> only 155984. See decompress_single() in
>>>> https://patchwork.kernel.org/patch/9997909/ for an example.
>>> 
>>> Does not help, still ENOMEM.
>> 
>> It looks like XZ had the same issue, and they make the decompression
>> context a static object (grep for GRUB_EMBED_DECOMPRESSOR). We could
>> potentially do the same and statically allocate the workspace:
>> 
>> ```
>> /* Could also be size_t */
>> #define BTRFS_ZSTD_WORKSPACE_SIZE_U64 (155984 / sizeof(uint64_t))
>> static uint64_t workspace[BTRFS_ZSTD_WORKSPACE_SIZE_U64];
>> 
>> /* ... */
>> 
>> assert(sizeof(workspace) >= ZSTD_DCtxWorkspaceBound());
>> ```
> 
> Interesting, thanks for the tip, I'll try it next.
> 
> I've meanwhile tried to tweak the numbers, the maximum block for zstd,
> that squeezed the DCtx somewhere under 48k, with block size 8k. Still
> enomem.

Sadly the block size has to stay 128 KiB, since that is the block size that
is used for compression.

> I've tried to add some debugging prints to see what numbers get actually
> passed to the allocator, but did not see anything printed.  I'm sure
> there is a more intelligent way to test the grub changes.  So far each
> test loop takes quite some time, as I build the rpm package, test it in
> a VM and have to recreate the environmet each time.

Is the code in github.com/kdave/grub in the btrfs-zstd branch up to date?
btrfs.c:1230 looks like it will error for zstd compression, but not with
ENOMEM. btrfs.c:1272 [2] looks like a typo. Maybe the second is causing
the compressed block to be interpreted as uncompressed, and causes a
too-large allocation?

[1] https://github.com/kdave/grub/blob/btrfs-zstd/grub-core/fs/btrfs.c#L1230
[2] https://github.com/kdave/grub/blob/btrfs-zstd/grub-core/fs/btrfs.c#L1272