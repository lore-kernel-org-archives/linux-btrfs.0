Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426Ab3LIRoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 12:44:03 -0500
Date: Mon, 9 Dec 2013 18:44:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: convert printk to btrfs_ and fix BTRFS prefix
Message-ID: <20131209174400.GE10658@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384981051-5153-1-git-send-email-fholton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384981051-5153-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 03:57:31PM -0500, Frank Holton wrote:
> Convert all applicable cases of printk and pr_* to the btrfs_* macros.
> 
> Fix all uses of the BTRFS prefix.

Looks reasonably ok, I like to see the transition to btrfs_* print
functions and making the prefix consistent.

Reviewed-by: David Sterba <dsterba@suse.cz>
