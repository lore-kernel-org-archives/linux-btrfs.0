Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:32904 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaB1Hqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 02:46:37 -0500
Received: by mail-pa0-f68.google.com with SMTP id kq14so202676pab.11
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 23:46:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$49c16$7a7687d1$aadeeb14$c250e08e@cox.net>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<20140228103436.2dfd2669@natsu>
	<pan$49c16$7a7687d1$aadeeb14$c250e08e@cox.net>
Date: Fri, 28 Feb 2014 01:46:36 -0600
Message-ID: <CAAmRLYxvX-MjPEnphu_0RQXs2ZHtGSxa01x2XzwD_TXKqHGovA@mail.gmail.com>
Subject: Re: Help with space
From: Justin Brown <otakujunction@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Absolutely.  I'd like to know the answer to this, as 13 tera will take
a considerable amount of time to back up anywhere, assuming I find a
place.  I'm considering rebuilding a smaller raid with newer drives
(it was originally built using 16 250 gig western digital drives, it's
about eleven years old now, having been in use the entire time without
failure, I'm considering replacing each 250 gig with a 3 tera
alternative).  Unfortunately, between upgrading the host and building
a new raid the expense isn't something I'm anticipating with
pleasure...

On Fri, Feb 28, 2014 at 1:27 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Roman Mamedov posted on Fri, 28 Feb 2014 10:34:36 +0600 as excerpted:
>
>> But then as others mentioned it may be risky to use this FS on 32-bit at
>> all, so I'd suggest trying anything else only after you reboot into a
>> 64-bit kernel.
>
> Based on what I've read on-list, btrfs is not arch-agnostic, with certain
> on-disk sizes set to native kernel page size, etc, so a filesystem
> created on one arch may well not work on another.
>
> Question: Does this apply to x86/amd64?  Will a filesystem created/used
> on 32-bit x86 even mount/work on 64-bit amd64/x86_64, or does upgrading
> to 64-bit imply backing up (in this case) double-digit TiB of data to
> something other than btrfs and testing it, doing a mkfs on the original
> filesystem once in 64-bit mode, and restoring all that data from backup?
>
> If the existing 32-bit x86 btrfs can't be used on 64-bit amd64,
> transferring all that data (assuming there's something big enough
> available to transfer it to!) to backup and then restoring it is going to
> hurt!
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
