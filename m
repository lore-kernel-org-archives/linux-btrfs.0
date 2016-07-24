Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34004 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcGXCQy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 22:16:54 -0400
Received: by mail-oi0-f41.google.com with SMTP id l65so211010673oib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 19:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 20:16:52 -0600
Message-ID: <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com>
Subject: Re: Force recalculation of a data block checksum
To: Tomasz Melcer <liori@exroot.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 23, 2016 at 8:03 PM, Tomasz Melcer <liori@exroot.org> wrote:
> Hi,
>
> I've got a USB-connected HDD with a btrfs partition. The partition contains
> a 1TB file, a disk image. The first `btrfs scrub` after writing that file
> found 3 logical bad blocks that developed somewhere in the middle of that
> file (logs below).
>
> The full area of the btrfs partition can be read without I/O error, so I
> think there are two possible cases: either the data block was written
> incorrectly or an incorrect checksum is stored. The first case is obviously
> unrecoverable, but if it's the second case, fixing the problem should be as
> simple as recomputing the checksum for what is already stored.
>
> How can I ask btrfs to recompute the checksum of a data block as it is
> stored on the drive? I don't see any command doing an operation like that,
> and I couldn't find anything on the topic on the internet.

Since btrfs-progs 3.17 'btrfs check --init-csum-tree' will create a
whole new csum tree.



-- 
Chris Murphy
