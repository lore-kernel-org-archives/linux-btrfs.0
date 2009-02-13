From: Sander <sander@humilis.net>
Subject: Re: Bonnie++ run with RAID-1 on a single SSD
	(2.6.29-rc4-224-g4b6136c)
Date: Fri, 13 Feb 2009 14:27:07 +0100
Message-ID: <20090213132707.GA25924@cumulus>
References: <200902132331.12928.chris@csamuel.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200902132331.12928.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thank you for sharing your numbers.

Chris Samuel wrote (ao):
> For people who might be interested, here is how btrfs performs
> with two partitions on a single SSD drive in a RAID-1 mirror.
> 
> This is on a Dell E4200 with Core 2 Duo U9300 (1.2GHz), 2GB RAM
> and a Samsung SSD (128GB Thin uSATA SSD).

MLC SSDs are famous for their write stalls when the disk gets full and
old blocks need to be reused.

Do you experience that too? Or can you test that situation?

On your site you write:

"As SSD's are not necessarily as reliable as spinning disk yet for data
integrity .."

I've skimmed the article you link to. I still think SSDs are much more
reliable than spinning disks, especially the high end SLC SSDs.

What is the general opinion on this?

Could you also test without RAID1?
And with the compression mount flag?
And without the ssd mount flag?

> Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> sys26            2G           28299  17 18633  12           85702  29  3094  18
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16  7513  99 +++++ +++  5140  98  3964  67 +++++ +++  5652  99
> sys26,2G,,,28299,17,18633,12,,,85702,29,3093.9,18,16,7513,99,+++++,+++,5140,98,3964,67,+++++,+++,5652,99
> 
> real    3m51.883s
> user    0m0.360s
> sys     0m46.099s

I have no experience with Bonnie++, but based on the output it seems you
use a 2GB file while you have 2GB RAM. Is that a valid test?

Also the test run of only 3 minutes 52 seconds seems way too short.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
