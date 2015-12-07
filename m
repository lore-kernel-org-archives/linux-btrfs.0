Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbbLGOjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 09:39:42 -0500
Date: Mon, 7 Dec 2015 15:37:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, codebird@birds-are-nice.me
Subject: Re: [PATCH V2] Btrfs: disable online scrub repair on ro cases
Message-ID: <20151207143743.GD4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
 <1449251884-24135-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449251884-24135-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 09:58:04AM -0800, Liu Bo wrote:
> This disables repair process on ro cases as it can cause system
> to be unresponsive on the ASSERT() in repair_io_failure().
> 
> This can happen when scrub is running and a hardware error pops up,
> we should fallback to ro mounts gracefully instead of being unresponsive.

So this will also report the error as uncorrectable. This might be a bit
misleading, if a device error happens first and then some potentially
corectable errors are detected. This could be accounted as 'unverified'
error, that has closet maning.
