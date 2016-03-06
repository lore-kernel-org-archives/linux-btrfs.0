Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37367 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcCFVHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 16:07:51 -0500
Received: by mail-ig0-f172.google.com with SMTP id z8so27353708ige.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 13:07:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nXei2FszQz_-HoeOi04vhWw9YF3LKwd+2zRxmW1Wiupw@mail.gmail.com>
References: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
	<20160301162758.GA27786@carfax.org.uk>
	<CAGfcS_nXei2FszQz_-HoeOi04vhWw9YF3LKwd+2zRxmW1Wiupw@mail.gmail.com>
Date: Sun, 6 Mar 2016 14:07:50 -0700
Message-ID: <CAJCQCtRonySo0VqUeWtqG2Eu9N3VxL9LHmEgnpRQVu2tOaJqOw@mail.gmail.com>
Subject: Re: btrfs raid
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 6, 2016 at 5:01 AM, Rich Freeman <rich0@gentoo.org> wrote:

> I think it depends on how you define "old."  I think that 3.18.28
> would be fine as it is a supported longterm.

For raid56? I disagree. There were substantial raid56 code changes in
3.19 that were not backported to 3.18.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/fs/btrfs/raid56.c?id=v3.19&id2=v3.18.28

There's just no way I'd recommend it, not worth it at all.

Anyone using Btrfs raid56 is still a test subject. I'd only use
current longterm, with the high expectation I'd use current stable or
even mainline if a problem arises before going to the list. If you
can't do any of this, then it's a waste of your time, and you're
better off looking at ZFS on Linux.

Look at the number of changes between 4.1.19 and 4.4.4, just for
extent-tree.c - there's over 1200 changes.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/fs/btrfs/extent-tree.c?id=v4.4.4&id2=v4.1.19

And 4.1.19 doesn't have the dev replace code for raid56. While that's
more feature than bug fix, there are piles of bug fixes between even
the current 4.1.19 and 4.4.4 kernels.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/fs/btrfs/raid56.c?id=v4.4.4&id2=v4.1.19

Things are certainly getting more stable enough that if your chances
of hitting an edge case are remote, you can get away with using older
kernels. But that's the thing, you don't know if you're hitting an
edge case in advance most of the time. If it's just a file server
using Samba, that's a docile use case than as root fs, let alone if
snapshots are being taken regularly. Every feature of Btrfs being used
adds on to the unknown factor.


-- 
Chris Murphy
