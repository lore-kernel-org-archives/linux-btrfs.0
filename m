Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:53426 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751407AbeCaG5W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 02:57:22 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <389bce3c-92ac-390a-1719-5b9591c9b85c@libero.it>
 <20180331050345.GE2446@hungrycats.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
Date: Sat, 31 Mar 2018 08:57:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180331050345.GE2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2018 07:03 AM, Zygo Blaxell wrote:
>>> btrfs has no optimization like mdadm write-intent bitmaps; recovery
>>> is always a full-device operation.  In theory btrfs could track
>>> modifications at the chunk level but this isn't even specified in the
>>> on-disk format, much less implemented.
>> It could go even further; it would be sufficient to track which
>> *partial* stripes update will be performed before a commit, in one
>> of the btrfs logs. Then in case of a mount of an unclean filesystem,
>> a scrub on these stripes would be sufficient.

> A scrub cannot fix a raid56 write hole--the data is already lost.
> The damaged stripe updates must be replayed from the log.

Your statement is correct, but you doesn't consider the COW nature of btrfs.

The key is that if a data write is interrupted, all the transaction is interrupted and aborted. And due to the COW nature of btrfs, the "old state" is restored at the next reboot.

What is needed in any case is rebuild of parity to avoid the "write-hole" bug. And this is needed only for a partial stripe write. For a full stripe write, due to the fact that the commit is not flushed, it is not needed the scrub at all.

Of course for the NODATACOW file this is not entirely true; but I don't see the gain to switch from the cost of COW to the cost of a log.

The above sentences are correct (IMHO) if we don't consider a power failure+device missing case. However in this case even logging the "new data" would be not sufficient.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
