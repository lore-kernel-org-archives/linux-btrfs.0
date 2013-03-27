Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36926 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3C0Vdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:33:32 -0400
Received: by mail-ob0-f174.google.com with SMTP id 16so8647499obc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 14:33:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327212255.GF17613@merlins.org>
References: <20130327165309.GA23559@merlins.org>
	<CAKcLGm98D1H4oMnN8+Sc8tbC8dCh=gwUQL9vw7M1pmQOn78Epw@mail.gmail.com>
	<20130327212255.GF17613@merlins.org>
Date: Wed, 27 Mar 2013 16:33:31 -0500
Message-ID: <CAKcLGm_h2Ae0dhcq6DfW_pkPnQxFGPwkkydsqANb8Dnx-vnCvA@mail.gmail.com>
Subject: Re: zlib vs lzo uncompress speed, ssd vs nossd
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 4:22 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Mar 27, 2013 at 04:12:27PM -0500, Mitch Harder wrote:
>> On Wed, Mar 27, 2013 at 11:53 AM, Marc MERLIN <marc@merlins.org> wrote:
>> >
>> > Is my feeling of slower boot wrong, or is zlib also noticeably slower than
>> > lzo to read and decompress?
>> >
>>
>> Lzo compression should be faster in every aspect than zlib, especially
>> for reading.
>>
>> But having said that, btrfs won't recompress any existing files just
>> because you switch your mount option from lzo to zlib.  Only newly
>> written files will be zlib, and btrfs will leave the lzo-compressed
>> files alone unless they are re-written, or you expressly recompress
>> them using the defrag tool.
>
> That was my intent at the time, I thought that zlib decompression was about
> as fast as lzo, so it would have been good that most my files stayed
> compressed as zlib.
> Turns out I was wrong :)
>
>> If you were to take a snapshot of your root partition, and reboot to
>> the snapshot as the new root with zlib compression, you could make
>> some side-by-side comparisons of boot time to clarify your
>> impressions.
>
> Fair point. By that, you mean degrag all my files somehow (recompressing as
> lzo, and doubling the size of my rootfs)?
>
> Also, I was re-reading ssd vs nossd:
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> isn't clear whether these are read/write ordering optimizations, or
> filesystem layout optimization (i.e. you'd have to recreate the entire FS,
> and rewrite everything).
>
> http://www.phoronix.com/scan.php?page=article&item=btrfs_ssd_mode&num=1
> says 'However, unless disabling the write cache for the drive, the SSD mode
> does not necessarily mean better performance. In fact, as our results are
> about to show, the quantitative disk performance can drop greatly in the SSD
> mode when the write cache remains enabled'
> But that's from 2009, so not very relevant to today.
>
> Do you happen to know more than me on this?
>

I'm sorry, I have no experience with the ssd mount option.
