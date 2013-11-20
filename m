Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62372 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3KTVE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 16:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <528D06BC.3070504@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<528C8F8E.9030908@hesbynett.no>
	<CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
	<1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com>
	<CAGKKSfV-jie=6X+DuJJB6L7AdW4f83bQofYHBHwuuZvV+6mUxg@mail.gmail.com>
	<528D06BC.3070504@zytor.com>
Date: Wed, 20 Nov 2013 22:04:55 +0100
Message-ID: <CAGKKSfVQhRX4=e+UGOATq5L02X0_muhsfgBzVc4KqT=dfTYSyg@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Brown <david.brown@hesbynett.no>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

>> static inline uint64_t d2_64(uint64_t v)
>> {
>>         uint64_t mask = v & 0x0101010101010101U;
>>         mask = (mask << 8) - mask;
>
> (mask << 7) I assume...
No. It's "(mask << 8) - mask". We want to expand the bit at position 0
(in each byte) to the full byte, resulting in 0xFF if the bit is at 1,
and 0x00 if the bit is 0.

(0 << 8) - 0 = 0x00
(1 << 8) - 1 = 0x100 - 1 = 0xFF

Ciao,
Andrea
