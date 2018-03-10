Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:58827 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbeCJQzw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 11:55:52 -0500
Message-ID: <1520700948.24363.28.camel@scientia.net>
Subject: Re: zerofree btrfs support?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Roman Mamedov <rm@romanrm.net>
Cc: Adam Borowski <kilobyte@angband.pl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 17:55:48 +0100
In-Reply-To: <20180310193722.2d6b494a@natsu>
References: <1520650525.5641.47.camel@scientia.net>
         <20180310081606.7c2u2dtopijujhbz@angband.pl>
         <1520691545.24363.10.camel@scientia.net> <20180310193722.2d6b494a@natsu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2018-03-10 at 19:37 +0500, Roman Mamedov wrote:
> Note you can use it on HDDs too, even without QEMU and the like: via
> using LVM
> "thin" volumes. I use that on a number of machines, the benefit is
> that since
> TRIMed areas are "stored nowhere", those partitions allow for
> incredibly fast
> block-level backups, as it doesn't have to physically read in all the
> free
> space, let alone any stale data in there. LVM snapshots are also way
> more
> efficient with thin volumes, which helps during backup.
I was thinking about using those... but then I'd have to use loop
device files I guess... which I also want to avoid.



> > dm-crypt per default blocks discard.
> 
> Out of misguided paranoia. If your crypto is any good (and last I
> checked AES
> was good enough), there's really not a lot to gain for the "attacker"
> knowing
> which areas of the disk are used and which are not.
I'm not an expert here... but a) I think it would be independent of AES
and rather the encryption mode (e.g. XTS) which protects here or not...
and b) we've seen too many attacks on crypto based on smart statistics
and knowing which blocks on a medium are actually data or just "random
crypto noise" (and you know that when using TRIM) can already tell a
lot.
At least it could tell an attacker how much data there is on a fs.

 
> It works, just not with some of the QEMU virtualized disk device
> drivers.
> You don't need to use qemu-img to manually dig holes either, it's all
> automatic.
You're right... seems like in older version one needed to set virtio-
scsi as device driver (which I possible missed), but nowadays it even
seems to work with sata.



> QEMU deallocates parts of its raw images for those areas which have
> been
> TRIM'ed by the guest. In fact I never use qcow2, always raw images
> only.
> Yet, boot a guest, issue fstrim, and see the raw file while still
> having the
> same size, show much lower actual disk usage in "du".
Works with qcow2 as well... heck even Windows can do it (though it has
no fstrim and it seems one needs to run defrag (which probably does
next to defragmentation also what fstrim does).


Fine for me,... though non qemu users may still be interested in having
 zerofree.


Cheers,
Chris.
