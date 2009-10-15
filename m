From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: btrfs/iSCSI/sparse file OOPS.
Date: Thu, 15 Oct 2009 10:09:15 +0200
Message-ID: <4AD6D8AB.5030902@wpkg.org>
References: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

Ken D'Ambrosio wrote:
> Hey, all.  I've tried repeatedly to get an 800 GB sparse file on a 1 TB
> btrfs partition to work as an iSCSI target... and I can run fdisk on it
> (and see the iSCSI disk just fine), but when I try to create a partition
> and exit, it OOPSes every time.  Ubuntu, kernel 2.6.31-13-generic is the
> latest I've tried.  Is this a known bug?  I've tried Googling to no avail.
>  If there's anything I can do to help troubleshoot, please let me know.

You have IET as a target, correct? It is known to be quite buggy.

Please try either STGT (http://stgt.berlios.de) or SCST 
(http://scst.sf.net).


-- 
Tomasz Chmielewski
http://wpkg.org

