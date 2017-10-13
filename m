Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54947 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753447AbdJMN4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:56:01 -0400
Subject: Re: [PATCH 01/21] Btrfs: rework outstanding_extents
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-2-git-send-email-jbacik@fb.com>
 <704b1207-5219-89dd-6ddd-582ed74f759f@suse.com>
 <20171013131050.q5huwryq444utast@destiny>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9dcaa11c-679c-0fda-4e69-327cf85d1ba5@suse.com>
Date: Fri, 13 Oct 2017 16:55:58 +0300
MIME-Version: 1.0
In-Reply-To: <20171013131050.q5huwryq444utast@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> The outstanding_extents accounting is consistent with only the items needed to
> handle the outstanding extent items.  However since changing the inode requires
> updating the inode item as well we have to keep this floating reservation for
> the inode item until we have 0 outstanding extents.  The way we do this is with
> the BTRFS_INODE_DELALLOC_META_RESERVED flag.  So if it isn't set we will
> allocate nr_exntents + 1 in btrfs_delalloc_reserve_metadata() and then set our
> bit.  If we ever steal this reservation we make sure to clear the flag so we
> know we don't have to clean it up when outstanding_extents goes to 0.  It's not
> super intuitive but needs to be done under the BTRFS_I(inode)->lock so this was
> the best place to put it.  I suppose we could move the logic out of here and put
> it somewhere else to make it more clear.

I think defining this logic in its own, discrete block of code would be
best w.r.t readibility. It's not super obvious.


I'm slowly going through your patchkit so expect more question but
otherwise the delalloc stuff after this and patch 03 really start
looking a lot more obvious !


