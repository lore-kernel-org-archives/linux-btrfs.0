Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933260AbcJQPFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:05:25 -0400
Date: Mon, 17 Oct 2016 17:05:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, dsterba@suse.com,
        s.priebe@profihost.ag
Subject: Re: [PATCH 2/2] btrfs: fix false enospc for compression
Message-ID: <20161017150523.GM11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161006025139.22776-1-wangxg.fnst@cn.fujitsu.com>
 <20161006025139.22776-2-wangxg.fnst@cn.fujitsu.com>
 <57FDAA2A.5040505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57FDAA2A.5040505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 11:12:42AM +0800, Wang Xiaoguang wrote:
> hi,
> 
> Stefan often reports enospc error in his servers when having btrfs 
> compression
> enabled. Now he has applied these 2 patches to run and no enospc error 
> occurs
> for more than 6 days, it seems they are useful :)
> 
> And these 2 patches are somewhat big, please check it, thanks.

It is. As per testing results from Stefan and Holger, I'll add them to
for-next, but won't queue them for merging until they get Josef's
blessing.
