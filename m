Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41808 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752928AbaANAhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 19:37:33 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:58826 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W2s0a-0017RX-QL
	for linux-btrfs@vger.kernel.org; Mon, 13 Jan 2014 17:37:32 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck failes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
Date: Mon, 13 Jan 2014 17:37:31 -0700
Message-Id: <A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 13, 2014, at 3:58 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:
> 
> Currently btrfsck failes to repair my partition, I get the output:
> 
> [root@ho-think bholger]# btrfsck --repair /dev/sda5

This is almost the last resort and you probably should be posting to the list before using repair.


> [...]
> leaf parent key incorrect 600846336
> parent transid verify failed on 600846336 wanted 23460 found 23463
> Ignoring transid failure
> leaf parent key incorrect 600846336
> bad block 600395776
> bad block 600518656
> bad block 600547328

Please provide the following information for this volume:

btrfs fi show
btrfs fi df <mountpoint>
dmesg
smartctl -x <dev>


> I had to unmount it to run btrfsck, but because it fails to repair my
> disk, I cannot mount it any more.

Try to mount with -o clear_cache.

Chris Murphy

