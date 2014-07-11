Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60056 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaGKMdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 08:33:21 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs transaction checksum corruption & losing root of the tree & bizarre UUID change.
Date: Fri, 11 Jul 2014 22:33:17 +1000
Message-ID: <2422537.XRs88ffYHU@xev>
In-Reply-To: <pan$47a6b$a35f9006$c974e846$4fb869f0@cox.net>
References: <CAKinxcW7X=tc8GBBjkGNHKL8wM6dD=a9UkWBpXOsAbLpaOBmYA@mail.gmail.com> <pan$47a6b$a35f9006$c974e846$4fb869f0@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 11 Jul 2014 10:38:22 Duncan wrote:
> > I've moved all drives and move those to my main rig which got a nice
> > 16GB of ecc ram, so errors of ram, cpu, controller should be kept
> > theoretically eliminated.
> 
> It's worth noting that ECC RAM doesn't necessarily help when it's an in-
> transit bus error.  Some years ago I had one of the original 3-digit 
> Opteron machines, which of course required registered and thus ECC RAM.  
> The first RAM I purchased for that board was apparently borderline on its 
> timing certifications, and while it worked fine when the system wasn't 
> too stressed, including with memtest, which passed with flying colors, 
> under medium memory activity it would very occasionally give me, for 
> instance, a bad bzip2 csum, and with intensive memory activity, the 
> problem would be worse (more bz2 decompress errors, gcc would error out 
> too sometimes and I'd have to restart my build, very occasionally the 
> system would crash).

If bad RAM causes corrupt memory but no ECC error reports then it probably 
wouldn't be a bus error.  A bus error SHOULD give ECC reports.

One problem is that RAM errors aren't random.  From memory the Hamming codes 
used fix 100% of single bit errors, detect 100% of 2 bit errors, and let some 
3 bit errors through.  If you have a memory module with 3 chips on it (the 
later generation of DIMM for any given size) then an error in 1 chip can 
change 4 bits.

The other main problem is that if you have a read or write going to the wrong 
address then you lose as AFAIK there's no ECC on address lines.

But I still recommend ECC RAM, it just decreases the scope for problems.  
About half the serious problems I've had with BTRFS have been caused by a 
faulty DIMM...

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

