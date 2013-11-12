Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3KLQRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 11:17:49 -0500
Date: Tue, 12 Nov 2013 17:17:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Fixup usage of btrfs: prefix in syslog
Message-ID: <20131112161747.GD9132@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384154835-7037-1-git-send-email-fholton@gmail.com>
 <1384154835-7037-2-git-send-email-fholton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384154835-7037-2-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 11, 2013 at 02:27:15AM -0500, Frank Holton wrote:
> Change all uses of printk to use the btrfs: prefix for
> easier grepping of kernel log.

There is a set of functions that wrap the printed messages (btrfs_info,
btrfs_err, ...) and enhance them with device info etc. Please use them
instead where applicable.

david
