From: Sander <sander@humilis.net>
Subject: Re: btrfs/iSCSI/sparse file OOPS.
Date: Thu, 15 Oct 2009 08:39:56 +0200
Message-ID: <20091015063956.GA25256@cumulus>
References: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ken,

Ken D'Ambrosio wrote (ao):
> Hey, all. I've tried repeatedly to get an 800 GB sparse file on a 1 TB
> btrfs partition to work as an iSCSI target... and I can run fdisk on it
> (and see the iSCSI disk just fine), but when I try to create a partition
> and exit, it OOPSes every time. Ubuntu, kernel 2.6.31-13-generic is the
> latest I've tried. Is this a known bug? I've tried Googling to no avail.
> If there's anything I can do to help troubleshoot, please let me know.

While this obviously won't solve the bug, it might help you proceed:
could you live with not having partitions on the iSCSI disk and just use
the whole disk?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
