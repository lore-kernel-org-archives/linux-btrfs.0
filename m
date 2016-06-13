Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424144AbcFMPrm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 11:47:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 63223AAAD
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 15:47:35 +0000 (UTC)
Date: Mon, 13 Jun 2016 17:48:14 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: prefix fsid to all trace events
Message-ID: <20160613154814.GC6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465516081-26045-1-git-send-email-jeffm@suse.com>
 <1465516081-26045-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465516081-26045-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2016 at 07:48:01PM -0400, jeffm@suse.com wrote:
> +#define TP_printk_btrfs(fmt, args...) \
> +	TP_printk("%pU: " fmt, __entry->fsid, args)

So it's identified by the UUID. As there's no previous format of the
filesystem identifier (unlike the syslog messages), I'm ok with using
the UUID.
