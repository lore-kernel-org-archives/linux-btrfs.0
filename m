Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:41872 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759620AbeD1JgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 05:36:00 -0400
Received: by mail-ot0-f169.google.com with SMTP id t1-v6so4681857oth.8
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 02:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180424233717.31283-1-nefelim4ag@gmail.com> <20180424233717.31283-2-nefelim4ag@gmail.com>
 <20180426140314.GW21272@twin.jikos.cz>
In-Reply-To: <20180426140314.GW21272@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 28 Apr 2018 09:35:24 +0000
Message-ID: <CAGqmi76QniEfFc-95xHovY9Be4CHu7=6ioRRdgGfAw82oxLdEA@mail.gmail.com>
Subject: Re: [PATCH 1/4] [RESEND] Btrfs: btrfs_dedupe_file_range() ioctl,
 remove 16MiB restriction
To: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

чт, 26 апр. 2018 г. в 17:05, David Sterba <dsterba@suse.cz>:

> On Wed, Apr 25, 2018 at 02:37:14AM +0300, Timofey Titovets wrote:
> > At now btrfs_dedupe_file_range() restricted to 16MiB range for
> > limit locking time and memory requirement for dedup ioctl()
> >
> > For too big input range code silently set range to 16MiB
> >
> > Let's remove that restriction by do iterating over dedup range.
> > That's backward compatible and will not change anything for request
> > less then 16MiB.
> >
> > Changes:
> >   v1 -> v2:
> >     - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
> >     - Store memory of pages array between iterations
> >     - Lock inodes once, not on each iteration
> >     - Small inplace cleanups

> I think this patch should be split into more, there are several logical
> changes mixed together.

> I can add the patch to for-next to see if there are any problems caught
> by the existing test, but will expect more revisions of the patch. I
> don't see any fundamental problems so far.

> Suggested changes:
> * factor out __btrfs_extent_same
> * adjust parameters if needed by the followup patches
> * add the chunk counting logic
> * any other cleanups

Thanks, i will try split it out.

-- 
Have a nice day,
Timofey.
