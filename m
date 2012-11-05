Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:32778 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2KEXPF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 18:15:05 -0500
Date: Tue, 6 Nov 2012 00:15:02 +0100
From: David Sterba <dave@jikos.cz>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What's the minimum size I can shrink my FS to?
Message-ID: <20121105231502.GP3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
 <CAE5mzvj38wxYWgcV+77hB-YmCS7ZKH_4sigf3ybcyMY9NB==zg@mail.gmail.com>
 <CACCfv7rQ4Gqiaf8r7XRMDQnXe_xT0-eJPoLCFTFneWOYwkuaEQ@mail.gmail.com>
 <CACCfv7o-=NEYAWu=Q2CTZYuk2ii6kmYoNuA94XxdMPrf3Sg_Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACCfv7o-=NEYAWu=Q2CTZYuk2ii6kmYoNuA94XxdMPrf3Sg_Kg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 03, 2012 at 03:10:52PM +1030, Jordan Windsor wrote:
> [root@archpc ~]# btrfs fi df /home/jordan/Storage/
> Data: total=580.88GB, used=490.88GB

This is getting full, 84%, there is not much chance of getting rid of
substantially many 1G-chunks through the 'usage=1' balance filter.
Some of the space between 490G and 580G will be spent on slack space and
fragmentation, the rest may be packed together by a higher usage= value
(but will be slower due to relocating more data).

> System, DUP: total=32.00MB, used=76.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=13.01GB, used=1001.83MB

If you intend to shrink a filesystem, all space group types must be
taken into account, so here you have at least

580G + 2x32M + 4M + 2x13G = ~607G

> [root@archpc ~]# btrfs fi sh
> failed to read /dev/sr0
> Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
> Total devices 1 FS bytes used 491.86GB
> devid    1 size 612.04GB used 606.96GB path /dev/sda6
                                ^^^^^^
confirmed :)

So basically you cannot go under this number when shrinking. I think you
can squeeze the metadata space down to 2G (or maybe to 1G, it's getting
very close to 1G so hard to guess) by the -musage= filter AND using at
least 3.7 kernel (or 3.6+ chris' for-linus branch) with the fixed
over-allocation bug (otherwise the size will stay pinned at 2% of the
filesystem size).

david
