Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35407 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750884AbdEBOfA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:35:00 -0400
Date: Tue, 2 May 2017 16:34:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Use more restrict check to read out tree
 root
Message-ID: <20170502143453.GJ23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170425084016.26278-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425084016.26278-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 25, 2017 at 04:40:16PM +0800, Qu Wenruo wrote:
> For fuzzed image bko-156811-bad-parent-ref-qgroup-verify.raw, it cause
> qgroup to report -ENOMEM.
> 
> But the fact is, such image is heavy damaged so there is not valid root
> item for extent tree.
> 
> Normal extent tree key in root tree should be (EXTENT_TREE ROOT_ITEM 0),
> while in that fuzzed image, we got (EXTENT_TREE EXXTENT_DATA SOME_NUMBER).
> 
> It's btrfs_find_last_root() that only checks the objectid, not caring
> key type leads to such problem.
> 
> Fix by doing extra check on key type for such case.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
