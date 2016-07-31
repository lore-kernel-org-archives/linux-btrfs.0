Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36808 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbcGaNFB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 09:05:01 -0400
Received: by mail-vk0-f67.google.com with SMTP id r135so4821150vkf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 06:05:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
References: <cover.1468538030.git.osandov@fb.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Sun, 31 Jul 2016 16:04:59 +0300
Message-ID: <CADxRZqzJr+XRB_rqfFcsyyMS7uJvYTRQw-J9VGjriMfA38aHdQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
To: Omar Sandoval <osandov@osandov.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 2:31 AM, Omar Sandoval <osandov@osandov.com> wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> So it turns out that the free space tree bitmap handling has always been
> broken on big-endian systems. Totally my bad.
>
> Patch 1 fixes this. Technically, it's a disk format change for
> big-endian systems, but it never could have worked before, so I won't go
> through the trouble of any incompat bits. If you've somehow been using
> space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> to want to mount with nospace_cache to clear it and wait for this to go
> in.
>
> Patch 2 fixes a similar error in the sanity tests (it's the same as the
> v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> oversight that patch 1 fixes.
>
> Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> pass on x86_64 and MIPS.

Omar,

can you please upstream this patch or update it for current git kernel ?
Thanks.
