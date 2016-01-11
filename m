Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681AbcAKPhN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 10:37:13 -0500
Date: Mon, 11 Jan 2016 16:34:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-corrupt-blocks: Include limits.h
Message-ID: <20160111153449.GG4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452395063-8414-1-git-send-email-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452395063-8414-1-git-send-email-raj.khem@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 09, 2016 at 07:04:23PM -0800, Khem Raj wrote:
> limits.h is needed for PATH_MAX definition
> 
> Fixes
> | btrfs-corrupt-block.c: In function 'corrupt_dir_item':
> | btrfs-corrupt-block.c:478:12: error: 'PATH_MAX' undeclared (first use in this function)
> |   char name[PATH_MAX];
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>

Applied, thanks.
