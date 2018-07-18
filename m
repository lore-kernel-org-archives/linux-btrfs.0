Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f173.google.com ([209.85.208.173]:36041 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbeGRNpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:45:52 -0400
Received: by mail-lj1-f173.google.com with SMTP id u7-v6so4039814lji.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 06:08:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz> <2197534.TZSffJRfLT@merkaba>
 <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com> <1736761.B5nO4FXixV@merkaba> <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jul 2018 07:07:57 -0600
Message-ID: <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
Subject: Re: Healthy amount of free space?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 6:35 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> If you're doing a training presentation, it may be worth mentioning that
> preallocation with fallocate() does not behave the same on BTRFS as it does
> on other filesystems.  For example, the following sequence of commands:
>
>     fallocate -l X ./tmp
>     dd if=/dev/zero of=./tmp bs=1 count=X
>
> Will always work on ext4, XFS, and most other filesystems, for any value of
> X between zero and just below the total amount of free space on the
> filesystem.  On BTRFS though, it will reliably fail with ENOSPC for values
> of X that are greater than _half_ of the total amount of free space on the
> filesystem (actually, greater than just short of half).  In essence,
> preallocating space does not prevent COW semantics for the first write
> unless the file is marked NOCOW.

Is this a bug, or is it suboptimal behavior, or is it intentional?

And then I wonder what happens with XFS COW:

     fallocate -l X ./tmp
     cp --reflink ./tmp ./tmp2
     dd if=/dev/zero of=./tmp bs=1 count=X



-- 
Chris Murphy
