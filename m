Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:55020 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdDCIur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 04:50:47 -0400
Date: Mon, 3 Apr 2017 13:41:39 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
Message-ID: <20170403134139.5737bca7@natsu>
In-Reply-To: <c5472e71-908c-3d42-ee40-73d003bfc598@gmail.com>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
 <20170401191357.GA25721@coach>
 <pan$df213$fa344dca$8529fcec$34b89ea9@cox.net>
 <c5472e71-908c-3d42-ee40-73d003bfc598@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2 Apr 2017 09:30:46 +0300
Andrei Borzenkov <arvidjaar@gmail.com> wrote:

> 02.04.2017 03:59, Duncan пишет:
> > 
> > 4) In fact, since an in-place convert is almost certainly going to take 
> > more time than a blow-away and restore from backup,
> 
> This caught my eyes. Why? In-place convert just needs to recreate
> metadata. If you have multi-terabyte worth of data copying them twice
> hardly can be faster.

In-place convert is most certainly faster than copy-away and restore, in fact
it can be very fast if you use the option to not calculate checksums for the
entire filesystem's data (btrfs-convert -d).

-- 
With respect,
Roman
