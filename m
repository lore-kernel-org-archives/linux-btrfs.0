Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:60444 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933032AbdKPObS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 09:31:18 -0500
Received: from [81.95.28.29] (helo=job)
        by demfloro.ru with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <demfloro@demfloro.ru>)
        id 1eFLCG-0000rI-8X
        for linux-btrfs@vger.kernel.org; Thu, 16 Nov 2017 14:31:17 +0000
Date: Thu, 16 Nov 2017 17:31:04 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: Read before you deploy btrfs + zstd
Message-ID: <20171116173104.08497aaa@job>
In-Reply-To: <pan$9fe69$3a062179$aad19d2f$63c49115@cox.net>
References: <20171113225046.GD28899@suse.cz>
        <3013353.6rxLtS64S0@merkaba>
        <d0442de1-b53a-3b16-8932-54c783dd8afe@gmail.com>
        <pan$9fe69$3a062179$aad19d2f$63c49115@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Nov 2017 20:23:44 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:
> Tho from my understanding and last I read, btrfs restore (I believe
> it was) hadn't been updated to handle zstd yet, tho btrfs check and
> btrfs filesystem defrag had been, and of course btrfs balance if the
> kernel handles it since all balance does is call the kernel to do it.
> 
> So just confirming, does btrfs restore handle zstd from -progs 4.13?  
> 
> Because once a filesystem goes unmountable, restore is what I've had
> best luck with, so if it doesn't understand zstd, no zstd for me.  
> (Regardless, being the slightly cautious type I'll very likely wait a 
> couple kernel cycles before switching from lzo to zstd here, just to
> see if any weird reports about it from the first-out testers hit the
> list in the mean time.)
> 
> Meanwhile, it shouldn't need said but just in case, if you're using
> it, be sure you have backups /not/ using zstd, for at least a couple
> kernel cycles. =:^)
> 

Btrfs-progs 4.13 can be optionally built with libzstd, then btrfs
restore can restore from zstd compressed file systems (I tested that
right now with temporary fs using compress-force=zstd mount option).

Btrfs-progs 4.14 will require libzstd by default during build.
