Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbeFFO5W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 10:57:22 -0400
Date: Wed, 6 Jun 2018 16:54:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Yevgeny Popovych <yevgenyp@pointgrab.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: Fix traverse_directory() silently
 failing on some dirs
Message-ID: <20180606145435.GJ3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1527971171-49824-1-git-send-email-yevgenyp@pointgrab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527971171-49824-1-git-send-email-yevgenyp@pointgrab.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 02, 2018 at 11:26:11PM +0300, Yevgeny Popovych wrote:
> When traverse_directory() encounters an inode item that already exists
> and has a normal amount of hardlinks - it just continues with a next one,
> w/o clearing the ret value (set to -EEXIST).
> 
> But, if the last file traverse_directory() processes already has an
> inode item - traverse_directory() will silently exit with a
> bad return code, causing the prints like the following:
> 
>     unable to traverse directory initial-directory: 1
>     error wihle filling filesystem: 1
> 
> Fix this by clearing ret value before continuing with a next file.
> 
> Signed-off-by: Yevgeny Popovych <yevgenyp@pointgrab.com>

Thanks, there was a fix for that in pull request 124 and is in the devel
branch already.
