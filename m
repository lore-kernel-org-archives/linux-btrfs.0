Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966780Ab3HHWFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 18:05:55 -0400
Date: Fri, 9 Aug 2013 00:05:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: set default max_inline to 8KiB instead of 8MiB
Message-ID: <20130808220553.GB5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 10:45:48PM +0100, Filipe David Borba Manana wrote:
> 8MiB is way too large and likely set by mistake. This is not
> a significant issue as in practice the max amount of data
> added to an inline extent is also limited by the page cache
> and btree leaf sizes.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
