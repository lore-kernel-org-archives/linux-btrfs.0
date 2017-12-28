Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40587 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdL1LP6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:15:58 -0500
Received: by mail-wm0-f66.google.com with SMTP id f206so43219417wmf.5
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 03:15:57 -0800 (PST)
Subject: Re: btrfs balance problems
To: James Courtier-Dutton <james.dutton@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <e3629f7d-3278-bb11-d416-43e290c67e2a@gmail.com>
Date: Thu, 28 Dec 2017 13:15:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.12.2017 13:19, James Courtier-Dutton wrote:
> Hi,
> 
> During a btrfs balance, the process hogs all CPU.
> Or, to be exact, any other program that wishes to use the SSD during a
> btrfs balance is blocked for long periods. Long periods being more
> than 5 seconds.
> Is there any way to multiplex SSD access while btrfs balance is
> operating, so that other applications can still access the SSD with
> relatively low latency?
> 
> My guess is that btrfs is doing a transaction with a large number of
> SSD blocks at a time, and thus blocking other applications.
> 
> This makes for atrocious user interactivity as well as applications
> failing because they cannot access the disk in a relatively low latent
> manner.
> For, example, this is causing a High Definition network CCTV
> application to fail.
> 
> What I would really like, is for some way to limit SSD bandwidths to
> applications.
> For example the CCTV app always gets the bandwidth it needs, and all
> other applications can still access the SSD, but are rate limited.
> This would fix my particular problem.
> We have rate limiting for network applications, why not disk access also?

So how are you running btrfs balance? Are you using any filters
whatsoever? The documentation
[https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-balance] has the
following warning:

Warning: running balance without filters will take a lot of time as it
basically rewrites the entire filesystem and needs to update all block
pointers.


> 
> Kind Regards
> 
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
