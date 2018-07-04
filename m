Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752218AbeGDO5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 10:57:45 -0400
Date: Wed, 4 Jul 2018 16:57:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: declare fs_devices in btrfs_init_new_device()
Message-ID: <20180704145742.GS3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703051451.3673-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703051451.3673-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 01:14:50PM +0800, Anand Jain wrote:
> There are many instances of the %fs_info->fs_devices pointer
> de-reference, so declare a %fs_devices pointer instead.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

1-2 added to misc-next, thanks.
