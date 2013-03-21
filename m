Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab3CUNtw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 09:49:52 -0400
Date: Thu, 21 Mar 2013 14:49:50 +0100
From: David Sterba <dsterba@suse.cz>
To: jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org, Simon Kirby <sim@hostway.ca>
Subject: Re: [PATCH v2] Btrfs: Include the device in most error printk()s
Message-ID: <20130321134950.GI31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130319224123.GA4779@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130319224123.GA4779@hostway.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 19, 2013 at 03:41:23PM -0700, Simon Kirby wrote:
> Use btrfs_printk(fs_info, format, ...) rather than writing the device
> string every time, and introduce macro wrappers ala XFS for brevity.
> Since the function already cannot be used for continuations, print a
> newline as part of the btrfs_printk() message rather than at each caller.

Josef, some the patches I've sent yestreday are in conflict with this
patch, please drop them and I'll resend when this patch is merged.

thanks,
david
