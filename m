Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33196 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbeHTPbo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 11:31:44 -0400
Received: by mail-it0-f66.google.com with SMTP id d16-v6so7940323itj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 05:16:20 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>
Cc: waxhead@dirtcellar.net, Adam Hunt <voxadam@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <ompef3$sim$1@blaine.gmane.org>
 <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
Date: Mon, 20 Aug 2018 08:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-19 06:25, Andrei Borzenkov wrote:
> 
> 
> Отправлено с iPhone
> 
>> 19 авг. 2018 г., в 11:37, Martin Steigerwald <martin@lichtvoll.de> написал(а):
>>
>> waxhead - 18.08.18, 22:45:
>>> Adam Hunt wrote:
>>>> Back in 2014 Ted Tso introduced the lazytime mount option for ext4
>>>> and shortly thereafter a more generic VFS implementation which was
>>>> then merged into mainline. His early patches included support for
>>>> Btrfs but those changes were removed prior to the feature being
>>>> merged. His>
>>>> changelog includes the following note about the removal:
>>>>    - Per Christoph's suggestion, drop support for btrfs and xfs for
>>>>    now,
>>>>
>>>>      issues with how btrfs and xfs handle dirty inode tracking.  We
>>>>      can add btrfs and xfs support back later or at the end of this
>>>>      series if we want to revisit this decision.
>>>>
>>>> My reading of the current mainline shows that Btrfs still lacks any
>>>> support for lazytime. Has any thought been given to adding support
>>>> for lazytime to Btrfs?
>> […]
>>> Is there any new regarding this?
>>
>> I´d like to know whether there is any news about this as well.
>>
>> If I understand it correctly this could even help BTRFS performance a
>> lot cause it is COW´ing metadata.
>>
> 
> I do not see how btrfs can support it exactly due to cow. Modified atime means checksum no more matches so you must update all related metadata. At which point you have kind of shadow in-memory metadata trees. And if this metadata is not written out, then some other metadata that refers to them becomes invalid.
I think you might be misunderstanding something here, either how 
lazytime actually works, or how BTRFS checksumming works.

Lazytime prevents timestamp updates from triggering writeback of a 
cached inode.  Other changes will trigger writeback, as will anything 
that evicts the inode from the cache, and an automatic writeback will be 
triggered if the timestamp changed more than 24 hours ago, but until any 
of those situations happens, no writeback will be triggered.

BTRFS checksumming only verifies checksums of blocks which are being 
read.  If the inode is in the cache (which it has to be for lazytime to 
have _any_ effect on it), the block containing it on disk does not need 
to be read, so no checksum verification happens.  Even if there was 
verification, we would not be verifying blocks that are in memory using 
the on-disk checksums (because that would break writeback caching, which 
we already do and already works correctly).

So, given all this, the only inconsistency on-disk for BTRFS with this 
would be identical to the inconsistency it causes for other filesystems, 
namely that mtimes and atimes may not be accurate.

Also, slightly OT, but atimes are not where the real benefit is here for 
most people.  No sane software other than mutt uses atimes (and mutt's 
use of them is not sane, but that's a different argument), so pretty 
much everyone who wants to avoid the overhead from them can just use the 
`noatime` mount option.  The real benefit for most people is with 
mtimes, for which there is no other way to limit the impact they have on 
performance.
> 
> I suspect any file system that keeps checksums of metadata will run into the same issue.
> 
Nope, only if they verify checksums on stuff that's already cached _and_ 
they pull the checksums for verification from the block device and not 
the cache.
