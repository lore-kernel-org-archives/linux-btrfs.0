From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs standalone tree regenerated
Date: Mon, 15 Dec 2008 15:55:51 -0500
Message-ID: <1229374551.16295.26.camel@think.oraclecorp.com>
References: <541783609@web.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <541783609@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-12-14 at 00:16 +0100, devzero@web.de wrote:
> Hello !
> 
> is there a way to get btrfs-unstable source without using git ?
> 
> i`m trying for a while now, but it seems git doesn`t work as desired on my system or the problem is that i`m behind http proxy.
> 
> what about some unstable snapshots in http://www.kernel.org/pub/linux/kernel/people/mason/btrfs/ ?

Hello everyone,

I've redone the standalone tree because it had a broken commit in it.
If you're pulling from the standalone tree, you might need to clone it
from scratch to avoid having a repo with two heads.

Sorry for the hassle, I didn't realize the initial setup of the stand
alone tree wasn't quite right.

The good news is that http pulls should work now.

-chris


