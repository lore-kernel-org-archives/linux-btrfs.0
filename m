Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbbKCMSv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 07:18:51 -0500
Date: Tue, 3 Nov 2015 13:17:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Rename variables in btrfs_add_to_fsid
Message-ID: <20151103121722.GL13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4372105ede489b71eec1af7720117900ddb6e427.1446520971.git.zhaolei@cn.fujitsu.com>
 <2b4af96b4d18a9b78f4febbec74e17675693752b.1446520971.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2b4af96b4d18a9b78f4febbec74e17675693752b.1446520971.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 03, 2015 at 11:23:37AM +0800, Zhao Lei wrote:
> There are two total_bytes in btrfs_add_to_fsid(), local variable
> of total_bytes means fs_total_bytes, and device->total_bytes means
> device's total_bytes.
> And device's total_bytes in argument is named block_count in current
> code.
> 
> This patch rename:
>  total_bytes -> fs_total_bytes
>  block_count -> device_total_bytes

This patch is actually 1/2, otherwise it does not compile. Applied in
reverse order.
