Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:52731 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3KQMFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 07:05:07 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 86AB3219B0
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 23:05:04 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs resize partition problem
Date: Sun, 17 Nov 2013 23:05:04 +1100
References: <5287D775.1090105@gmail.com> <pan$32f6c$5635c224$e9b25768$a7831c50@cox.net>
In-Reply-To: <pan$32f6c$5635c224$e9b25768$a7831c50@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311172305.04091.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 17 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> People often use separate partitions because they don't want all their
> data eggs in one basket, and because it makes administration easier for
> some things.  A read-only by default rootfs is far safer in the event of

I have a laptop with two partitions, one is encrypted and has root /home, etc.  
The other isn't encrypted and has things like the latest TED talks I 
downloaded.  The potential problem with this scheme is that if the volume of 
encrypted data starts taking more than the amount of space allocated for it 
then things will become difficult.  But as the unencrypted data tends to grow 
faster that doesn't seem to be likely.

I'm just planning my first BTRFS server which will run in a location other 
than my home.  This is significant because my ability to fix things will be 
limited.  For that server I will use Ext4 for / and BTRFS for everything else.  
Then if something goes wrong there will be a chance that I can at least login 
remotely to fix the BTRFS filesystem.

My home server has / and /home on a SSD and a RAID-1 array of 2*3TB disks 
mounted on /big.  I have had a number of BTRFS related problems with that 
system and BTRFS for / hasn't made it easier to solve them.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
