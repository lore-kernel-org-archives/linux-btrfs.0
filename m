Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeEKK4l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:56:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 61CBFAEA4
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:56:40 +0000 (UTC)
Date: Fri, 11 May 2018 12:54:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] btrfs: Add write time super block validation
Message-ID: <20180511105402.GV6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511053527.28378-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:35:24PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_sb_check
> 
> We have 2 reports about corrupted btrfs super block, which has some garbage
> in its super block, but otherwise it's completely fine and its csum even
> matches.
> 
> This means we develop memory corruption during btrfs mount time.
> It's not clear whether it's caused by btrfs or some other kernel module,
> but at least let's do write time verification to catch such corruption
> early.
> 
> Current design is to do 2 different checks at mount time and super write
> time.
> And for write time check, it only checks the template super block
> (fs_info->super_to_commit) other than each super blocks to be written to
> disk, mostly to avoid duplicated checks.
> 
> Changelog:
> v2:
>   Rename btrfs_check_super_valid() to btrfs_validate_super() suggested
>   by Nikolay and David.
> v3:
>   Add a new patch to move btrfs_check_super_valid() to avoid forward
>   declaration.
>   Refactor btrfs_check_super_valid() to provide better naming and
>   function reusablity.
>   Code style and comment update.
>   Use 2 different functions, btrfs_validate_mount_super() and
>   btrfs_validate_write_super(), for mount and write time super check.

Added as topic branch to next, I'm still targeting 4.18 with this
patchset so it'll end up in misc-next after some testing. Thanks.
