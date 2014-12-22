Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47943 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaLVR1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 12:27:25 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so6261400pab.35
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 09:27:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54982A79.1090102@gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
Date: Mon, 22 Dec 2014 09:27:24 -0800
Message-ID: <CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 6:28 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-12-19 21:07, Richard Sharpe wrote:
>>
>> Hi folks,
>>
>> I need a Linux file system that supports XATTRs up to 64K.
>>
>> Can BTRFS support that or is XFS the only Linux file system with such
>> support?
>>
> At the moment, BTRFS is limited to xattrs that fit inline in the metadata
> nodes (so ~3900 bytes for a 4k leafsize).
>
> XFS, however, isn't the only Linux filesystem that supports xattrs that
> size.  Assuming that you are using a recent kernel, you can also use such
> xattrs on at least:
>  * XFS
>  * JFS
>  * ext4
>  * reiserfs (I think, not 100% certain about this one though)
>  * OCFS2 (even though it is technically a cluster fs, it can be run single
> node without the clustering)
>  * ZFS (IIRC, ZFS supports unlimited xattr size)
>  * NTFS (no limit on xattr size, though you should use NTFS-3G instead of
> the in-kernel driver)
>  * SquashFS (read-only)
>  * HFS+ (Also no limit on xattr size)
> Of these, I'd personally suggest using XFS unless you need to be able to
> shrink the filesystem, in which case I'd suggest ext4.

Thanks for the info. I hadn't realized that ext4 had lifted the restriction.

-- 
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)
