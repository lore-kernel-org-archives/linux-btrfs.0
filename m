Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36638 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbLMKS4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 05:18:56 -0500
Received: by qkht125 with SMTP id t125so98468175qkh.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 02:18:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3ku8mhfK_ZvZRL2pRSZ=Y1Q2maNF_ob+8fEA=2Etm1Lg@mail.gmail.com>
References: <1446318664-26750-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1446452986-6581-1-git-send-email-chandan@linux.vnet.ibm.com>
	<20151102165236.GA9975@ret.masoncoding.com>
	<CAOcd+r3ku8mhfK_ZvZRL2pRSZ=Y1Q2maNF_ob+8fEA=2Etm1Lg@mail.gmail.com>
Date: Sun, 13 Dec 2015 12:18:55 +0200
Message-ID: <CAOcd+r0ffSmVzEyZZHttJBEW6t+rRHr3N6W-=6SwuV3amq1Uqg@mail.gmail.com>
Subject: Re: [PATCH V2] Btrfs: find_free_extent: Do not erroneously skip
 LOOP_CACHING_WAIT state
From: Alex Lyakas <alex@zadarastorage.com>
To: Chris Mason <clm@fb.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Resending in plain text, apologies.]

Hi Chandan, Josef, Chris,

I am not sure I understand the fix to the problem.

It may happen that when updating the device tree, we need to allocate a new
chunk via do_chunk_alloc (while we are holding the device tree root node
locked). This is a legitimate thing for find_free_extent() to do. And
do_chunk_alloc() call may lead to call to
btrfs_create_pending_block_groups(), which will try to update the device
tree. This may happen due to direct call to
btrfs_create_pending_block_groups() that exists in do_chunk_alloc(), or
perhaps by __btrfs_end_transaction() that find_free_extent() does after it
completed chunk allocation (although in this case it will use the
transaction that already exists in current->journal_info).
So the deadlock still may happen?

Thanks,
 Alex.

>
>
> On Mon, Nov 2, 2015 at 6:52 PM, Chris Mason <clm@fb.com> wrote:
>>
>> On Mon, Nov 02, 2015 at 01:59:46PM +0530, Chandan Rajendra wrote:
>> > When executing generic/001 in a loop on a ppc64 machine (with both
>> > sectorsize
>> > and nodesize set to 64k), the following call trace is observed,
>>
>> Thanks Chandan, I hit this same trace on x86-64 with 16K nodes.
>>
>> -chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
