Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56259 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbcIOO4M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 10:56:12 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: stability matrix
Date: Thu, 15 Sep 2016 16:56:08 +0200
Message-ID: <2744649.NKL5C81YJK@merkaba>
In-Reply-To: <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
References: <57D51BF9.2010907@online.no> <c58cd350-a1e8-7d1c-cf8c-84f7f0c05682@mendix.com> <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 15. September 2016, 07:54:26 CEST schrieb Austin S. Hemmelgarn:
> On 2016-09-15 05:49, Hans van Kranenburg wrote:
> > On 09/15/2016 04:14 AM, Christoph Anton Mitterer wrote:
[…]
> I specifically do not think we should worry about distro kernels though.
>   If someone is using a specific distro, that distro's documentation
> should cover what they support and what works and what doesn't.  Some
> (like Arch and to a lesser extent Gentoo) use almost upstream kernels,
> so there's very little point in tracking them.  Some (like Ubuntu and
> Debian) use almost upstream LTS kernels, so there's little point
> tracking them either.  Many others though (like CentOS, RHEL, and OEL)
> Use forked kernels that have so many back-ported patches that it's
> impossible to track up-date to up-date what the hell they've got.  A
> rather ridiculous expression regarding herding of cats comes to mind
> with respect to the last group.

Yep. I just read through RHEL releasenotes for a RHEL 7 workshop I will hold 
for a customer… and noted that newer RHEL 7 kernels for example have device 
mapper from Kernel 4.1 (while the kernel still says its a 3.10 one), XFS from 
kernel this.that, including new incompat CRC disk format and the need to also 
upgrade xfsprogs in lockstep, and this and that from kernel this.that and so 
on. Frankenstein as an association comes to my mind, but I bet RHEL kernel 
engineers know what they are doing.

-- 
Martin
