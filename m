Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56464 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHVSqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:46:36 -0400
Date: Fri, 22 Aug 2014 11:46:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140822184632.GD3875@merlins.org>
References: <20140822155040.GU3875@merlins.org>
 <53F77EAB.5070309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F77EAB.5070309@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 12:32:27PM -0500, Eric Sandeen wrote:
> On 8/22/14, 10:50 AM, Marc MERLIN wrote:
> 
> > But if my kernel hangs due to a bug that isn't btrfs' fault and I need
> > to power off and back on, after reboot my google-chrome profile is
> > almost always broken in some way.
> 
> Given my experiences with userspace in general, I'd lay money on
> google-chrome simply not DTRT WRT data integrity syscalls (or
> maybe it's the sqlite database handling underneath...)
> 
> Does it behave any differently on other filesystems?

Well
1) I used to work on chromeos until some months back, and haven't heard
on this problem with chrome/linux
2) never had a chrome corruption problem on a non btrfs filesystem
3) as mentioned, my btrfs snapshots are somehow always consistent for
chrome, which if chrome were not flushing its buffers right, wouldn't
happen.

Incidently, I just had to rebuild my mysqldb on my laptop after it got
corrupted in a way that was non recoverable.
Mysql surely knows how to flush and have consistent state points.

In my experience, linux crashes cause btrfs to somehow end up with non
consistent states on disk. Whether it's a bug in the btrfs code, the
linux block subsystem or sata driver, or firmware bugs on all 5 SSDs
I've had so far, I can't say, but there is a problem somewhere for sure.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
