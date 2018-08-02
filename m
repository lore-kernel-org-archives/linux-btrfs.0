Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbeHBVzr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 17:55:47 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DA80AD3A
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 20:03:07 +0000 (UTC)
Date: Thu, 2 Aug 2018 22:03:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Some random fuzz test fixes
Message-ID: <20180802200303.GV3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180705073731.18459-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705073731.18459-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 03:37:27PM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/fuzzed_enhance
> 
> Some random bugs exposed by the ill-fated fuzz-test (003 never seems to
> pass).
> 
> It will be a big work to make fuzz/003 to pass, but at least there are
> some easy fixes.

Great, that counts too.

> Qu Wenruo (4):
>   btrfs-progs: check: Remove the ability to rebuild root overwritting
>     existing tree blocks
>   btrfs-progs: transaction: Error out other than panic when committing
>     transaction
>   btrfs-progs: check/original: Avoid infinite loop when failed to repair
>     inode
>   btrfs-progs: check/original: Don't overwrite return value when we
>     failed to repair

Thanks, all applied.
