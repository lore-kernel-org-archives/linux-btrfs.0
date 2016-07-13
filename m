Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34061 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbcGMPDp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 11:03:45 -0400
MIME-Version: 1.0
In-Reply-To: <e6dc753c434a6570251d68d4233d05e6fa84ac67.1468365157.git.osandov@fb.com>
References: <e6dc753c434a6570251d68d4233d05e6fa84ac67.1468365157.git.osandov@fb.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Wed, 13 Jul 2016 18:03:35 +0300
Message-ID: <CADxRZqyJoD8b7OJTnqEdpwzfmAGuqKFZaUJUQ5EewTowXALqLw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix extent buffer bitmap tests on big-endian systems
To: Omar Sandoval <osandov@osandov.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>, sparclinux@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 13, 2016 at 2:21 AM, Omar Sandoval <osandov@osandov.com> wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> The in-memory bitmap code manipulates words and is therefore sensitive
> to endianness, while the extent buffer bitmap code addresses bytes and
> is byte-order agnostic. Because the byte addressing of the extent buffer
> bitmaps is equivalent to a little-endian in-memory bitmap, the extent
> buffer bitmap tests fail on big-endian systems.
>
> 34b3e6c92af1 ("Btrfs: self-tests: Fix extent buffer bitmap test fail on
> BE system") worked around another endianness bug in the tests but missed
> this one because ed9e4afdb055 ("Btrfs: self-tests: Execute page
> straddling test only when nodesize < PAGE_SIZE") disables this part of
> the test on ppc64. That change lost the original meaning of the test,
> however. We really want to test that an equivalent series of operations
> using the in-memory bitmap API and the extent buffer bitmap API produces
> equivalent results.
>
> To fix this, don't use memcmp_extent_buffer() or write_extent_buffer();
> do everything bit-by-bit.


Just tested patched kernel, able to load btrfs module and mount fs.
Thanks a lot!
