From: Chris Mason <chris.mason@oracle.com>
Subject: Re: high cpu load for random write
Date: Wed, 1 Jul 2009 11:53:26 -0400
Message-ID: <20090701155326.GC22821@think>
References: <4A4A0AF1.9060107@cs.bgu.ac.il> <20090630134103.GB8345@think> <4A4B1E9F.1070201@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A4B1E9F.1070201@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 01, 2009 at 11:30:23AM +0300, Piavlo wrote:
>  Hi Chris,
> 
> I've tried a test with mount -o nodatacow and see no noticeable
> difference in cpu load.
> 
> Results with -o nodatacow (dmesg confirms "btrfs: setting nodatacow")
> Tiotest results for 1 concurrent io threads:

Well, it turns out that I broke nodatacow when I merged Christoph's attr
patch.  This high CPU usage during tiotest is all checksums.

The CPU times look like random writes are using much more CPU, but
really they are just doing much less IO (59MB vs 9000MB).  This makes
the CPU percentage look much higher because the test overall isn't
waiting on IO much at all.

Here are my results for your tiotest run with a fixed nodatacow:

test results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |   87.6 s | 102.774 MB/s |   0.4 %  |  11.4 % |
| Random Write   59 MBs |   40.7 s |   1.438 MB/s |   0.0 %  |   0.3 % |
`----------------------------------------------------------------------'

I'll queue the fix up for Linus.

-chris
