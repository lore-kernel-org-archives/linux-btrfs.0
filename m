Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752047AbeFFOsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 10:48:22 -0400
Date: Wed, 6 Jun 2018 16:45:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
        Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: Change return type to vm_fault_t
Message-ID: <20180606144535.GH3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605154635.GA27201@jordon-HP-15-Notebook-PC>
 <20180606132228.GF3539@twin.jikos.cz>
 <CAFqt6zY-q4xV+PAFKXfa+NjNYyiBy4K5VSykKqbeN0XGpCTudw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFqt6zY-q4xV+PAFKXfa+NjNYyiBy4K5VSykKqbeN0XGpCTudw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 07:39:53PM +0530, Souptick Joarder wrote:
> >> @@ -8885,8 +8885,9 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
> >>       char *kaddr;
> >>       unsigned long zero_start;
> >>       loff_t size;
> >> -     int ret;
> >> +     int err;
> >
> > Please use ret2 for the variable name. We're leaving the err/ret naming
> > pattern and use 'ret' to match the function return value and ret2, ret3
> > for the temporary return values.
> 
> Is this new pattern specific to fs/btrfs file system ?

Yes it is, you're not expected to know it in advance but as this was not
the only thing to update in the patch I did not fix it myself.

> >> -     ret = 0;
> >> +     err = 0;
> >>
> >>       /* page is wholly or partially inside EOF */
> >>       if (page_start + PAGE_SIZE > size)
> >> @@ -9009,11 +9007,11 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
> >>       unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
> >>
> >>  out_unlock:
> >> -     if (!ret) {
> >> +     if (!err) {
> >>               btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
> >>               sb_end_pagefault(inode->i_sb);
> >>               extent_changeset_free(data_reserved);
> >> -             return VM_FAULT_LOCKED;
> >> +             ret = VM_FAULT_LOCKED;
> >
> > That's not a direct change as it changes the code flow and lets the
> > branch continue. As the error handling and cleanup code is partially
> > done in this branch continuing wrong AFAICS.
> 
> Sorry about it, I will correct and send v2.
> Is it possible to get it merge in 4.18 / 4.18-rc-X ?

Ok.
