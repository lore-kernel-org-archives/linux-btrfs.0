Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbAWSKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 13:10:04 -0500
Date: Fri, 23 Jan 2015 19:10:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 2/2 RESEND] btrfs: introduce shrinker for rb_tree that
 keeps valid btrfs_devices
Message-ID: <20150123181001.GT13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421311988-11976-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1421311988-11976-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421311988-11976-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2015 at 04:53:08PM +0800, Gui Hecheng wrote:
> The following patch:
> 	btrfs: remove empty fs_devices to prevent memory runout
> 
> introduces @valid_dev_root aiming at recording @btrfs_device objects that
> have corresponding block devices with btrfs.
> But if a block device is broken or unplugged, no one tells the
> @valid_dev_root to cleanup the "dead" objects.
> 
> To recycle the memory occuppied by those "dead"s, we could rely on
> the shrinker. The shrinker's scan function will traverse the
> @valid_dev_root and trys to open the devices one by one, if it fails
> or encounters a non-btrfs it will remove the "dead" @btrfs_device.

I don't see why shrinker is used here.

linux.git/linux/shrinker.h:

"A callback you can register to apply pressure to ageable caches."

How is guaranteed that it will take action at the right time?
