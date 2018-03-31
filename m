Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54604 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751513AbeCaIQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 04:16:30 -0400
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
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <20180331074320.GF2446@hungrycats.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <b3214c3e-cf0c-4070-acbb-892a449476f8@inwind.it>
Date: Sat, 31 Mar 2018 10:16:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180331074320.GF2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2018 09:43 AM, Zygo Blaxell wrote:
>> The key is that if a data write is interrupted, all the transaction
>> is interrupted and aborted. And due to the COW nature of btrfs, the
>> "old state" is restored at the next reboot.

> This is not presently true with raid56 and btrfs.  RAID56 on btrfs uses
> RMW operations which are not COW and don't provide any data integrity
> guarantee.  Old data (i.e. data from very old transactions that are not
> part of the currently written transaction) can be destroyed by this.

Could you elaborate a bit ?

Generally speaking, updating a part of a stripe require a RMW cycle, because
- you need to read all data stripe (with parity in case of a problem)
- then you should write
	- the new data
	- the new parity (calculated on the basis of the first read, and the new data)

However the "old" data should be untouched; or you are saying that the "old" data is rewritten with the same data ? 

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
