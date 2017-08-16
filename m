Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:41890 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751843AbdHPMAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 08:00:06 -0400
Date: Wed, 16 Aug 2017 17:00:03 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
Subject: Re: slow btrfs with a single kworker process using 100% CPU
Message-ID: <20170816170003.3f47321d@natsu>
In-Reply-To: <18522132.418.1502884115575.JavaMail.gkos@dynomob>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
        <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
        <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
        <4669553.344.1502874134710.JavaMail.gkos@dynomob>
        <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
        <18522132.418.1502884115575.JavaMail.gkos@dynomob>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Aug 2017 12:48:42 +0100 (BST)
"Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com> wrote:

> I believe the chunk size of 512kb is even worth for performance then the default settings on my HW RAID of  256kb.

It might be, but that does not explain the original problem reported at all.
If mdraid performance would be the bottleneck, you would see high iowait,
possibly some CPU load from the mdX_raidY threads. But not a single Btrfs
thread pegging into 100% CPU.

> So now I am moving the data from the array and will be rebuilding it with 64
> or 32 chunk size and checking the performance.

64K is the sweet spot for RAID5/6:
http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html

-- 
With respect,
Roman
