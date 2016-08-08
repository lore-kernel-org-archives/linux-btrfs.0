Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37845 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbcHHOQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Aug 2016 10:16:33 -0400
Subject: Re: Crash in btrfs_uuid_tree_iterate during mount
To: Nikolay Borisov <kernel@kyup.com>, <linux-btrfs@vger.kernel.org>
References: <57A473B0.2040203@kyup.com>
 <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com> <57A863C6.5060503@kyup.com>
CC: SiteGround Operations <operations@siteground.com>
From: Chris Mason <clm@fb.com>
Message-ID: <ce59ace9-9cf3-ec8e-1f25-d6b794cf5109@fb.com>
Date: Mon, 8 Aug 2016 10:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <57A863C6.5060503@kyup.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2016 06:49 AM, Nikolay Borisov wrote:
>
>
> On 08/05/2016 06:12 PM, Chris Mason wrote:

> Hello Chris,
>
> Indeed it seems that btrfs_uuid_iter_rem returned a ENOENT:
>
> callq  0xffffffffa081f450 <btrfs_uuid_tree_rem>
> mov    %eax,%r13d
> je     0xffffffffa081f882 <btrfs_uuid_tree_iterate+514> ; if uuid_iter_rem returned -ENOENT; else fall through.
>
> I checked and r13d is not being touched between the invocation of
> btrfs_uuid_iter_rem and the btrfs_next_item:
>     RIP: ffffffffa081f774  RSP: ffff88034e507e20  RFLAGS: 00010246
>     RAX: 0000000000000000  RBX: 0000160000000000  RCX: ffff880000000000
>     RDX: 0000000000000001  RSI: ffff8801e3abd140  RDI: ffff88046f027f00
>     RBP: ffff88034e507ea8   R8: 000060fb80001760   R9: ffffffffa07ac1de
>     R10: ffffe8ffffd41760  R11: ffffea00078eaf40  R12: ffff8801b98ab750
>     R13: 00000000fffffffe  R14: ffff8801e3abd140  R15: ffff880049586000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>
> r13 is clearly -ENOENT. So your assumption was correct.

Fantastic, thanks again for digging through it.  Making the patch is 
much easier than testing the patch in this case.  If you can trigger 
this semi-reliably, we can add some debugging to make sure we're not 
papering over some other problem.

-chris
