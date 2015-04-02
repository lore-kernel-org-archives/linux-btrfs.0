Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbbDBPpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 11:45:51 -0400
Date: Thu, 2 Apr 2015 17:45:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: convert: Make ext*_image file obey
 datacsum setting.
Message-ID: <20150402154550.GN6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 10:21:35AM +0800, Qu Wenruo wrote:
> Before this patch, ext*_image is always set NODATACSUM inode flag.
> However btrfs-convert will set normal file with DATACUSM flag by
> default, and generate checksum for regular file extent.
> 
> Now, a regular file extent is shared by a btrfs file inode with DATACSUM
> and ext*_image with NODATACSUM, and it has checksum in csum tree.
> This will cause btrfsck complain about odd checksum, since ext*_image is
> set NODATACSUM but has checksum generated from regular file extent.
> 
> This patch makes convert completely obey datacsum setting, meaning
> btrfs-convert will generate csum for every file extent by default.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
