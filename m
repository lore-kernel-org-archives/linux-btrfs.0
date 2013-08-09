Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab3HIMvj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 08:51:39 -0400
Date: Fri, 9 Aug 2013 14:51:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: add dedup subcommand
Message-ID: <20130809125134.GJ5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
 <1375950946-5470-7-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375950946-5470-7-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 04:35:46PM +0800, Liu Bo wrote:
> This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> ie. register/unregister'.

I'm not sure that calling it register/unregister is the right thing, IMO
it's more enable/disable as you write in the documentation under each
respective command.

Please post a list of the other commands if there are any, and the
expected usage.

thanks,
david

> +\fBbtrfs dedup register\fP \fI<path>\fP
> +Enable data deduplication support for a filesystem.
   ^^^^^

> +.TP
> +
> +\fBbtrfs dedup unregister\fP \fI<path>\fP
> +Disable data deduplication support for a filesystem.
   ^^^^^^^
