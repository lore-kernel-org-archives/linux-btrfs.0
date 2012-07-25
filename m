Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2GYEp3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 00:45:29 -0400
Received: by pbbrp8 with SMTP id rp8so771017pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 21:45:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-rXZ7FvjpUbC7F8x2Dqr0j=YnZ5OtTvXbc_uBoXR92OA@mail.gmail.com>
References: <CA+WRLO-rXZ7FvjpUbC7F8x2Dqr0j=YnZ5OtTvXbc_uBoXR92OA@mail.gmail.com>
Date: Wed, 25 Jul 2012 11:45:29 +0700
Message-ID: <CAG1y0sfSnebyE01uG9V3MP3YZAKtcrVg8FwZfbsGdpXQAVikLQ@mail.gmail.com>
Subject: Re: Upgrading from 2.6.38, how?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2012 at 11:39 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> My proposed upgrade method is:
> Boot from a live CD with the latest kernel I can find so I can do a few tests:
>  A - run the fsck in read only mode to confirm things look good
>  B - mount read only, confirm that I can read files well
>  C - mount read write, confirm working
> Install latest OS, upgrade to latest kernel, then repeat above steps.
>
> Any likely hiccups with the above procedure and suggested alternatives?

I'd simply install the new OS on a new partition/subvol. This is what
I did when upgrading from natty -> oneiric -> precise.

IIRC there are some incompatibilites (e.g. space/inode cache disk
format?) but newer kernels will just do the right thing, drop the old
cache and create a new one.

-- 
Fajar
