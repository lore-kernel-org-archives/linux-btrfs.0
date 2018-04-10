Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbeDJMOo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 08:14:44 -0400
Date: Tue, 10 Apr 2018 14:12:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not abort transaction when failing to insert
 hole extent
Message-ID: <20180410121214.GC2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522447918-19147-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180405164831.GI2635@twin.jikos.cz>
 <CANQeFDBSAX=+-S7umzWAXgVzUe7vXYM=qL6FJSUTw9jmPj=nnw@mail.gmail.com>
 <20180406132129.GD8557@twin.jikos.cz>
 <CANQeFDBu+oG2W7rxjM3G+KBkN=hVwVG_GdPm6-jpfJPpCnabCw@mail.gmail.com>
 <CANQeFDCV5p+t0kLDHjrTmeT6_S9U-zLHP5c0btR_UbtON-TpaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANQeFDCV5p+t0kLDHjrTmeT6_S9U-zLHP5c0btR_UbtON-TpaA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2018 at 06:23:14PM -0700, Liu Bo wrote:
> >>> As maybe_insert_hole is only called by btrfs_cont_expand here, which
> >>> means it's a really hole, I don't expect drop_extents would drop
> >>> anything, we can remove this drop_extents and put an assert after
> >>> btrfs_insert_file_extent for checking EEXIST.
> >> Sounds good.
> > Let me make a v2 and have a fstests run.
> It turns out that the btrfs_drop_extents() here is quite necessary
> since fallocate(2) has a FALLOC_FL_KEEP_SIZE option, and when that
> happens, a hole extent would be appended between the EOF and fallocate
> range's start, then a later truncate up would have to drop these hole
> extents in order to expand with a new hole...

Would it make sense to split the cases where FALLOC_FL_KEEP_SIZE is and
is not used? Either passing an argument or 2 functions where one could
avoid the drop. I've looked at the code only briefly, so this may be a
nonsense in the end.

> As I don't see a way to gracefully solve this except keeping
> drop_extents(), lets drop this patch instead.

Understood.
