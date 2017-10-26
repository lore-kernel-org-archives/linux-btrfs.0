Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbdJZSiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:38:25 -0400
Date: Thu, 26 Oct 2017 20:36:35 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] btrfs-progs: fi: enable fi usage for filesystem top
 of seed device
Message-ID: <20171026183635.GG3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <01e66c4f-9f8d-0bf2-1f7a-bc5784a907f3@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01e66c4f-9f8d-0bf2-1f7a-bc5784a907f3@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 23, 2017 at 01:43:23PM +0900, Misono, Tomohiro wrote:
> Currently "fi usage" (and "dev usage") cannot run for the filesystem using
> seed device.
> 
> This is because FS_INFO ioctl returns the number of devices excluding
> seeds, but load_device_info() tries to access valid device from devid 0
> to max_id, and results in accessing seeds too (thus causing mismatching
> of number of devices).
> 
> Since only the size of non-seed devices is matter, fix this by just
> skipping seed device by checking device's fsid and comparing it to the fsid
> obtained by FS_INFO ioctl.
> 
> Tomohiro Misono (2):
>  btrfs-progs: fi: move dev_to_fsid() to cmds-fi-usage for later use
>  btrfs-progs: fi: enable fi usage for filesystem top of seed device

Applied, thanks.
