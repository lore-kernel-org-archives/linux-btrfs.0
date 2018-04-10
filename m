Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeDJS0Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 14:26:24 -0400
Date: Tue, 10 Apr 2018 20:23:54 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
Message-ID: <20180410182354.GH2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 04:27:09PM +0900, Misono, Tomohiro wrote:
> changelog:
> 
> v2-> v3
>  - fix kbuild test bot warning
> v1 -> v2
>   - completely reimplement 1st/2nd ioctl to have user friendly api
>   - various cleanup, remove unnecessary goto
> ===
> 
> This adds three new unprivileged ioctls:
> 
> 1st patch: ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
> 2nd patch: ioctl which returns subvolume information of ROOT_REF (without subvolume name)
> 3rd patch: user version of ino_lookup ioctl which also peforms permission check.

The overall approach to listing subvolumes looks good. We can enumerate
them, get the relations and the details. Making some sense of that in
the userspace is a whole different and maybe more difficult topic.

I hope we could use the opportunity to clean up the listing commandline
interface and output at the same time, as there's going to be possibly
some incompatibility introduced.

We need to start with current usecases and how they're implemented or
mis-implemented (ie. leading to confusion). The discussions I've read so
far cover a good part of that.

I'll review and add the kernel patches to misc-next to get some testing
coverage. As this is a non-restricted ioctl full of pointers and bytes
shuffled around, we will have to do an extra security-oriented review.
