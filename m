Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:35854 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756716AbdKQTDK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 14:03:10 -0500
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
 <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
 <20171116214551.vpp4eevs7b4bszjt@merlins.org>
 <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
 <20171117001256.GN10969@merlins.org> <20171117104148.04986eee@natsu>
 <20171117055315.7bmhthyqityiffwl@merlins.org>
 <20171117174826.fqks43rt4nyjxubj@merlins.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <baf31c30-cc64-c4aa-305e-04c6afff1fe0@applied-asynchrony.com>
Date: Fri, 17 Nov 2017 20:03:07 +0100
MIME-Version: 1.0
In-Reply-To: <20171117174826.fqks43rt4nyjxubj@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/17/17 18:48, Marc MERLIN wrote:
> On Thu, Nov 16, 2017 at 09:53:15PM -0800, Marc MERLIN wrote:
>>> I suggest that you try lvmcache instead. It's much more flexible than bcache,
>>> does pretty much the same job, and has much less of the "hacky" feel to it.
>>
>> I can read up on it, it's going to be a big pain to convert from one to
>> the other, but I can look at it for new filesystems.
> 
> I had a quick read. As expected, it's slower since it goes through all
> the LVM overhead that I got rid of recently
> https://github.com/stec-inc/EnhanceIO/wiki/PERFORMANCE-COMPARISON-AMONG-dm-cache,-bcache-and-EnhanceIO
> 
> Given the pain it would be for me to switch, I'm going to stick with
> bcache and hope it improves.

My understanding is that bcache until recently was more or less unmaintained,
but got quite a few patches for 4.14 and now has a new maintainer as well.
So things are looking up.

-h
