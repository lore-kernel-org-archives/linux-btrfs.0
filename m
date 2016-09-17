Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51283 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754203AbcIQJbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 05:31:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1blBxc-00078y-KN
        for linux-btrfs@vger.kernel.org; Sat, 17 Sep 2016 11:31:00 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: compress=lzo safe to use?
Date: Sat, 17 Sep 2016 11:30:42 +0200
Message-ID: <20160917113042.111eb022@jupiter.sol.kaishome.de>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
        <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
        <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
        <4096253.hu8ZAHGEqT@merkaba>
        <6ef80ffd-6a56-3538-0778-a99cb4b9851e@mendix.com>
        <pan$56316$8902276c$b806652$f5dac40c@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 12 Sep 2016 04:36:07 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Again, I once thought all this was just the stage at which btrfs was, 
> until I found out that it doesn't seem to happen if btrfs compression 
> isn't being used.  Something about the way it recovers from checksum 
> errors on compressed data differs from the way it recovers from
> checksum errors on uncompressed data, and there's a bug in the
> compressed data processing path.  But beyond that, I'm not a dev and
> it gets a bit fuzzy, which also explains why I've not gone code
> diving and submitted patches to try to fix it, myself.

I suspect that may very well come from the decompression routine which
crashes - and not from btrfs itself. So essentially, the decompression
needs to be fixed instead (which probably slows it down by factors).

Only when this is tested and fixed, one should look into why btrfs
fails when decompression fails.

-- 
Regards,
Kai

Replies to list-only preferred.

