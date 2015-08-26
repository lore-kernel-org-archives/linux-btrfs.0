Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbbHZP5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 11:57:08 -0400
Date: Wed, 26 Aug 2015 17:56:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: Introduce open_btrfs_dir wrapper
Message-ID: <20150826155632.GA10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
 <f1ac41c81d460158be008fa8a02a06b22495a221.1440579753.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f1ac41c81d460158be008fa8a02a06b22495a221.1440579753.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 05:04:22PM +0800, Zhao Lei wrote:
> This patch introduce open_btrfs_dir() to open a dir in btrfs
> filesystem.
> 
> It can be used for several tools in btrfs-progs.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

I've renamed it to btrfs_open_dir and tweaked some error messages and
applied, thanks.
