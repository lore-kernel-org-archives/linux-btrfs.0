Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:46202 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753134AbdJSSKh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:10:37 -0400
Received: by mail-qk0-f177.google.com with SMTP id k123so11455633qke.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 11:10:36 -0700 (PDT)
Date: Thu, 19 Oct 2017 14:10:34 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/21] Btrfs: rework outstanding_extents
Message-ID: <20171019181032.7hl5keeasqwy5yk5@destiny>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-2-git-send-email-jbacik@fb.com>
 <704b1207-5219-89dd-6ddd-582ed74f759f@suse.com>
 <20171013131050.q5huwryq444utast@destiny>
 <9dcaa11c-679c-0fda-4e69-327cf85d1ba5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9dcaa11c-679c-0fda-4e69-327cf85d1ba5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 04:55:58PM +0300, Nikolay Borisov wrote:
> 
> > 
> > The outstanding_extents accounting is consistent with only the items needed to
> > handle the outstanding extent items.  However since changing the inode requires
> > updating the inode item as well we have to keep this floating reservation for
> > the inode item until we have 0 outstanding extents.  The way we do this is with
> > the BTRFS_INODE_DELALLOC_META_RESERVED flag.  So if it isn't set we will
> > allocate nr_exntents + 1 in btrfs_delalloc_reserve_metadata() and then set our
> > bit.  If we ever steal this reservation we make sure to clear the flag so we
> > know we don't have to clean it up when outstanding_extents goes to 0.  It's not
> > super intuitive but needs to be done under the BTRFS_I(inode)->lock so this was
> > the best place to put it.  I suppose we could move the logic out of here and put
> > it somewhere else to make it more clear.
> 
> I think defining this logic in its own, discrete block of code would be
> best w.r.t readibility. It's not super obvious.
> 

I went to do this and realized that I rip all of this out when we switch to
per-inode block rsvs, so I'm just going to leave this patch as is.  Thanks,

Josef
