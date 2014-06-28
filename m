Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:33460 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaF1AvF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:51:05 -0400
From: Russell Coker <russell@coker.com.au>
To: Zack Coffey <clickwir@gmail.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 10:51 +1000
Message-ID: <10572318.CAuhDIAMDU@xev>
In-Reply-To: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 27 Jun 2014 20:30:32 Zack Coffey wrote:
> Can I get more protection by using more than 2 drives?
> 
> I had an onboard RAID a few years back that would let me use RAID1
> across up to 4 drives.

Currently the only RAID level that fully works in BTRFS is RAID-1 with data on 
2 disks.  If you have 4 disks in the array then each block will be on 2 of the 
disks.  RAID-5/6 code mostly works but the last report I read indicated that 
some situations for recovery and disk replacement didn't work - presumably 
anyone who's afraid of multiple disks failing isn't going to want to trust 
BTRFS RAID-6 code at the moment.

If you want to have 4 disks in a fully redundant configuration (IE you could 
lose 3 disks without losing any data) then the thing to do is to have 2 RAID-1 
arrays with Linux software RAID and then run BTRFS RAID-1 on top of that.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

