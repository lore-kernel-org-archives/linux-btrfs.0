Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754214AbcIIPVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 11:21:42 -0400
Date: Fri, 9 Sep 2016 17:20:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH v13 00/15] Btrfs In-band De-duplication
Message-ID: <20160909152004.GV16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 03:12:49PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux.git wang_dedupe_20160907
> 
> This version is just another small update, rebased to David's
> for-next-20160906 branch.

I've rebased it locally to the 4.9 patch queue and Josef's btree-inode
branch, now pushed to for-next-test. It's really for testing only
