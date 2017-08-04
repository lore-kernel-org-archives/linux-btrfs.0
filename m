Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50350 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751285AbdHDIcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 04:32:48 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id 2BA2620409
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Aug 2017 08:32:47 +0000 (UTC)
Date: Fri, 4 Aug 2017 13:32:46 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: csum errors on top of dm-crypt
Message-ID: <20170804133246.210c09b1@natsu>
In-Reply-To: <20170804124444.6d102183@natsu>
References: <20170804121858.1c860065@natsu>
 <20170804124444.6d102183@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 4 Aug 2017 12:44:44 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> > What is 0x98f94189, is it not a csum of a block of zeroes by any chance?
> 
> It does seem to be something of that sort

Actually, I think I know what happened.

I used "dd bs=1M conv=sparse" to copy source FS onto a LUKS device, which
skipped copying 1M-sized areas of zeroes from the source device by seeking
over those areas on the destination device.

This only works OK if the destination device is entirely zeroed beforehand.

But I also use --allow-discards for the LUKS device; so it may be that after a
discard passthrough to the underlying SSD, which will then return zeroes for
discarded areas, LUKS will not take care to pass zeroes back "upwards" when
reading from those areas, instead it may attempt to decrypt them with its
crypto process, making them read back to userspace as random data.

So after an initial TRIM the destination crypto device was not actually zeroed,
far from it. :)

As a result, every large non-sparse file with at least 1MB-long run of zeroes
in it (those sqlite ones appear to fit the bill) was not written out entirely
onto the destination device by dd, and the intended zero areas were left full
of crypto-randomness instead.

Sorry for the noise, I hope at least this catch was somewhat entertaining.

And Btrfs saves the day once again. :)

-- 
With respect,
Roman
