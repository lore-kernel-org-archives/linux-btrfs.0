Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51016 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbdHAUJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 16:09:15 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:50906)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dcdTd-0000IA-IV
        for linux-btrfs@vger.kernel.org; Tue, 01 Aug 2017 21:09:13 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dcdTT-0002vF-Oo
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 21:09:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22912.57311.417226.447973@tree.ty.sabi.co.uk>
Date: Tue, 1 Aug 2017 21:09:03 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <15990599.40.1501611004053.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
        <22911.5971.350346.969146@tree.ty.sabi.co.uk>
        <6022267.255.1501581534233.JavaMail.gkos@dynomob>
        <22912.32415.601826.757780@tree.ty.sabi.co.uk>
        <15990599.40.1501611004053.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> [ ... ] a "RAID5 with 128KiB writes and a 768KiB stripe
>> size". [ ... ] several back-to-back 128KiB writes [ ... ] get
>> merged by the 3ware firmware only if it has a persistent
>> cache, and maybe your 3ware does not have one,

> KOS: No I don't have persistent cache. Only the 512 Mb cache
> on board of a controller, that is BBU.

If it is a persistent cache, that can be battery-backed (as I
wrote, but it seems that you don't have too much time to read
replies) then the size of the write, 128KiB or not, should not
matter much; the write will be reported complete when it hits
the persistent cache (whichever technology it used), and then
the HA fimware will spill write cached data to the disks using
the optimal operation width.

Unless the 3ware firmware is really terrible (and depending on
model and vintage it can be amazingly terrible) or the battery
is no longer recharging and then the host adapter switches to
write-through.

That you see very different rates between uncompressed and
compressed writes, where the main difference is the limitation
on the segment size, seems to indicate that compressed writes
involve a lot of RMW, that is sub-stripe updates. As I mentioned
already, it would be interesting to retry 'dd' with different
'bs' values without compression and with 'sync' (or 'direct'
which only makes sense without compression).

> If I had additional SSD caching on the controller I would have
> mentioned it.

So far you had not mentioned the presence of BBU cache either,
which is equivalent, even if in one of your previous message
(which I try to read carefully) there were these lines:

>>>> Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
>>>> Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU

So perhaps someone else would have checked long ago the status
of the BBU and whether the "No Write Cache if Bad BBU" case has
happened. If the BBU is still working and the policy is still
"WriteBack" then things are stranger still.

> I was also under impression, that in a situation where mostly
> extra large files will be stored on the massive, the bigger
> strip size would indeed increase the speed, thus I went with
> with the 256 Kb strip size.

That runs counter to this simple story: suppose a program is
doing 64KiB IO:

* For *reads*, there are 4 data drives and the strip size is
  16KiB: the 64KiB will be read in parallel on 4 drives. If the
  strip size is 256KiB then the 64KiB will be read sequentially
  from just one disk, and 4 successive reads will be read
  sequentially from the same drive.

* For *writes* on a parity RAID like RAID5 things are much, much
  more extreme: the 64KiB will be written with 16KiB strips on a
  5-wide RAID5 set in parallel to 5 drives, with 4 stripes being
  updated with RMW. But with 256KiB strips it will partially
  update 5 drives, because the stripe is 1024+256KiB, and it
  needs to do RMW, and four successive 64KiB drives will need to
  do that too, even if only one drive is updated. Usually for
  RAID5 there is an optimization that means that only the
  specific target drive and the parity drives(s) need RMW, but
  it is still very expensive.

This is the "storage for beginners" version, what happens in
practice however depends a lot on specific workload profile
(typical read/write size and latencies and rates), caching and
queueing algorithms in both Linux and the HA firmware.

> Would I be correct in assuming that the RAID strip size of 128
> Kb will be a better choice if one plans to use the BTRFS with
> compression?

That would need to be tested, because of "depends a lot on
specific workload profile, caching and queueing algorithms", but
my expectation is the the lower the better. Given that you have
4 drives giving a 3+1 RAID set, perhaps a 32KiB or 64KiB strip
size, given a data stripe size of 96KiB or 192KiB, would be
better.
