Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3IEPpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 11:45:25 -0400
Message-ID: <5228A713.6060003@redhat.com>
Date: Thu, 05 Sep 2013 10:45:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on /dev/sdb1
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
In-Reply-To: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/5/13 9:43 AM, Тимофей Титовец wrote:
> Hello guys, i try to convert ext4 volume, but btrfs-convert show me error:
> "No valid Btrfs found on file
> unable to open ctree
> conversion aborted."
> Ubuntu 13.04
> Kernel: 3.11
> btrfs-progs git version 0.20-git20130822~194aa4a13
> 
> way to reproduce error:
> $ truncate -s 4G file
> $ mkfs.ext4 file #say yes to create fs on non block device.
> $ btrfs-convert file
>  No valid Btrfs found on file
>  unable to open ctree
>  conversion aborted.

This was a regression around July 3; there was no regression test at
the time.

[615f2867854c186a37cb2e2e5a2e13e9ed4ab0df] Btrfs-progs: cleanup similar code in open_ctree_* and close_ctree

broke it.

Patches were sent to the list to fix it on July 17,

https://patchwork.kernel.org/patch/2828820/

but they haven't been merged into the main repo.

I sent a regression test for it to the list on Aug 4, but nobody
reviewed it, so it hasn't been merged into the test suite, either.

Winning all around!

-Eric
