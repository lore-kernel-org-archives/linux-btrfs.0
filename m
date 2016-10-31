Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944378AbcJaQmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 12:42:04 -0400
Date: Mon, 31 Oct 2016 17:42:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: cleanup: use already calculated value in
 btrfs_should_throttle_delayed_refs()
Message-ID: <20161031164201.GQ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161026072301.6748-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026072301.6748-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 03:23:01PM +0800, Wang Xiaoguang wrote:
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
