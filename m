Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35157 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdDJOR5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 10:17:57 -0400
Received: by mail-qk0-f182.google.com with SMTP id f133so95827314qke.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 07:17:57 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: About the behavior of inline extent
From: Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <f9dc56cc-720e-0df1-f6c7-790e93276ee0@cn.fujitsu.com>
Date: Mon, 10 Apr 2017 10:17:52 -0400
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <68B899DF-1EFE-4463-A3F8-BD03E0B811DC@toxicpanda.com>
References: <f9dc56cc-720e-0df1-f6c7-790e93276ee0@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Apr 9, 2017, at 11:27 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> 
> Hi,
> 
> Recent btrfs/137 test case makes me wonder what's the designed behavior of btrfs inline data extent.
> 
> The current behavior in fact is quite a chaos.
> We need a standard of how inline extent should behave.
> 
> 1) max_inline limit
>   The problem of current max_inline is, it's never clear what it is
>   limiting.
> 
>   For example, we don't allow page sized inline extent if not
>   compressed.
>   But we allow page sized inline extent if it's compressed.
>   Is it just limiting size after compression?
>   What if we really want to limit size before compression?
> 

max_inline is for the actual space on disk.  Compression takes up less space, therefore you can fit bigger actual data into the inline area.

> 2) inline extent condition
>   Is inline extent allowed if we have following regular extent?
> 
>   For plain extent, prealloc can cause regular extent to co-exist with
>   inlined one.
>   While normal write will only convert inlined extent to regular one.
> 
>   While for compressed extent, it can co-exist with regular extent, by
>   # xfs_io -f -c "pwrite 0 4k" -c sync -c "pwrite 4k 16k" /mnt/btrfs/file
> 
>   So which is the correct behavior?
>   Personally I think we should not allow co-exist, as it's already
>   causing a lot of fixes for it, that's to say neither current
>   behavior is correct.
> 

Historically we didn't have [inline][regular] because inline was always < block size, so any change to the inline extent to extend it resulted in a regular extent.  Obviously that changed with fallocate, so it is perfectly reasonable to have [inline][regular extent]

> 3) inline extent and fallocate
>   For inline extent, as long as we are calling fallocate inside the
>   page size, only the isize is expanded.
> 
>   Only beyond page size, we get prealloc extents.
>   (However inlined extent is still here, not converted)
> 
>   What's the designed behavior? Convert inline to regular or just
>   leave it as is?

Leave it.  fallocate doesn't change anything about existing regular extents.  Calling fallocate on a range completely inside of a regular extent does nothing, why would this change with an inline extent?  Now past the inline extent you get a new extent, exactly the same behavior as a regular extent.  Thanks,

Josef

