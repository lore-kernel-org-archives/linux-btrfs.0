Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45372 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751701AbdK1VcP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 16:32:15 -0500
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Date: Tue, 28 Nov 2017 21:31:57 +0000
Message-ID: <5BB834FC-A54C-4448-8D86-1D2F22806096@fb.com>
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com> <20171121162239.GO3553@suse.cz>
In-Reply-To: <20171121162239.GO3553@suse.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Nov 21, 2017, at 8:22 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> On Wed, Nov 15, 2017 at 08:09:15PM +0000, Nick Terrell wrote:
>> On 11/15/17, 6:41 AM, "David Sterba" <dsterba@suse.cz> wrote:
>>> The branch is now in a state that can be tested. Turns out the memory
>>> requirements are too much for grub, so the boot fails with "not enough
>>> memory". The calculated value
>>> 
>>> ZSTD_BTRFS_MAX_INPUT: 131072
>>> ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
>>> 
>>> This is not something I could fix easily, we'd probalby need a tuned
>>> version of ZSTD for grub constraints. Adding Nick to CC.
>> 
>> If I understand the grub code correctly, we only need to read, and we have
>> the entire input and output buffer in one segment. In that case you can use
>> ZSTD_initDCtx(), and ZSTD_decompressDCtx(). ZSTD_DCtxWorkspaceBound() is
>> only 155984. See decompress_single() in
>> https://patchwork.kernel.org/patch/9997909/ for an example.
> 
> Does not help, still ENOMEM.

It looks like XZ had the same issue, and they make the decompression
context a static object (grep for GRUB_EMBED_DECOMPRESSOR). We could
potentially do the same and statically allocate the workspace:

```
/* Could also be size_t */
#define BTRFS_ZSTD_WORKSPACE_SIZE_U64 (155984 / sizeof(uint64_t))
static uint64_t workspace[BTRFS_ZSTD_WORKSPACE_SIZE_U64];

/* ... */

assert(sizeof(workspace) >= ZSTD_DCtxWorkspaceBound());
```