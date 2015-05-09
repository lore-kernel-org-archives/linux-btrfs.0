Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33869 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbEIASE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 20:18:04 -0400
Received: by pacyx8 with SMTP id yx8so62152566pac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 17:18:03 -0700 (PDT)
Date: Fri, 8 May 2015 17:18:02 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: iterate over unused chunk space in FITRIM
Message-ID: <20150509001802.GA19531@mew>
References: <554909A5.4030307@suse.com>
 <CAL3q7H5O0w+_EPSbpMyWTYzyzyCOxHmU-wPRx7w85ftUzHzXgQ@mail.gmail.com>
 <554D35F6.8040601@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <554D35F6.8040601@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 08, 2015 at 06:17:26PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 5/8/15 4:38 PM, Filipe David Manana wrote:
> > On Tue, May 5, 2015 at 7:19 PM, Jeff Mahoney <jeffm@suse.com>
> > wrote:
> >> -static int contains_pending_extent(struct btrfs_trans_handle
> >> *trans, +static int contains_pending_extent(struct
> >> btrfs_transaction *transaction, struct btrfs_device *device, u64
> >> *start, u64 len) { +       struct btrfs_fs_info *fs_info =
> >> device->dev_root->fs_info; struct extent_map *em; -       struct
> >> list_head *search_list = &trans->transaction->pending_chunks; +
> >> struct list_head *search_list = &transaction->pending_chunks;
> > 
> > transaction can be NULL so we need to check for that first (as you
> > do below).
> 
> The ordering here is safe. We're not dereferencing the transaction,
> we're getting the address of one of the members. search_list will
> point to 0x100 or something. We don't ever dereference that without
> checking the transaction against NULL.
> 

Hi, Jeff,

I believe I've seen this topic come up before -- see [1]. Although it's
probably fine on any sane compiler, it's apparently not correct from a
language standard standpoint. Probably better safe than sorry.

[1] https://software.intel.com/en-us/blogs/2015/04/20/null-pointer-dereferencing-causes-undefined-behavior

Thanks!
-- 
Omar
