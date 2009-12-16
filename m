From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS major fault
Date: Wed, 16 Dec 2009 14:37:48 -0500
Message-ID: <20091216193748.GF3322@think>
References: <200912161829.38785.regomodo@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: regomodo <regomodo@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912161829.38785.regomodo@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 16, 2009 at 06:29:38PM +0000, regomodo wrote:
> I was running linux-kernel-2.6.32.1 and suspended my system using
> "hibernate-ram".
> 
> When I resumed the system was OK for a moment then froze up. I managed to
> get to tty1 easily and saw errors relating to btrfs.
> I did not manage to get the error down but it had an abbreviation of
> checksum and said maybe something about an inode/node.

These show disk corruption, which is also what the btrfsck errors
report.  How exactly are you doing suspend?

-chris
