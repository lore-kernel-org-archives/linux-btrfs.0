Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32776 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753659AbdAKK3a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 05:29:30 -0500
Received: by mail-oi0-f41.google.com with SMTP id w204so83229317oiw.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 02:29:30 -0800 (PST)
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jan 2017 11:29:28 +0100
Message-ID: <CAJfpegv9EhT4Y3QjTZBHoMKSiVGtfmTGPhJp_rh3a7=rFCHu5A@mail.gmail.com>
Subject: [LSF/MM TOPIC] sharing pages between mappings
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know there's work on this for xfs, but could this be done in generic mm code?

What are the obstacles?  page->mapping and page->index are the obvious ones.

If that's too difficult is it maybe enough to share mappings between
files while they are completely identical and clone the mapping when
necessary?

All COW filesystems would benefit, as well as layered ones: lots of
fuse fs, and in some cases overlayfs too.

Related:  what can DAX do in the presence of cloned block?

Thanks,
Miklos
