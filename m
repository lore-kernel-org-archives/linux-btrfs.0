Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:32973 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752788AbeFGBBr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 21:01:47 -0400
Received: by mail-ot0-f195.google.com with SMTP id h6-v6so9552608otj.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jun 2018 18:01:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180605043656.4006-1-wqu@suse.com>
References: <20180605043656.4006-1-wqu@suse.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Wed, 6 Jun 2018 21:01:45 -0400
Message-ID: <CA+X5Wn7fBAds9g4CXZZNtquqhnohSSUeFX=g0_xQEoQ5dd3KRQ@mail.gmail.com>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device replace
To: Qu Wenruo <wqu@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 5, 2018 at 12:36 AM, Qu Wenruo <wqu@suse.com> wrote:
> [BUG]
> Btrfs can easily create compressed extent without checksum (even
> though it shouldn't), and if we then try to replace device containing
> such extent, the result device will contain all the uncompressed data
> instead of the compressed one.
>
> Test case already submitted to fstests:
> https://patchwork.kernel.org/patch/10442353/
>
> [CAUSE]
> When handling compressed extent without checksum, device replace will
> goes into copy_nocow_pages() function.
>
> In that function, btrfs will get all inodes referring to this data
> extents and then use find_or_create_page() to get pages direct from that
> inode.
>
> The problem here is, pages directly from inode are always uncompressed.
> And for compressed data extent, they mismatch with on-disk data.
> Thus this leads to corrupted compressed data extent written to replace
> device.
>
> [FIX]
> In this attempt, we could just remove the "optimization" branch, and let
> unified scrub_pages() to handle it.
>
> Although scrub_pages() won't bother reusing page cache, it will be a
> little slower, but it does the correct csum checking and won't cause
> such data corruption cause by "optimization".
>
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: James Harvey <jamespharvey20@gmail.com>



As expected, this fixes the problem.

I originally ran into this running btrfs replace on devid 1, on a 3
device RAID1.

I temporarily restored dd images of devid 2 & 3, from before I ran the
original replace.  I was able to run "btrfs replace" with a btrfs
module loaded with this patch.

There's definitely no corruption.  I excessively checked, multiple ways.

I haven't tried with the previous RFC patch since it looks like this
one is getting used instead, but if requested to, I'd try that one.
