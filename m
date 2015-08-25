Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbbHYR0u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:26:50 -0400
Date: Tue, 25 Aug 2015 19:26:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: close all fs_devices before exit in
 some commands
Message-ID: <20150825172614.GT10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9f0cf7c0a07faefb4f3af86f8e7c63b56a338b7a.1440405874.git.zhaolei@cn.fujitsu.com>
 <d9ee6fee7b49a43f2ff6c24306f4cf69a7c45ae1.1440405874.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d9ee6fee7b49a43f2ff6c24306f4cf69a7c45ae1.1440405874.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2015 at 04:45:03PM +0800, Zhao Lei wrote:
> mkfs created more than one fs_devices in fs_uuids.
> 1: one is for file system been created
> 2: others are created in test_dev_for_mkfs for check mount point
>    test_dev_for_mkfs()-> ... -> btrfs_scan_one_device()
> 
> Current code only close above 1, and this patch close above 2.
> 
> Similar problem exist in other tools, for ex:
>  cmd-check.c: the function is:
>  cmd_check()->check_mounted()-> ... -> btrfs_scan_one_device()
>  ...
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
