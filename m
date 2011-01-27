From: Chris Samuel <chris@csamuel.org>
Subject: 2.6.38-rc2 oops's when rebalancing on different size drives (was
 Re: version)
Date: Thu, 27 Jan 2011 16:02:09 +1100
Message-ID: <4D40FC51.8030300@csamuel.org>
References: <BeXoKKFD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeXoKKFD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 26/01/11 01:37, Helmut Hullen wrote:

> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)

Oh dear, those are errors from the block layer, looks like
btrfs is doing something wrong there.. :-(

> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/volumes.c:2097!

It looks like btrfs isn't handling errors coming back from the
block layer - at that point it's just called btrfs_relocate_chunk()..

So my guess is that the rebalancing code is naive and assumes
the drives are the same size - but I can't quite follow what
the code above that BUG_ON() is doing to verify that..

Chris M. ?

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
