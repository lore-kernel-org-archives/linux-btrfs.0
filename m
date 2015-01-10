Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:46430 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbAKP0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 10:26:45 -0500
From: Russell Coker <russell@coker.com.au>
To: Chris Murphy <lists@colorremedies.com>
Reply-To: russell@coker.com.au
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: ignoring bad blocks
Date: Sat, 10 Jan 2015 12:44:49 +1100
Message-ID: <1681738.A9HEWVbZfE@russell.coker.com.au>
In-Reply-To: <CAJCQCtS14LePOXYdqLysGyYTJhVW1oofqym-32fYKFKdM6Yytg@mail.gmail.com>
References: <fab96edbc48bf3f26781ab76dda6f182@pl1.haspere.com> <20150104151843.GX17254@merlins.org> <CAJCQCtS14LePOXYdqLysGyYTJhVW1oofqym-32fYKFKdM6Yytg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 4 Jan 2015 13:46:30 Chris Murphy wrote:
> So do use dd you need to also use bs= setting it to a multiple of
> 4096. Of course most people using dd for zeroing set bs= to a decently
> high value because it makes the process go much faster than the
> default block size of 512 bytes.

You could just use cat(1) to write to the disk.  Cat SHOULD write a minimum of 
page size buffers unless the kernel tells it that the device block size is 
larger.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
