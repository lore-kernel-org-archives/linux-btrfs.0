Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from antelope.ash.relay.mailchannels.net ([23.83.222.4]:56683 "EHLO
        antelope.ash.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752245AbeDRUGa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 16:06:30 -0400
Subject: Re: nvme+btrfs+compression sensibility and benchmark
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
 <f336feb1-5da4-6d08-53f5-0a591253218b@gmail.com>
 <CAJCQCtSBs9nJXi2CZuBsgegCoN0J5K1BDWGPqD5K9z_G6pOPsg@mail.gmail.com>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <298d6590-c611-bfad-76a3-1c20d39eb718@swiftspirit.co.za>
Date: Wed, 18 Apr 2018 21:56:34 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSBs9nJXi2CZuBsgegCoN0J5K1BDWGPqD5K9z_G6pOPsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you, all

Though the info is useful, there's not a clear consensus on what I 
should expect. For interest's sake, I'll post benchmarks from the device 
itself when it arrives.

I'm expecting at least that I'll be blown away :)

On 04/18/2018 09:23 PM, Chris Murphy wrote:
> 
> 
> On Wed, Apr 18, 2018 at 10:38 AM, Austin S. Hemmelgarn 
> <ahferroin7@gmail.com <mailto:ahferroin7@gmail.com>> wrote:
> 
>     For reference, the zstd compression in BTRFS uses level 3 by default
>     (as does zlib compression IIRC), though I'm not sure about lzop (I
>     think it uses the lowest compression setting).
> 
> 
> 
> The user space tool, zstd, does default to 3, according to its man page.
> 
>         -#     # compression level [1-19] (default: 3)
> 
> 
> However, the kernel is claiming it's level 0, which doesn't exist in the 
> man page. So I have no idea what we're using. This is what I get with 
> mount option compress=zstd
> 
> [    4.097858] BTRFS info (device nvme0n1p9): use zstd compression, level 0
> 
> 
> 
> 
> -- 
> Chris Murphy
