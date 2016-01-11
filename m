Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbcAKJRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 04:17:02 -0500
Date: Mon, 11 Jan 2016 10:14:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs-progs: chunk-recovery: Fix a float point error
Message-ID: <20160111091438.GF4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5693102C.609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5693102C.609@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 10:15:08AM +0800, Qu Wenruo wrote:
> Hi David,
> 
> Would you please consider merging this patch for v4.2 btrfs-progs?

Do you really mean 4.2? The patch is queued for 4.4 release,
commit a99d13dccee11d29da3d045c2c2fc69d47eff770
