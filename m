Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45622 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbbKYHUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 02:20:33 -0500
Received: from wheezy.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id CD4B9ED55
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 18:20:29 +1100 (AEDT)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: Re: Using Btrfs on single drives
Date: Wed, 25 Nov 2015 18:20:25 +1100
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com> <CA+LE0jyvd8f=z8GR7V2=cLzV3Khfn1YpEHka5-6k0JiSPa5-+Q@mail.gmail.com> <pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
In-Reply-To: <pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201511251820.25758.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 15 Nov 2015 03:01:57 PM Duncan wrote:
> That looks to me like native drive limitations.
> 
> Due to the fact that a modern hard drive spins at the same speed no 
> matter where the read/write head is located, when it's reading/writing to 
> the first part of the drive -- the outside -- much more linear drive 
> distance will pass under the read/write heads in say a tenth of a second 
> than will be the case as the last part of the drive is filled -- the 
> inside -- and throughput will be much higher at the first of the drive.

http://www.coker.com.au/bonnie++/zcav/results.html

The above page has the results of my ZCAV benchmark (part of the Bonnie++ 
suite) which shows this.  You can safely tun ZCAV in read mode on a device 
that's got a filesystem on it so it's not too late to test these things.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
