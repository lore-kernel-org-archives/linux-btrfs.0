Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757750AbcJQNmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 09:42:07 -0400
Date: Mon, 17 Oct 2016 15:42:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make file clone aware of fatal signals
Message-ID: <20161017134205.GJ11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161013012339.30387-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161013012339.30387-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 09:23:39AM +0800, Wang Xiaoguang wrote:
> Indeed this just make the behavior similar to xfs when process has
> fatal signals pending, and it'll make fstests/generic/298 happy.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
