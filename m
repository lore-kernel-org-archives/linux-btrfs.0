Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:59800 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaEAEWg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 00:22:36 -0400
Received: by mail-yh0-f48.google.com with SMTP id v1so2600679yhn.7
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 21:22:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 May 2014 00:16:20 -0400
Message-ID: <CAD15GZfSy0QWzpNQ2X2_3jUMBMV-WN4obAsnHH=Ea9xt-BEA7w@mail.gmail.com>
Subject: btrfs checksum
From: Jan Kasiak <j.kasiak@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there a design/technical reason behind btrfs using checksums
separately per block, versus checksumming into a merkle tree?

Where I'm coming from: there's a Linux kernel device mapper module
called dm-verity, which let's you verify the contents of a block
device using a merkle tree (at mount time you provide the root hash).
For my project, I'm modifying the module to enable write support, but
in order to maintain consistency in the event of a power failure, I
have to do the equivalent of data journaling to a circular log (so I
end up writing data twice).

Where I'm going with this: I've been looking into what improvements
could be made if this were implemented at the filesystem level, and
btrfs looks like a good candidate. But it already has a checksumming
scheme, which is incompatible with a merkle tree, and would be
redundant if a merkle tree would be implemented as well. (zfs has a
merkle tree, but from what I can tell, it doesn't expose the root hash
to the user)

What the example use case is: you want to detect malicious data
tampering across the entire file system, so at mount time you provide
the merkle tree root hash. You get back an updated version of the root
hash when you unmount, which you store in a secure place until the
next time you mount the filesystem. You can detect if anyone modifies
your data in between mounts, and also if they modify the underlying
storage while the filesystem is mounted.

Thanks,
-Jan
