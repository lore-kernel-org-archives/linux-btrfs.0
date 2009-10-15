From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: btrfs/iSCSI/sparse file OOPS.
Date: Thu, 15 Oct 2009 09:06:09 +0200
Message-ID: <20091015070608.GC9228@kernel.dk>
References: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13 2009, Ken D'Ambrosio wrote:
> Hey, all.  I've tried repeatedly to get an 800 GB sparse file on a 1 TB
> btrfs partition to work as an iSCSI target... and I can run fdisk on it
> (and see the iSCSI disk just fine), but when I try to create a partition
> and exit, it OOPSes every time.  Ubuntu, kernel 2.6.31-13-generic is the
> latest I've tried.  Is this a known bug?  I've tried Googling to no avail.
>  If there's anything I can do to help troubleshoot, please let me know.
> 
> Thanks!
> 
> -Ken
> 
> P.S.  FYI, tried the same thing on a reiserfs partition on the same
> system, worked fine.

Looks like that iscsi target relies on having fops->aio_write() there,
which btrfs doesn't have. It's a bug in the iscsi driver.

-- 
Jens Axboe

