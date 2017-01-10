Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35313 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032039AbdAJA4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 19:56:36 -0500
Received: by mail-pf0-f173.google.com with SMTP id f144so26845815pfa.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jan 2017 16:56:36 -0800 (PST)
Date: Mon, 9 Jan 2017 16:56:14 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [RFC] Converging userspace and kernel code
Message-ID: <20170110005614.GA8374@vader.dhcp.thefacebook.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
 <2a7a4b30-3a90-1aaf-b9ba-9269c58a31c9@suse.de>
 <27be1998-e535-b630-e10c-778cc53acd2e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <27be1998-e535-b630-e10c-778cc53acd2e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2017 at 08:35:26AM +0800, Qu Wenruo wrote:
> That depends on how independent the "core" btrfs part is.
> 
> If completely independent,(Don't ever has any page/VFS/race code) I'm
> completely fine with that.
> 
> But the problem is, at least from current code base, even btrfs_path
> structure has quite a lot kernel facilities, mainly locks.
> (Just check the different size of btrfs_path in kernel and btrfs-progs)
> 
> So although the idea itself is very nice, but the practice may be quite
> hard.
> 
> That's why I prefer current btrfs-progs method, because it's more close to
> the core of btrfs algorithm, unlike kernel, which is a superset.
> In this case, I prefer to let kernel use and expand btrfs-progs code, other
> than pull in a superset from kernel.

[snip]

> While most of the bugs I found in RAID5/6 and dev-replace are all related to
> race, which doesn't ever exist in btrfs-progs.
> (That's why I love btrfs-progs so much than the kernel part)
> 
> So the problem is still how independent we can extract the core functions.
> 
> Thanks,
> Qu

I think you're getting too hung up on scrub/device replace. It doesn't
have to be an all-or-nothing thing. If the scrub code is too insane or
broken to pull in, then we can probably get away with a clean
reimplementation in btrfs-progs if we really want to. I think for a
majority of the Btrfs code, locking and other kernel-specific stuff
won't be too distracting. A good starting point might be the core B-tree
code.
