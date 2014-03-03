Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43295 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaCCBKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 20:10:03 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
Date: Mon, 3 Mar 2014 12:09:59 +1100
References: <52C7127F.3060902@friedels.name> <53010EF9.60805@friedels.name> <21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com>
In-Reply-To: <21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201403031209.59316.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 17 Feb 2014, Chris Murphy <lists@colorremedies.com> wrote:
> Also, 10 hours to balance two disks at 2.3TB seems like a long time. I'm
> not sure if that's expected.

I just had a system with a single 120G Intel SSD and 54G of data stored take 3 
hours for a balance.

Balance seems to be a very slow operation and it also uses enough capacity 
(both disk IO and CPU time for BTRFS kernel threads) to seriously degrade 
system performance for the duration.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
