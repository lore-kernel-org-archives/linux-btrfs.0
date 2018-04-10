Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754289AbeDJOvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 10:51:06 -0400
Date: Tue, 10 Apr 2018 16:48:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] Superblock read and verify cleanups
Message-ID: <20180410144836.GD2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180330000924.11148-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 08:09:16AM +0800, Anand Jain wrote:
> v3->v4:
>  Update changelog and signoff.
>  Reintroduce explicit check for '-EUCLEAN'
>   at Patch 2/8 and 5/8.
> 
> v2->v3:
>  Squash
>   4/8 btrfs: make btrfs_check_super_csum() non static
>  to
>   6/8 btrfs: verify superblock checksum during scan
>  As in the individual patch mentioned
>  
> v1->v2:
>  Various changes suggested by Nicokay. Thanks. For specific changes
>  pls ref to the patch.
> 
> Patch 1-4/8 are preparatory patches adds cleanups and nonstatic requisites.
> 
> Patch 5/8 makes sure that all copies of the superblock have the same fsid
> when we scan the device.

This is IMO too strict and the need of workaround puts the burden on the
user while it's not necessary and scan or mount can continue as long as
the first superblock is valid.

> Patch 6/8 verifies superblock csum when we read it in the scan context.

This was the main intention, as I read the discussion in the thread
under the RFC patch.

The semantics of scanning is not exactly defined, in the current code
it's "pick any device that has the right magic and sb offset", so adding
the csum check would add some validation but otherwise it's fine. All
the work is left to mount and all reported errors can be examined
immediatelly.

Wiping the magic either manually or by wipefs will not touch the csum,
so we don't change the behaviour.

Reporting errors on each scan is a usability no-go. Patches 1-4 look ok,
I'll have to think more about 5.
