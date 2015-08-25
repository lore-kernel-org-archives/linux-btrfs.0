Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbbHYRWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:22:13 -0400
Date: Tue, 25 Aug 2015 19:21:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Introduce btrfs_close_all_devices to
 close all fs_devices in fs_uuids list
Message-ID: <20150825172137.GS10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2015 at 04:45:02PM +0800, Zhao Lei wrote:
> If more than one fs_devices in fs_uuids list(as mkfs.btrfs), we need
> close them all before exit.
> This function is for above propose.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
