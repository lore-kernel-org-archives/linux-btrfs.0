Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbcIIJES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 05:04:18 -0400
Date: Fri, 9 Sep 2016 11:02:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, s.priebe@profihost.ag
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
Message-ID: <20160909090240.GQ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
 <57D271EB.3000209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57D271EB.3000209@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 09, 2016 at 04:25:15PM +0800, Wang Xiaoguang wrote:
> hello David,
> 
> This patch's v2 version in your for-next-20160906 branch is still wrong, 
> really sorry,
> please revert it.

Patch replaced with V3 in the upcoming for-next.

> Stefan Priebe has reported another similar issue, thought I didn't see 
> it in my
> test environment. Now I choose to not call down_read(bg_delete_sem) for free
> space inode, which I think can resolve these issues, please check, thanks.
