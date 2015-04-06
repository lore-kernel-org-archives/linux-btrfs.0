Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luna.xtsubasa.org ([128.199.32.223]:50503 "EHLO
	luna.xtsubasa.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbDFHqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 03:46:23 -0400
From: Pavel Volkov <sailor@lists.xtsubasa.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Russell Coker <russell@coker.com.au>, Duncan <1i5t5.duncan@cox.net>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs hangs 3.19-10
Date: Mon, 06 Apr 2015 10:40:03 +0300
MIME-Version: 1.0
Message-ID: <2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
In-Reply-To: <20150405100417.GE13864@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
 <20150404130047.GC13864@carfax.org.uk>
 <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
 <201504050330.47299.russell@coker.com.au>
 <20150405100417.GE13864@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, April 5, 2015 1:04:17 PM MSK, Hugo Mills wrote:
>    That's these, I think:
>
> #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
> #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)
>
> so it's definitely -O^extref. I don't see where big_metadata comes
> from, though. That's not a -O option. Try with -O^extref and see where
> that gets you. (Also, don't mount the FS on a newer kernel -- it may
> be setting big metadata automatically, although it probably shouldn't
> do).

By the way, is there any way to see which options are enabled on a local 
filesystem without having to try mounting it with old kernel and checking 
dmesg?
