Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549AbaGXLCV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 07:02:21 -0400
Date: Thu, 24 Jul 2014 13:02:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: fall into nocompression codes quickly if
 possible
Message-ID: <20140724110219.GR1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1405568654-22120-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405568654-22120-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:44:10AM +0800, Wang Shilong wrote:
> If flag NOCOMPRESS is set which means bad compression ratio,
> we could avoid call cow_file_range_async() for this case earlier.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
