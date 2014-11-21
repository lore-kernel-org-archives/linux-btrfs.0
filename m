Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59320 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510AbaKUQDg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 11:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141121155519.GB8568@twin.jikos.cz>
References: <danieru.dressler@gmail.com>
	<1415767389-29722-1-git-send-email-danieru.dressler@gmail.com>
	<20141121155519.GB8568@twin.jikos.cz>
Date: Sat, 22 Nov 2014 01:03:32 +0900
Message-ID: <CAGC3nLApxMmbSmPc9WvQ5Uh0prrCY7qzcMABaKs_FcYKdUKCpw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: ctree: reduce args where only fs_info used
From: Daniel Dressler <danieru.dressler@gmail.com>
To: dsterba@suse.cz, Daniel Dressler <danieru.dressler@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ah thanks David for looking at this.

Sorry for the thin paragraphs my vim was warming too early about long
lines. I will reformat it to break at 74 chars.

No problem, I'll redo everything so it is one function per patch. Now
fair warning: there are about 102 functions to cleanup. I was a bit
worried that many patches would cause too much maintainer overhead but
it is no problem for me. Only a few functions have dependecies on
other functions needing cleanup. Thus there will be some small patch
series for those function sets. A big benefit of one function one
patch is that extent-io.c will no longer be a 34 function monster
patch.

Thank you David, I'll redo all these patches.

Is there any rate limiting I should be doing? I don't want to flood
the list with burst of dozen plus patches, or is that an okay volume?

Daniel

2014-11-22 0:55 GMT+09:00 David Sterba <dsterba@suse.cz>:
> On Wed, Nov 12, 2014 at 01:43:09PM +0900, Daniel Dressler wrote:
>> This patch is part of a larger project to cleanup
>> btrfs's internal usage of struct btrfs_root. Many
>> functions take btrfs_root only to grab a pointer
>> to fs_info.
>
> Thanks for picking up the project.
>
> A mere formality, can you please justify the paragraphs to 74 chars?
>
> --
> This patch is part of a larger project to cleanup btrfs's internal usage
> of struct btrfs_root. Many functions take btrfs_root only to grab a
> pointer to fs_info.
> --
>
>> This patch does not address the two functions in
>> ctree.c (insert_ptr, and split_item) which only
>> use root for BUG_ONs in ctree.c
>>
>> This patch affects the following functions:
>>   1) fixup_low_keys
>>   2) btrfs_set_item_key_safe
>
> Please send one patch per function change, unless there are more that
> are somehow entangled that it would make it hard to separate.
