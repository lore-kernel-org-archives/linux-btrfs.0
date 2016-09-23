Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38196 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbcIWOiH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 10:38:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bnRc2-00009I-QH
        for linux-btrfs@vger.kernel.org; Fri, 23 Sep 2016 16:38:02 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v2 1/6] Btrfs: fix free space tree bitmaps on big-endian
 systems
Date: Fri, 23 Sep 2016 14:37:37 +0000 (UTC)
Message-ID: <pan$b884a$ad0261ee$19144467$83757925@applied-asynchrony.com>
References: <cover.1474580472.git.osandov@fb.com>
        <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 Sep 2016 17:24:20 -0700, Omar Sandoval wrote:

> From: Omar Sandoval <osandov@fb.com>
> 
> In convert_free_space_to_{bitmaps,extents}(), we buffer the free space
> bitmaps in memory and copy them directly to/from the extent buffers with
> {read,write}_extent_buffer(). The extent buffer bitmap helpers use byte
> granularity, which is equivalent to a little-endian bitmap. This means
> that on big-endian systems, the in-memory bitmaps will be written to
> disk byte-swapped. To fix this, use byte-granularity for the bitmaps in
> memory.
> 
> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
(only for regressions on little-endian x86-64)

Thanks!
Holger

