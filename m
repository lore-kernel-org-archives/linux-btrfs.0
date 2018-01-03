Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback14.m.smailru.net ([94.100.179.44]:38528 "EHLO
        fallback.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751214AbeACKML (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 05:12:11 -0500
Received: from [10.161.64.40] (port=51044 helo=smtp32.i.mail.ru)
        by fallback14.m.smailru.net with esmtp (envelope-from <dma_k@mail.ru>)
        id 1eWg1o-0007Gi-GQ
        for linux-btrfs@vger.kernel.org; Wed, 03 Jan 2018 13:12:08 +0300
Received: by smtp32.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
        id 1eWg1m-0002Sl-Fs
        for linux-btrfs@vger.kernel.org; Wed, 03 Jan 2018 13:12:06 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by centurion.home (Postfix) with ESMTPSA id AA4D5C8A99A
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Jan 2018 11:12:04 +0100 (CET)
Subject: Re: Kernel crash during btrfs scrub
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
 <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <b5487ea9-59c9-0aa1-a717-dbf78f14f515@mail.ru>
Date: Wed, 3 Jan 2018 11:14:02 +0100
MIME-Version: 1.0
In-Reply-To: <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-03 05:58, Qu Wenruo wrote:
> On 2018年01月03日 09:12, Dmitry Katsubo wrote:
>> Dear btrfs team,
>>
>> I send a kernel crash report which I have observed recently during btrfs scrub.
>> It looks like scrub itself has completed without errors.
> 
> It's not a kernel crash (if I didn't miss anything), but just kernel
> warning.
> 
> The warning is caused by the fact that your fs (mostly created by old
> mkfs.btrfs) has device with unaligned size.
> 
> You could either resize the device down a little (e.g. -4K) and newer
> kernel (the one you're using should be new enough) could handle it well.
> 
> Or you could update your btrfs-progs (I assume you're using Arch, which
> is already shipping btrfs-progs v4.14) and use "btrfs rescue
> fix-device-size" to fix other device related problems offline.
> (Not only the warning, but also potential superblock size mismatch)
> 
> Thanks,
> Qu

Thanks for reply!

Why couldn't a warning message be issued as one-liner, e.g. with proper
description and without scaring stack trace?

btrfs /dev/sda1 warning: device size is not aligned with FS (mostly created by old mkfs.btrfs), see https://btrfs.wiki.kernel.org/index.php/FAQ#...

-- 
With best regards,
Dmitry
