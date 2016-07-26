Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33725 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbcGZXDy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 19:03:54 -0400
Received: by mail-qk0-f195.google.com with SMTP id n202so1455731qke.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 16:03:54 -0700 (PDT)
MIME-Version: 1.0
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Tue, 26 Jul 2016 19:03:53 -0400
Message-ID: <CAD=QJKhXC4OR1BanS2p1Kb0cHunduY9ETPwwhphkeCfHxOXA0Q@mail.gmail.com>
Subject: btrfs fi defrag -r -t 32M? What is actually happening?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been using btrfs fi defrag with out the "-r -t 32M" option for
regular maintenance.  I just learned, in
Documentation/btrfs-convert.asciidoc, that there is a recommendation
to run with "-t 32M" after a conversion from ext2/3/4.  I then
cross-referenced this with btrfs-filesystem(8), and found that:

    Extents bigger than value given by -t will be skipped, otherwise
    this value is used as a target extent size, but is only advisory
    and may not be reached if the free space is too fragmented. Use 0
    to take the kernel default, which is 256kB but may change in the
    future.

I understand the default behaviour of target extent size of 256kB to
mean only defragment small files and metadata.  Or does this mean that
the default behaviour is to defragment extent tree metadata >256kB,
and then defragment the (larger than 256kB) data from many extents
into a single extent?  I was surprised to read this!

What's really happening with this default behaviour?  Should everyone
be using -t with a much larger value to actually defragment their
databases?

Thanks,
Nicholas
