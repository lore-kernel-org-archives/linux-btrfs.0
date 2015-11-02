Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbKBOhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 09:37:01 -0500
Date: Mon, 2 Nov 2015 15:35:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: show-super: Add option to print superblock
 at given bytenr
Message-ID: <20151102143532.GH13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446453259-31917-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446453259-31917-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 04:34:19PM +0800, Qu Wenruo wrote:
> Add '-s <sb_bytenr>' option to show superblock at given bytenr.
> 
> This is very useful to debug non-standard btrfs, like debuging the
> 1st stage btrfs of btrfs-convert.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
