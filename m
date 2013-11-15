Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab3KOO4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 09:56:43 -0500
Date: Fri, 15 Nov 2013 15:56:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Prefix with "ERROR:" the error messages of mkfs
Message-ID: <20131115145641.GA8035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384511376-14740-1-git-send-email-kreijack@inwind.it>
 <1384511376-14740-2-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384511376-14740-2-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 11:29:36AM +0100, Goffredo Baroncelli wrote:
> Add the ERROR prefix to the error messages of mkfs, to align it
> to the btrfs main utility style.
> 
> The patch increase the buffer size of test_dev_for_mkfs() and
> test_num_disk_vs_raid() for the error message from 100 to 150
> because the former become too small.

This was discussed some time ago, that the error message should not be
passed that way via caller-provided variable.

I'd tend to take this patch now because of the improved messages.
