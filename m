Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53064 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbFTDuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 23:50:40 -0400
From: Russell Coker <russell@coker.com.au>
To: Jan Voet <jan.voet@gmail.com>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
Date: Sat, 20 Jun 2015 13:50:33 +1000
Cc: linux-btrfs@vger.kernel.org
References: <loom.20150521T231006-840@post.gmane.org> <loom.20150522T194305-796@post.gmane.org> <loom.20150523T165247-239@post.gmane.org>
In-Reply-To: <loom.20150523T165247-239@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201506201350.33819.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 May 2015 01:02:21 AM Jan Voet wrote:
> Doing a 'btrfs balance cancel' immediately after the array was mounted
> seems to have done the trick.  A subsequent 'btrfs check' didn't show any
> errors at all and all the data seems to be there.  :-)

I add "rootflags=skip_balance" to the kernel command-line of all my Debian 
systems to solve this.  I've had problems with the balance resuming in the 
past which had similar results.  I've also never seen a situation where 
resuming the balance did any good.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
