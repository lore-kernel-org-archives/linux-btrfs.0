Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48826 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1035207AbcIWOpL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 10:45:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bnRip-0005jT-Dt
        for linux-btrfs@vger.kernel.org; Fri, 23 Sep 2016 16:45:03 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v2 3/6] Btrfs: catch invalid free space trees
Date: Fri, 23 Sep 2016 14:40:13 +0000 (UTC)
Message-ID: <pan$5a8e4$74da6751$781c9840$92689a17@applied-asynchrony.com>
References: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
        <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 Sep 2016 17:24:22 -0700, Omar Sandoval wrote:

> From: Omar Sandoval <osandov@fb.com>
> 
> There are two separate issues that can lead to corrupted free space
> trees.
> 
> 1. The free space tree bitmaps had an endianness issue on big-endian
>    systems which is fixed by an earlier patch in this series.
> 2. btrfs-progs before v4.7.3 modified filesystems without updating the
>    free space tree.
> 
> To catch both of these issues at once, we need to force the free space
> tree to be rebuilt. To do so, add a FREE_SPACE_TREE_VALID compat_ro bit.
> If the bit isn't set, we know that it was either produced by a broken
> big-endian kernel or may have been corrupted by btrfs-progs.
> 
> This also provides us with a way to add rudimentary read-write support
> for the free space tree to btrfs-progs: it can just clear this bit and
> have the kernel rebuild the free space tree.
> 
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Initial mount with this successfully detected the absent _VALID bit;
fst was rebuilt, subsequent mounts are good without rebuild. \o/

Thanks!
Holger

