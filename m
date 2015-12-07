Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbbLGS0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 13:26:15 -0500
Date: Mon, 7 Dec 2015 10:26:05 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, codebird@birds-are-nice.me
Subject: Re: [PATCH V2] Btrfs: disable online scrub repair on ro cases
Message-ID: <20151207182551.GA23357@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
 <1449251884-24135-1-git-send-email-bo.li.liu@oracle.com>
 <20151207143743.GD4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151207143743.GD4227@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2015 at 03:37:43PM +0100, David Sterba wrote:
> On Fri, Dec 04, 2015 at 09:58:04AM -0800, Liu Bo wrote:
> > This disables repair process on ro cases as it can cause system
> > to be unresponsive on the ASSERT() in repair_io_failure().
> > 
> > This can happen when scrub is running and a hardware error pops up,
> > we should fallback to ro mounts gracefully instead of being unresponsive.
> 
> So this will also report the error as uncorrectable. This might be a bit
> misleading, if a device error happens first and then some potentially
> corectable errors are detected. This could be accounted as 'unverified'
> error, that has closet maning.

Make sense, we can do
if (ret < 0 && ret == -EROFS)
	spin_lock();
	unverified++;
	spin_unlock()

However, in scrub_fixup_nodatasum() all errors including ENOMEM of path
allocation and failure of trans are interpreted to 'uncorrectable', So I
wander it means this 'uncorrectable' is only valid in this scrub process?

Thanks,

-liubo
