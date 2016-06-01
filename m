Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbcFANn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:43:26 -0400
Date: Wed, 1 Jun 2016 15:42:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Fix bugs in backup superblock
 migration
Message-ID: <20160601134247.GY29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160601082226.24166-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601082226.24166-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 04:22:26PM +0800, Qu Wenruo wrote:
> New convert has several bugs with backup superblock migration
> 
> 1) Backup superblocks are not migrated due to bad judgement
>    Two wrong judgement cause backup superblocks are not migrated at all
> 
> 2) Converted ext* image doesn't keep hole for backup superblocks
>    Since we are creating file extents according to tmp_used, which has
>    wiped out backup superblock ranges.
>    In that case, later superblock migration will fail, since migration
>    will insert file extent range into ext* image.
> 
> Fix above bugs will make convert on ext2 image filled about 100M data
> successful.
> 
> Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Patch updated, thanks.
