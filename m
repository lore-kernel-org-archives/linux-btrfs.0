Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41334 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXln (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 18:41:43 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so2209046oag.36
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 15:41:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130206184621.GP14246@lenny.home.zabbo.net>
References: <1360167017-19632-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20130206184621.GP14246@lenny.home.zabbo.net>
Date: Wed, 6 Feb 2013 17:41:42 -0600
Message-ID: <CAKcLGm-D18+J0fAm+rXU7-424PODP023KxrBOs_YMGF4B1+KWg@mail.gmail.com>
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be modified.
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 6, 2013 at 12:46 PM, Zach Brown <zab@redhat.com> wrote:
>> +     unsigned compressed_extent_size;
>
> It kind of jumps out that this mentions neither that it's the max nor
> that it's in KB.  How about max_compressed_extent_kb?
>
>> +     fs_info->compressed_extent_size = 128;
>
> I'd put a DEFAULT_MAX_EXTENTS up by the MAX_ definition instead of using
> a raw 128 here.
>
>> +     unsigned long max_compressed = root->fs_info->compressed_extent_size * 1024;
>> +     unsigned long max_uncompressed = root->fs_info->compressed_extent_size * 1024;
>
> (so max_compressed is in bytes)
>
>>       nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
>> -     nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
>> +     nr_pages = min(nr_pages, (max_compressed * 1024UL) / PAGE_CACHE_SIZE);
>
> (and now that expression adds another * 1024, allowing {128,512}MB
> extents :))
>

Yuk!  I'm surprised this never manifested as a problem during testing.

>>        * We also want to make sure the amount of IO required to do
>>        * a random read is reasonably small, so we limit the size of
>> -      * a compressed extent to 128k.
>> +      * a compressed extent (default of 128k).
>
> Just drop the value so that this comment doesn't need to be updated
> again.
>
> -        * a compressed extent to 128k.
> +        * a compressed extent.
>
>> +     {Opt_compr_extent_size, "compressed_extent_size=%d"},
>
> It's even more important to make the exposed option self-documenting
> than it was to get the fs_info member right.
>
>> +                     if ((intarg == 128) || (intarg == 512)) {
>> +                             info->compressed_extent_size = intarg;
>> +                             printk(KERN_INFO "btrfs: compressed extent size %d\n",
>> +                                    info->compressed_extent_size);
>> +                     } else {
>> +                             printk(KERN_INFO "btrfs: "
>> +                                     "Invalid compressed extent size,"
>> +                                     " using default.\n");
>
> I'd print the default value when it's used and would include a unit in
> both.
>
>> +     if (btrfs_test_opt(root, COMPR_EXTENT_SIZE))
>> +             seq_printf(seq, ",compressed_extent_size=%d",
>> +                        (unsigned long long)info->compressed_extent_size);
>
> The (ull) cast doesn't match the %d format and wouldn't be needed if it
> was printed with %u.
>
> - z

Thanks for the review.

All these comments make sense, and I should be able to work them in.
