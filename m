Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48755 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeDSHMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:12:39 -0400
Subject: Re: nvme+btrfs+compression sensibility and benchmark
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
 <f336feb1-5da4-6d08-53f5-0a591253218b@gmail.com>
 <CAJCQCtQc3QQmwhVcBgNKChVyMhaMtKwa9vAYDpcPHCQ4Fsw62Q@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8afc6157-29cf-00f1-460d-318ad655e3ad@suse.com>
Date: Thu, 19 Apr 2018 10:12:36 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQc3QQmwhVcBgNKChVyMhaMtKwa9vAYDpcPHCQ4Fsw62Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.04.2018 22:24, Chris Murphy wrote:
> On Wed, Apr 18, 2018 at 10:38 AM, Austin S. Hemmelgarn <ahferroin7@gmail.com
>> wrote:
> 
>> For reference, the zstd compression in BTRFS uses level 3 by default (as
>> does zlib compression IIRC), though I'm not sure about lzop (I think it
>> uses the lowest compression setting).
>>
> 
> 
> The user space tool, zstd, does default to 3, according to its man page.
> 
>        -#     # compression level [1-19] (default: 3)
> 
> 
> However, the kernel is claiming it's level 0, which doesn't exist in the
> man page. So I have no idea what we're using. This is what I get with mount
> option compress=zstd
> 

Currently the kernel-mode zstd compression doesn't really support any
levels (compress_level is not set, even if it's passed, and even then
zstd_set_level is also unimplemented). So this number doesn't really
make any difference.

> [    4.097858] BTRFS info (device nvme0n1p9): use zstd compression, level 0
> 
> 
> 
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
