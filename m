Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933728AbbEMQSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:18:24 -0400
Date: Wed, 13 May 2015 18:18:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to avoid
 btrfs-progs crash.
Message-ID: <20150513161823.GQ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:36PM +0800, Qu Wenruo wrote:
> Adds extra check when reading a chunk item:
> 1) Check chunk type.
> Don't allow any unsupported type/profile bit.
> 
> 2) Check num_stripes
> Any chunk item should contain at least one stripe.
> For system chunk, the chunk item size(calculated by btrfs_stripe size *
> (num_stripes - 1) + btrfs_chunk size) should not exceed
> BTRFS_SYSTEM_CHUNK_SIZE(2048).
> For normal chunk, the chunk item size(calculated) should match the chunk
> item size.
> 
> 3) Check num_stripes/sub_stripes against chunk profile.
> Num_stripes/sub_stripes must meet its lower limit for its chunk profile.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
