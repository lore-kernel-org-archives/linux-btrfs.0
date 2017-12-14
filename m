Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbdLNOXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 09:23:37 -0500
Date: Thu, 14 Dec 2017 15:21:35 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/4] btrfs: cleanup mount path
Message-ID: <20171214142135.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 14, 2017 at 05:23:33PM +0900, Misono, Tomohiro wrote:
> Summary:
> Cleanup mount path by avoiding calling btrfs_mount() twice.
> No functional changes. See below for longer explanation.
> 
> Changelog:
> v4: 
>   - Rebased to v4.15-rc3
>       - Change MS_* flags to SB_* flags
>       - Change GFP_NOFS to GFP_KERNEL
>     - Use if statements instead of switch in parse_early_options() 
>     - Name change (mount_root -> btrfs_mount_root) and add some comments

Thanks, patches moved to the misc-next queue.
