Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35746 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbeDLBjb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 21:39:31 -0400
Received: by mail-it0-f66.google.com with SMTP id q85-v6so5083499itc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 18:39:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180410121214.GC2817@twin.jikos.cz>
References: <1522447918-19147-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180405164831.GI2635@twin.jikos.cz> <CANQeFDBSAX=+-S7umzWAXgVzUe7vXYM=qL6FJSUTw9jmPj=nnw@mail.gmail.com>
 <20180406132129.GD8557@twin.jikos.cz> <CANQeFDBu+oG2W7rxjM3G+KBkN=hVwVG_GdPm6-jpfJPpCnabCw@mail.gmail.com>
 <CANQeFDCV5p+t0kLDHjrTmeT6_S9U-zLHP5c0btR_UbtON-TpaA@mail.gmail.com> <20180410121214.GC2817@twin.jikos.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Wed, 11 Apr 2018 18:39:30 -0700
Message-ID: <CANQeFDB9RERAaTiuz=Qda4HKjRz7J_JTy2RLuqdoAddg+QkcBQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not abort transaction when failing to insert
 hole extent
To: David Sterba <dsterba@suse.cz>, Liu Bo <obuil.liubo@gmail.com>,
        Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2018 at 5:12 AM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Apr 09, 2018 at 06:23:14PM -0700, Liu Bo wrote:
>> >>> As maybe_insert_hole is only called by btrfs_cont_expand here, which
>> >>> means it's a really hole, I don't expect drop_extents would drop
>> >>> anything, we can remove this drop_extents and put an assert after
>> >>> btrfs_insert_file_extent for checking EEXIST.
>> >> Sounds good.
>> > Let me make a v2 and have a fstests run.
>> It turns out that the btrfs_drop_extents() here is quite necessary
>> since fallocate(2) has a FALLOC_FL_KEEP_SIZE option, and when that
>> happens, a hole extent would be appended between the EOF and fallocate
>> range's start, then a later truncate up would have to drop these hole
>> extents in order to expand with a new hole...
>
> Would it make sense to split the cases where FALLOC_FL_KEEP_SIZE is and
> is not used? Either passing an argument or 2 functions where one could
> avoid the drop. I've looked at the code only briefly, so this may be a
> nonsense in the end.
>

I'm afraid that It won't work as there is no way I could think of to
know whether an inode has been fallocate with KEEP_SIZE, IOW, seems
that we have to do a search to check if there are extra extents beyond
EOF.

thanks,
liubo

>> As I don't see a way to gracefully solve this except keeping
>> drop_extents(), lets drop this patch instead.
>
> Understood.
