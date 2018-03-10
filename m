Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:41481 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932169AbeCJOTJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 09:19:09 -0500
Message-ID: <1520691545.24363.10.camel@scientia.net>
Subject: Re: zerofree btrfs support?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Adam Borowski <kilobyte@angband.pl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 15:19:05 +0100
In-Reply-To: <20180310081606.7c2u2dtopijujhbz@angband.pl>
References: <1520650525.5641.47.camel@scientia.net>
         <20180310081606.7c2u2dtopijujhbz@angband.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2018-03-10 at 09:16 +0100, Adam Borowski wrote:
> Do you want zerofree for thin storage optimization, or for security?
I don't think one can really use it for security (neither on SSD or
HDD).
On both, zeroed blocks may still be readable by forensic measures.

So optimisation, i.e. digging holes in VM image files and make them
sparse.


> For the former, you can use fstrim; this is enough on any modern SSD;
> on HDD
> you can rig the block device to simulate TRIM by writing zeroes.  I'm
> sure
> one of dm-* can do this, if not -- should be easy to add, there's
> also
> qemu-nbd which allows control over discard, but incurs a performance
> penalty
> compared to playing with the block layer.

Writing zeros if of course possible... but rather ugly... one really
needs to write *everything* while a smart tool could just zero those
block groups that have been used (while everything else is still zero
from the original image file).

TRIM/discard... not sure how far this is really a solution.

The first thing that comes to my mind is, that *if* the discard would
propagate down below a dm-crypt layer (e.g. in my case there is:
SSD->partitions->dmcrypt->LUKS->btrfs->image-files-I-want-to-zero)
it has effects on security, which is why dm-crypt per default blocks
discard.

Some longer time ago I had a look at whether qemu would support that on
it's own,... i.e. the guest and it's btrfs would normally use discard,
but the image file below would mark the block as discarded and later on
e can use some qemu-img command to dig holes into exactly those
locations.
Back then it didn't seem to work.

But even if it would in the meantime, a proper zerofree implementation
would be beneficial for all non-qemu/qcow2 users (e.g. if one uses raw
images in qemu, the whole thing couldn't work but with really zeroing
the blocks inside the guest.


Cheers,
Chris.
