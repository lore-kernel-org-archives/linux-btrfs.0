Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61872 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3GAN22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 09:28:28 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so4916931oag.28
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 06:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
References: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
 <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
From: Roger Pack <rogerpack2005@gmail.com>
Date: Mon, 1 Jul 2013 07:27:58 -0600
Message-ID: <CADCGFBX-dp21ooqLXzvstU4gG5pSU=DU1mHbD3z=Ro2aWv0pDQ@mail.gmail.com>
Subject: Re: lz4 status?
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 11:35 AM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> There's been a parallel effort to incorporate a general set of lz4
> patches in the kernel.
>
> I see these patches are currently queued up in the linux-next tree, so
> we may see them in the 3.11 kernel.
>
> It looks like lz4 and lz4hc will be provided.
>
> So, instead of btrfs having it's own implementation of lz4, the
> patches will be re-worked around kernel's new lz4 library.

Sounds good, keep up the good work :)
roger
