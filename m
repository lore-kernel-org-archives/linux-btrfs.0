From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warning and oops running bonnie
Date: Tue, 09 Sep 2008 06:35:35 -0400
Message-ID: <1220956535.29741.29.camel@think.oraclecorp.com>
References: <ga580b$nhd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ga580b$nhd$1@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-09-09 at 08:18 +0100, Frank Kingswood wrote:
> Hallo!
> 
> I was running bonnie to compare btrfs to alternatives, see where it is 
> in terms of relative performance. It looks good (but has very high CPU 
> usage, is that expected?), but then I get a warning and later an oops.
> 
> This is using two >9GB partitions, and bonnie running with 3GB and later 
> 9GB.
> 
> kernel: Btrfs v0.16+417d87e57364 loaded
> 
> Here begins the first run, mkfs -d raid0
> 
> kernel: device label test devid 1 transid 7 /dev/sda2
> kernel: device label test devid 2 transid 7 /dev/sdb2
> kernel: device label test devid 1 transid 12 /dev/sda2
> kernel: space info full 9
> 
> but it completes bonnie.
> 
> Here begins the second run, mkfs -d raid1
> 
> kernel: device label test devid 1 transid 7 /dev/sda2
> kernel: device label test devid 2 transid 7 /dev/sdb2
> kernel: device label test devid 1 transid 12 /dev/sda2
> kernel: space info full 17
> kernel: Unable to find block group for 9183821824

Well, you're hitting a variant of the enospc code.  My guess is that
you've filled up the volume to the point where everything is allocated
as a data extent, then deleted the file to make room then tried run #2.

How big is the volume and how big are the files created by each run?

-chris


