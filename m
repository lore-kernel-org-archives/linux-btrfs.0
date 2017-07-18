Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:52106 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751613AbdGRSly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:41:54 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id 783D220318
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 18:41:53 +0000 (UTC)
Date: Tue, 18 Jul 2017 23:41:52 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: "detect-zeroes=unmap" support in Btrfs?
Message-ID: <20170718234152.2ff2f438@natsu>
In-Reply-To: <20170718165710.111ac97e@natsu>
References: <20170718165710.111ac97e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Jul 2017 16:57:10 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> if a block written consists of zeroes entirely, instead of writing zeroes to
> the backing storage, converts that into an "unmap" operation
> (FALLOC_FL_PUNCH_HOLE[1]).

BTW I found that it is very easy to "offline" process preexisting files for
this, using "fallocate -d".

       -d, --dig-holes
              Detect  and  dig  holes. Makes the file sparse in-place, without
              using extra disk space. The minimal size of the hole depends  on
              filesystem I/O block size (usually 4096 bytes). Also, when using
              this option, --keep-size is implied. If no range is specified by
              --offset and --length, then all file is analyzed for holes.

              You  can think of this as doing a "cp --sparse" and renaming the
              dest file as the original,  without  the  need  for  extra  disk
              space.

So my suggestion is to implement an "online" counterpart to such
forced-sparsifying, i.e. the same thing done on FS I/O in-band.
(the analogy is with offline vs in-band dedup).

-- 
With respect,
Roman
