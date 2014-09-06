Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36723 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaIFV6o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Sep 2014 17:58:44 -0400
Date: Sat, 6 Sep 2014 14:58:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20140906215830.GK23400@merlins.org>
References: <54077F27.1040603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54077F27.1040603@fb.com>
Subject: Re: Btrfs stable updates for v3.16
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 03, 2014 at 04:50:47PM -0400, Chris Mason wrote:
> Hi everyone,
> 
> For 3.16, please pull these into stable, I've cherry picked and tested
> them here.  For 3.15 and earlier there are a few conflicts, so I'll make
> a git tree with things to pull.
> 
> 8d875f95da43c6a8f18f77869f2ef26e9594fecc v3.15+

Hi Chris,

Would this patch you submitted be likely to fix the chrome profile
corruption needing restore from earlier snapshot problem we discussed a
few weeks back?

If so, yeah and thanks! :)
(compiling 3.16.2 now)


    btrfs: disable strict file flushes for renames and truncates
    
    commit 8d875f95da43c6a8f18f77869f2ef26e9594fecc upstream.
    
    Truncates and renames are often used to replace old versions of a file
    with new versions.  Applications often expect this to be an atomic
    replacement, even if they haven't done anything to make sure the new
    version is fully on disk.
    
    Btrfs has strict flushing in place to make sure that renaming over an
    old file with a new file will fully flush out the new file before
    allowing the transaction commit with the rename to complete.
    
    This ordering means the commit code needs to be able to lock file pages,
    and there are a few paths in the filesystem where we will try to end a
    transaction with the page lock held.  It's rare, but these things can
    deadlock.
    
    This patch removes the ordered flushes and switches to a best effort
    filemap_flush like ext4 uses. It's not perfect, but it should fix the
    deadlocks.
    
    Signed-off-by: Chris Mason <clm@fb.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
