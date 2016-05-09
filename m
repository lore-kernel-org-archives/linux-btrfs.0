Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbcEIQhm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 12:37:42 -0400
Date: Mon, 9 May 2016 18:37:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add compatible layer for old e2fsprogs
Message-ID: <20160509163720.GM29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462769206-7211-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462769206-7211-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 09, 2016 at 12:46:46PM +0800, Qu Wenruo wrote:
> The new convert framework copies code from current dumpe2fs, which uses
> BIGALLOC feature introduced in e2fsprogs v1.42.
> 
> While there are a lot of enterprise distributions which are still using
> v1.41 e2fsprogs, this will cause compile error for them.
> 
> This patch introduce backward compatibility for new convert framework,
> by manually introduce macros for ext2 BIGALLOC feature.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I separated the configure and runtime checks and folded the rest to the
patch that used it, plus some minor tweaks.

Thanks for addressing the compatibility issue, it means that the convert
rework is in devel again :)
