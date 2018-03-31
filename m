Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:41621 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752824AbeCaWe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 18:34:59 -0400
Received: by mail-ot0-f178.google.com with SMTP id i28-v6so12546511otf.8
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Mar 2018 15:34:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net> <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it> <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 31 Mar 2018 16:34:58 -0600
Message-ID: <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
Subject: Re: Status of RAID5/6
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 31, 2018 at 12:57 AM, Goffredo Baroncelli
<kreijack@inwind.it> wrote:
> On 03/31/2018 07:03 AM, Zygo Blaxell wrote:
>>>> btrfs has no optimization like mdadm write-intent bitmaps; recovery
>>>> is always a full-device operation.  In theory btrfs could track
>>>> modifications at the chunk level but this isn't even specified in the
>>>> on-disk format, much less implemented.
>>> It could go even further; it would be sufficient to track which
>>> *partial* stripes update will be performed before a commit, in one
>>> of the btrfs logs. Then in case of a mount of an unclean filesystem,
>>> a scrub on these stripes would be sufficient.
>
>> A scrub cannot fix a raid56 write hole--the data is already lost.
>> The damaged stripe updates must be replayed from the log.
>
> Your statement is correct, but you doesn't consider the COW nature of btrfs.
>
> The key is that if a data write is interrupted, all the transaction is interrupted and aborted. And due to the COW nature of btrfs, the "old state" is restored at the next reboot.
>
> What is needed in any case is rebuild of parity to avoid the "write-hole" bug.

Write hole happens on disk in Btrfs, but the ensuing corruption on
rebuild is detected. Corrupt data never propagates. The problem is
that Btrfs gives up when it's detected.

If it assumes just a bit flip - not always a correct assumption but
might be reasonable most of the time, it could iterate very quickly.
Flip bit, and recompute and compare checksum. It doesn't have to
iterate across 64KiB times the number of devices. It really only has
to iterate bit flips on the particular 4KiB block that has failed csum
(or in the case of metadata, 16KiB for the default leaf size, up to a
max of 64KiB).

That's a maximum of 4096 iterations and comparisons. It'd be quite
fast. And going for two bit flips while a lot slower is probably not
all that bad either.

Now if it's the kind of corruption you get from a torn or misdirected
write, there's enough corruption that now you're trying to find a
collision on crc32c with a partial match as a guide. That'd take a
while and who knows you might actually get corrupted data anyway since
crc32c isn't cryptographically secure.


-- 
Chris Murphy
