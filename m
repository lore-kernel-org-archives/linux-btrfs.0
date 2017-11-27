Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752217AbdK0UYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:24:40 -0500
Date: Mon, 27 Nov 2017 21:22:42 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: check the status of file at mkfs
Message-ID: <20171127202242.GJ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <adf7ec95-b00b-9101-76fe-6c41b90c7707@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <adf7ec95-b00b-9101-76fe-6c41b90c7707@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 24, 2017 at 02:21:15PM +0900, Misono, Tomohiro wrote:
> Currently, only the status of block devices is checked at mkfs,
> but we should also check for regular files whether they are already
> formatted or mounted to prevent overwrite accidentally.
> 
> Device status is checked by test_dev_for_mkfs().
> The part which is not related to block device is split from this
> and used for both block device and regular file.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied, thanks.
