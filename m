Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754320AbeEaJhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 05:37:48 -0400
Date: Thu, 31 May 2018 11:35:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
Message-ID: <20180531093503.GL3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526863497.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1526863497.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 10:09:41AM +0900, Tomohiro Misono wrote:
> changelog:
> v6 -> v7
>   - Rebase to current misc-next again
>   - Fix 1st patch where otime is wrongly set instead of ctime
>   - Add reviewed-by/tested-by tag

> This adds three new unprivileged ioctls:
> 
> 1st patch:
>   ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
> 2nd patch:
>   ioctl which returns subvolume information of ROOT_REF (without subvolume name)
> 3rd patch: 
>   user version of ino_lookup ioctl which also performs permission check.
> 
> They will be used to implement user version of "subvolume list/show" etc.
> in user tools.
> See each commit log for more detals.

I did one more pass yesterday and found some style issues and fixed
them. The security review isn't done yet but any issues can be fixed
during the 4.18 cycle. The ioctl structures look ok though I still don't
feel I have a full understanding how the paths are constructed and if
the buffers are big enough or what the limitations that can be hit in
practice.

The patchset will be added to misc-next and that's probably the last
thing before I mark it as for-4.18 and will not touch until 4.18-rc1.
