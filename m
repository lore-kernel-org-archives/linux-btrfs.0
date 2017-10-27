Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48631 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932190AbdJ0Ri6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 13:38:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C7D9AD70
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 17:38:57 +0000 (UTC)
Date: Fri, 27 Oct 2017 19:37:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/8] mkfs: Quota support
Message-ID: <20171027173709.GO3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171027072936.4697-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 03:29:28PM +0800, Qu Wenruo wrote:
> This patchset adds quota support, which means the result fs will have
> quota enabled by default, and its accounting is already consistent, no
> manually rescan or quota enable is needed.

Great, thanks for working on that. I'm going to merge the preparatory
patches next. I'm not sure about the command line option, we might want
to design it in a similar way as -O/--features. As this is a runtime
feature (unlike the on-disk format features), a new option will be
needed, backed by some research what other mkfs.* tools use.

The uuid_tree would at least use the btrfs_create_tree, but I don't
think we'd need to create it only on request, so quotas will be the only
option.

> 2) Fill quota root with basic skeleton
>    Only 3 items are really needed
>    a) global quota status item
>    b) quota info for 0/5 qgroup
>    c) quota limit for 0/5 qgroup
> 
>    The content doesn't matter at all.

How would --rootdir and quotas behave in that case? A related question
is what will be the semantics of rootdir+quotas+subvolume created at
mkfs time.

We can certainly start with only quotas on the empty filesystem, but I'm
sure somebody will ask for the wild combination at some point.
