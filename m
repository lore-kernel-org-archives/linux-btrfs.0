Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:52831 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEMH5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 03:57:05 -0400
From: Russell Coker <russell@coker.com.au>
To: Brendan Hide <brendan@swiftspirit.co.za>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: -musage=>0 means always reporting relocation
Date: Tue, 13 May 2014 17:57 +1000
Message-ID: <2427848.SjNntC7t9e@xev>
In-Reply-To: <536F852C.3000100@swiftspirit.co.za>
References: <201405111943.16913.russell@coker.com.au> <201405111952.43458.russell@coker.com.au> <536F852C.3000100@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 11 May 2014 16:11:56 Brendan Hide wrote:
> On 2014/05/11 11:52 AM, Russell Coker wrote:
> > On Sun, 11 May 2014, Russell Coker <russell@coker.com.au> wrote:
> >> Below is the output of running a balance a few times on a 120G SSD.
> > 
> > Sorry forgot to mention that's kernel 3.14.1 Debian package.
> 
> Please send the output of the two following command:
> btrfs fi df /

#btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 2 out of 107 chunks
#btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 2 out of 107 chunks
#btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 1 out of 107 chunks
#btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 1 out of 107 chunks
#btrfs fi balance start -dusage=10 -musage=10 /
Done, had to relocate 2 out of 107 chunks
#btrfs fi balance start -dusage=10 -musage=10 /
Done, had to relocate 2 out of 107 chunks
#btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 1 out of 107 chunks
#btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 1 out of 107 chunks
#btrfs fi df /
Data, single: total=100.47GiB, used=92.11GiB
System, DUP: total=32.00MiB, used=20.00KiB
Metadata, DUP: total=2.50GiB, used=1.50GiB
#uname -a
Linux workstation 3.14-1-amd64 #1 SMP Debian 3.14.2-1 (2014-04-28) x86_64 
GNU/Linux

Above is my workstation.  Below is the server/workstation my wife uses.

#btrfs fi balance start -dusage=0 -musage=0 / 
Done, had to relocate 0 out of 81 chunks
#btrfs fi balance start -dusage=0 -musage=0 / 
Done, had to relocate 0 out of 81 chunks
#btrfs fi balance start -dusage=1 -musage=1 / 
Done, had to relocate 1 out of 81 chunks
#btrfs fi balance start -dusage=1 -musage=1 / 
Done, had to relocate 1 out of 81 chunks
#btrfs fi balance start -dusage=1 -musage=1 / 
Done, had to relocate 1 out of 81 chunks
#btrfs fi balance start -dusage=0 -musage=0 / 
Done, had to relocate 0 out of 81 chunks
#btrfs fi df /
Data: total=75.01GB, used=52.32GB
System, DUP: total=32.00MB, used=16.00KB
Metadata, DUP: total=2.50GB, used=1.52GB
#uname -a
Linux server 3.14-trunk-amd64 #1 SMP Debian 3.14.1-1~exp1 (2014-04-17) x86_64 
GNU/Linux

> This will give more information on your current chunk situation. I
> suspect this is a case where a system chunk (which is included when
> specifying metadata) that is not actually being relocated. This is a bug
> that I believe was already fixed, though I'm not sure in which version.
> 
> The pathological case is where you have a chunk that is 1% full and
> *every* other in-use chunk on the device is 100% full. In that
> situation, a balance will simply move that data into a new chunk (which
> will only ever reach 1% full). Thus, all subsequent balances will
> relocate that same data again to another new chunk.

In that pathological case surely the correct thing to do is to not move that 
chunk.  If moving a chunk doesn't achieve filesystem tuning goals (EG 
converting to a different RAID level) and doesn't result in a decrease of the 
number of chunks in use then surely there's no point to doing it.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

