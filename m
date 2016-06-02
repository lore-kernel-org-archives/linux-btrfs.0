Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022AbcFBRh6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 13:37:58 -0400
Date: Thu, 2 Jun 2016 19:37:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: convert: Fix a bug which fails to
 insert hole file extent
Message-ID: <20160602173719.GL29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160602072250.25214-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160602072250.25214-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 03:22:49PM +0800, Qu Wenruo wrote:
> When copying inode, if there is a file referring part of a hole range,
> convert will fail.
> 
> The problem is, when calculating real extent bytenr, it doesn't check if
> the original extent is a hole.
> 
> In case the orinal extent is a hole, we still calculate bytenr using
> file_pos - found_extent_file_pos, causing non-zero value, and later
> btrfs_record_file_extent() detects that we are pointing to non-exist
> extent and aborts convert.
> 
> Fix it by checking the disk_bytenr before calculating real disk bytenr.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
