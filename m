Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaIOQPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 12:15:43 -0400
Date: Mon, 15 Sep 2014 18:15:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: force overwrite should wipe stale SB
Message-ID: <20140915161541.GF9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409932284-30895-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409932284-30895-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 05, 2014 at 11:51:24PM +0800, Anand Jain wrote:
> Here is a test case which says it all..
> 
> mkfs.xfs -f $DEV
> mkfs.btrfs -f $DEV
> mount $DEV $MNT
> mount: /dev/vdiskc: more filesystems detected. This should not happen,
>        use -t <type> to explicitly specify the filesystem type or
>        use wipefs(8) to clean up the device.
> 
> mount: you must specify the filesystem type
> 
> with this patch btrfs_prepare_device() also wipes old FS if any,
> btrfs_prepare_device() is called after we have verified that
> user has provided -f option.

Good catch.
