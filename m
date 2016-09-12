Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38782 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932943AbcILMy4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:54:56 -0400
Received: by mail-it0-f48.google.com with SMTP id n143so5468920ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:54:56 -0700 (PDT)
Subject: Re: btrfs kernel oops on mount
To: Jeff Mahoney <jeffm@suse.com>, moparisthebest <admin@moparisthebest.com>,
        linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <84b8f928-48e3-00dc-1d16-fedb04f8d180@gmail.com>
Date: Mon, 12 Sep 2016 08:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 08:33, Jeff Mahoney wrote:
> On 9/9/16 8:47 PM, Austin S. Hemmelgarn wrote:
>> A couple of other things to comment about on this:
>> 1. 'can_overcommit' (the function that the Arch kernel choked on) is
>> from the memory management subsystem.  The fact that that's throwing a
>> null pointer says to me either your hardware has issues, or the Arch
>> kernel itself has problems (which would probably mean the kernel image
>> is corrupted).
>
> fs/btrfs/extent-tree.c:
> static int can_overcommit(struct btrfs_root *root,
>                           struct btrfs_space_info *space_info, u64 bytes,
>                           enum btrfs_reserve_flush_enum flush)
>
OK, my bad there, but that begs the question: why does a BTRFS function 
not have a BTRFS prefix?  The name blatantly sounds like a mm function 
(and I could have sworn I can across one with an almost identical name 
when I was trying to understand the mm code a couple months ago), and 
the lack of a prefix combined with that heavily implies that it's a core 
kernel function.

Given this, it's almost certainly the balance choking on corrupted 
metadata that's causing the issue.
>> 3. In general, it's a good idea to keep an eye on space usage on your
>> filesystems.  If it's getting to be more than about 95% full, you should
>> be looking at getting some more storage space.  This is especially true
>> for BTRFS, as a 100% full BTRFS filesystem functionally becomes
>> permanently read-only because there's nowhere for the copy-on-write
>> updates to write to.
>
> The entire point of having the global metadata reserve is to avoid that
> situation.
Except that the global metadata reserve is usually only just barely big 
enough, and it only works for metadata.  While I get that this issue is 
what it's supposed to fix, it doesn't do so in a way that makes it easy 
to get out of that situation.  The reserve itself is often not big 
enough to do anything in any reasonable amount of time once the FS gets 
beyond about a hundred GB and yous tart talking about very large files.
