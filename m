Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbGXMKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 08:10:19 -0400
Date: Fri, 24 Jul 2015 14:10:11 +0200
From: David Sterba <dsterba@suse.com>
To: Omar Sandoval <osandov@fb.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] btrfs/011: test replace on RAID 5/6 now that it's
 supported
Message-ID: <20150724121011.GU6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <cover.1437683940.git.osandov@fb.com>
 <769c314845bd9341f93062204cbe435586674b1f.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <769c314845bd9341f93062204cbe435586674b1f.1437683940.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 01:51:49PM -0700, Omar Sandoval wrote:
> btrfs replace has been supported on RAID 5/6 since Linux 3.19.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
