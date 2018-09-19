Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59867 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbeITBnq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 21:43:46 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: very poor performance / a lot of writes to disk with space_cache (but not with space_cache=v2)
Date: Wed, 19 Sep 2018 22:04:14 +0200
Message-ID: <1646602.qIcv3L3msO@merkaba>
In-Reply-To: <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com> <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg - 19.09.18, 19:58:
> However, as soon as we remount the filesystem with space_cache=v2 -
> 
> > writes drop to just around 3-10 MB/s to each disk. If we remount to
> > space_cache - lots of writes, system unresponsive. Again remount to
> > space_cache=v2 - low writes, system responsive.
> > 
> > That's a huuge, 10x overhead! Is it expected? Especially that
> > space_cache=v1 is still the default mount option?
> 
> Yes, that does not surprise me.
> 
> https://events.static.linuxfound.org/sites/events/files/slides/vault20
> 16_0.pdf
> 
> Free space cache v1 is the default because of issues with btrfs-progs,
> not because it's unwise to use the kernel code. I can totally
> recommend using it. The linked presentation above gives some good
> background information.

What issues in btrfs-progs are that?

I am wondering whether to switch to freespace tree v2. Would it provide 
benefit for a regular / and /home filesystems as dual SSD BTRFS RAID-1 
on a laptop?

Thanks,
-- 
Martin
