Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:45399 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeDAVLF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Apr 2018 17:11:05 -0400
Received: by mail-oi0-f48.google.com with SMTP id 71-v6so11463539oie.12
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Apr 2018 14:11:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net> <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it> <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it> <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org> <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Apr 2018 15:11:04 -0600
Message-ID: <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
Subject: Re: Status of RAID5/6
To: Chris Murphy <lists@colorremedies.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(I hate it when my palm rubs the trackpad and hits send prematurely...)


On Sun, Apr 1, 2018 at 2:51 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> Users can run scrub immediately after _every_ unclean shutdown to
>> reduce the risk of inconsistent parity and unrecoverable data should
>> a disk fail later, but this can only prevent future write hole events,
>> not recover data lost during past events.
>
> Problem is, Btrfs assumes a leaf is correct if it passes checksum. And
> such a leaf containing EXTENT_CSUM means that EXTENT_CSUM

means that EXTENT_CSUM is assumed to be correct. But in fact it could
be stale. It's just as possible the metadata and superblock update is
what's missing due to the interruption, while both data and parity
strip writes succeeded. The window for either the data or parity write
to fail is way shorter of a time interval, than that of the numerous
metadata writes, followed by superblock update. In such a case, the
old metadata is what's pointed to, including EXTENT_CSUM. Therefore
your scrub would always show csum error, even if both data and parity
are correct. You'd have to init-csum in this case, I suppose.

Pretty much it's RMW with a (partial) stripe overwrite upending COW,
and therefore upending the atomicity, and thus consistency of Btrfs in
the raid56 case where any portion of the transaction is interrupted.

And this is amplified if metadata is also raid56.

ZFS avoids the problem at the expense of probably a ton of
fragmentation, by taking e.g. 4KiB RMW and writing a full length
stripe of 8KiB fully COW, rather than doing stripe modification with
an overwrite. And that's because it has dynamic stripe lengths. For
Btrfs to always do COW would mean that 4KiB change goes into a new
full stripe, 64KiB * num devices, assuming no other changes are ready
at commit time.

So yeah, avoiding the problem is best. But if it's going to be a
journal, it's going to make things pretty damn slow I'd think, unless
the journal can be explicitly placed something faster than the array,
like an SSD/NVMe device. And that's what mdadm allows and expects.



-- 
Chris Murphy
