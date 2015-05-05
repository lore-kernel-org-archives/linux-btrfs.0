Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993365AbbEEPU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 11:20:58 -0400
Date: Tue, 5 May 2015 17:20:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
Message-ID: <20150505152055.GH5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 05, 2015 at 02:16:38PM +0800, Qu Wenruo wrote:
> This patchset will introduce offline fsid/chunk tree uuid change
> function to btrfstune command, with "-u" and "-U" options respectively.
> 
> The implement is in-place btrfs_header modification, without transaction
> protection. So the uuid change can be done on any valid image even it is
> already full.
> 
> Since we don't use transaction to protect the convert, it's possible one
> can stop the running convert progress, causing the fs in a inconsistent
> status and unable to be mounted.
> To avoid such problem, we introduce new open ctree flags
> OPEN_CTREE_IGNORE_FSID, allowing btrfstune to finish the convert.

Code looks good to me. I'm not sure whether it should land in btrfstune
or in 'btrfs' proper.

* btrfstune should go away at some point, so I'd rather not add new
  features there

* 'btrfs property set -t filesystem uuid' seems best to me at this moment

A minor suggestion: set BTRFS_SUPER_FLAG_ERROR on the filesystem during
the conversion and drop it after it finishes successfully. It's merely a
hint that there's something wrong with the filesytem, the mount will
fail because filesystem uuid would not match the device id.
