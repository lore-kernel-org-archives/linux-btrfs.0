Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:36111 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdHMSpJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 14:45:09 -0400
Received: by mail-ua0-f194.google.com with SMTP id w45so4092447uac.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 11:45:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 13 Aug 2017 12:45:08 -0600
Message-ID: <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
Subject: Re: [RFC] Checksum of the parity
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 8:16 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> Hi all,
>
> in the BTRFS wiki, in the status page, in the "line" RAID5/6 it is reported that the parity is not checksummed. This was reported several time in the ML and also on other site (e.g. phoronix) as a BTRFS defect.
>
> However I was unable to understand it, and I am supposing that this is a false mith.
>
> So my question is: the fact that in the BTRFS5/6 the parity is not checksummed could be considered a defect ?
>
> My goal is to verify if there is a rationale to require the parity checksummed, and if no I would like to remove this from the wiki.

It is not a per se defect. If parity is corrupt, and parity is needed
for reconstruction, reconstruction will be corrupt, but is then
detected and we get EIO [1]

Further, the error detection of corrupt reconstruction is why I say
Btrfs is not subject *in practice* to the write hole problem. [2]


[1]
I haven't tested the raid6 normal read case where a stripe contains
corrupt data strip and corrupt P strip, and Q strip is good. I expect
instead of EIO, we get a reconstruction from Q, and then both data and
P get fixed up, but I can't find it in comments or code.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?h=v4.12.7
line 1851, I'm not sure where we're at exactly at this line; seems
like it must be a scrub because P & Q are not relevant if data is
good.

[2]
Is Btrfs subject to the write hole problem manifesting on disk? I'm
not sure, sadly I don't read the code well enough. But if all Btrfs
raid56 writes are full stripe CoW writes, and if the prescribed order
guarantees still happen: data CoW to disk > metadata CoW to disk >
superblock update, then I don't see how the write hole happens. Write
hole requires: RMW of a stripe, which is a partial stripe overwrite,
and a crash during the modification of the stripe making that stripe
inconsistent as well as still pointed to by metadata.




-- 
Chris Murphy
