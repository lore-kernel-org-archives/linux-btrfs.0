Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965424AbbEMQSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:18:02 -0400
Date: Wed, 13 May 2015 18:18:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH 1/4] btrfs-progs: Remove non-exist csum size.
Message-ID: <20150513161800.GP23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431508536-7275-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431508536-7275-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:33PM +0800, Qu Wenruo wrote:
> Current btrfs only support CRC32 as checksum algorithm.
> But in btrfs_csum_sizes array, we have an extra 0 at tail, causing
> csum_type 1 can still be considered as supported csum type.
> 
> Fix it by removing the tailing 0.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
