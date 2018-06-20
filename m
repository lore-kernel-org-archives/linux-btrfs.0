Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56947 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754046AbeFTOER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:04:17 -0400
Date: Wed, 20 Jun 2018 16:01:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: convert volume rotating flag into bitmap
Message-ID: <20180620140123.GA24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180604150030.12883-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180604150030.12883-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 04, 2018 at 11:00:28PM +0800, Anand Jain wrote:
> Add bitmap btrfs_fs_devices::volume_state to maintain the volume states and
> flags. This patch in perticular converts btrfs_fs_devices::rotating into
> flag BTRFS_VOLUME_STATE_ROTATING.

I'm not sure we need this. There are 2 flags, we don't need the
atomicity of test/set _bit, the values don't change too often so
protecting by the mutex should be suffictient.

The size of btrfs_device is also not a big concern, it will be stored in
the 512 byte kmalloc bin and it's size is close to the size so replacing
2 ints with one long will not gain anything.

The 3rd flag would cause other problems and is not the right solution to
the scan/mount problem.
