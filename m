Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36035 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758926AbcH3S2n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 14:28:43 -0400
Received: by mail-oi0-f68.google.com with SMTP id b22so2554100oii.3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 11:28:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQddXz26cjp=tGcO5d5E9N=Zmjdd=qwonjGdh+NJ7aLQQ@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
 <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
 <CA+WRLO8XVaK5FK9VUt=pOgoyqYm30_yxTnCd+5zdYx5Xx6jAcw@mail.gmail.com>
 <CA+WRLO-cvepjj53xCoq=RiEmTV-6cqL+G6nQe+WnTPyWNDOUZA@mail.gmail.com>
 <CA+WRLO-1oJLZ56EivVTg=bycNhfpOt8ovLrLbgnNeCVKgvbxhQ@mail.gmail.com> <CAJCQCtQddXz26cjp=tGcO5d5E9N=Zmjdd=qwonjGdh+NJ7aLQQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 30 Aug 2016 12:28:36 -0600
Message-ID: <CAJCQCtRGpAgGq9dpv432ES9OUHG4fDkt+DviapaCyg0Jtc2gVA@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Chris Murphy <lists@colorremedies.com>
Cc: Gareth Pye <gareth@cerberos.id.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 12:04 PM, Chris Murphy <lists@colorremedies.com> wrote:

> One of us would have to go look in source to see what causes "[
> 163.612313] BTRFS: failed to read the system array on sdd" to appear

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/disk-io.c?id=refs/tags/v4.7.2
line 2864

And btrfs_read_sys_array is found here on 6587. So
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/volumes.c?id=refs/tags/v4.7.2

And then comparing your 4.4.13 to 4.7.2....
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/fs/btrfs/disk-io.c?id=v4.7.2&id2=v4.4.13

There are changes in these areas but looks like they're mainly
printk's becoming btrfs_err. But I'd try a newer kernel before you
give up on it.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/fs/btrfs/volumes.c?id=v4.7.2&id2=v4.4.13
More changes here too.

I suggest using btrfs-progs 4.5.3 or 4.6.1. You could also try 4.7 but
I'm getting some weird unexplained errors that only progs 4.7
complains about (clean scrubs, clean mounts, completely working file
system, but a buncha backref complaints from 4.7's btrfs check). But I
think the super-recover -v output should be reliable with any version
in the last ~year.

-- 
Chris Murphy
