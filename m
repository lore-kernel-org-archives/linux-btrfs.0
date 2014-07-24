Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbaGXLDB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 07:03:01 -0400
Date: Thu, 24 Jul 2014 13:02:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] Btrfs: fix off-by-one in cow_file_range_inline()
Message-ID: <20140724110259.GS1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1405568654-22120-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405568654-22120-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:44:11AM +0800, Wang Shilong wrote:
> Btrfs could still inline file data if its size is same as
> page size, so don't skip max value here.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
