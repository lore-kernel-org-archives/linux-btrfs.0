From: Chris Samuel <chris@csamuel.org>
Subject: Re: version
Date: Tue, 25 Jan 2011 09:46:06 +1100
Message-ID: <4D3E012E.4070208@csamuel.org>
References: <BeTmYH9T1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeTmYH9T1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 25/01/11 08:39, Helmut Hullen wrote:

> Regard the difference between "df" and "btrfs filesystem df".

I suspect this is fixed in 2.6.38 with the following commit.

BE WARNED: there are some fairly hairy changes to the pathname
lookup code to replace the BKL with RCU (not specific to btrfs)
and so if you are tempted to try it (currently 2.6.38-rc2) only
do so on a system that you don't care about data on and/or have
very good incremental backups of which you trust...


commit 6d07bcec969af335d4e35b3921131b7929bd634e
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Wed Jan 5 10:07:31 2011 +0000

    btrfs: fix wrong free space information of btrfs

    When we store data by raid profile in btrfs with two or more
different size
    disks, df command shows there is some free space in the filesystem,
but the
    user can not write any data in fact, df command shows the wrong free
space
    information of btrfs.

[...]

    It is because btrfs cannot allocate chunks when one of the pairing
disks has
    no space, the free space on the other disks can not be used for
ever, and should
    be subtracted from the total space, but btrfs doesn't subtract this
space from
    the total. It is strange to the user.


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
