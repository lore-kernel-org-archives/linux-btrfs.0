Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3ACQhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 11:37:38 -0500
Date: Thu, 3 Jan 2013 17:37:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] Btrfs: remove deprecated comments
Message-ID: <20130103163736.GC20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 27, 2012 at 05:01:17PM +0800, Liu Bo wrote:
> commit d53ba47484ed6245e640ee4bfe9d21e9bfc15765
> (Btrfs: use commit root when loading free space cache) has remove
> the deadlock check, and the related comments can be removed as well.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

1-8
Reviewed-by: David Sterba <dsterba@suse.cz>

I'd prefer some cover letter next time as you mix cleanups and speed
optimizations (a short description stating that would suffice regarding
this patch series) or send them in separate series.

thanks,
david
