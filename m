Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38242 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaLVUGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 15:06:41 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so6488895pab.35
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:06:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
Date: Mon, 22 Dec 2014 12:06:41 -0800
Message-ID: <CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 10:43 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Dec 22, 2014 at 11:09 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Personally, I'd love to see unlimited length xattr's like NTFS and HFS+ do,
>> as that would greatly improve interoperability (both Windows and OS X use
>> xattrs, although they call them 'alternative data streams' and 'forks'
>> respectively), and provide a higher likelihood that xattrs would start
>> getting used more.
>
> This is two years old, but it looks like NFS will not support xattr.
> http://comments.gmane.org/gmane.linux.nfs/53259
>
> It looks like SMB does support xattr (and sometimes requires it) but I
> have no idea to what degree, including the host/client preservation on
> different filesystems. [1] It would still be helpful for cp and rsync
> to be able to preserve xattr, however Apple has moved to a new on-disk
> format that makes the future of reading OS X volumes on Linux an open
> question. [2]

Those are the old OS 2 XATTRs, better known as EAs, and NTFS says that
you can support EAs or you can have Reparse Points, but not both
(basically, they re-used the EA Length field as the reparse tag).
Also, Windows (of any flavor) does not make it easy to access EAs.

-- 
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)
