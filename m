Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34917 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbbH0Rx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:53:29 -0400
Received: by vkfi73 with SMTP id i73so13078130vkf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 10:53:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150827173229.GA30068@lo.psyced.org>
References: <20150827173229.GA30068@lo.psyced.org>
Date: Thu, 27 Aug 2015 11:53:28 -0600
Message-ID: <CAJCQCtQx+L1JauS=cC1crPQDpOO+t5SqHAg8Z8Q6K5KPKPW6TQ@mail.gmail.com>
Subject: Re: Impossible to mount two different copies of the same btrfs
From: Chris Murphy <lists@colorremedies.com>
To: carlo von lynX <lynX@time.to.get.psyced.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 11:32 AM, carlo von lynX
<lynX@time.to.get.psyced.org> wrote:
> Hi there. Excuse me if I didn't subscribe the list. Just wanted to
> let you know of this behavior assuming you haven't noticed it yet.
>
> When mounting two copies of the same file system from two different
> hard disks with the intention of syncing the older with the newer
> one, btrfs behaves differently from ext4: it will mount the first
> one twice rather than mounting each. I assume it has something to
> do with all UUIDs being identical, which doesn't disturb ext4 though.

I'd say any file system that allows mount without warning when two fs
volumes with the same UUID is a bug. I vastly prefer the XFS behavior
in this regard which is warn and refusal to mount. You have to use -o
nouuid to make it happen; and then I guess there's some separate
handling to still keep the fs instances separate, but I don't know how
that works at all or how ext4 and Btrfs differ.


> This only happens with btrfs - I cannot mount two file systems that
> happen to have the same UUID (or are deemed identical by some other
> criterion I cannot determine). I presume this is not intended
> behavior. I tried relabeling one of the copies, but it didn't have
> any effect.

Nope, it really can't work. I haven't tried it but I suspect that with
XFS v5 that it's not possible either.

> Now I'm looking into ways to change the UUID.

This is in the current version of btrfs-progs with the btrfs-tune command.



-- 
Chris Murphy
