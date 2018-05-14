Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52873 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753435AbeENNjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 09:39:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2CD0DAB33
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 13:39:43 +0000 (UTC)
Date: Mon, 14 May 2018 15:37:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: qgroup rescan fixes part 1
Message-ID: <20180514133701.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180514013813.30763-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180514013813.30763-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 09:38:11AM +0800, Qu Wenruo wrote:
> This patchset is mainly focused on fixing qgroup rescan corruption.
> 
> Since the whole btrfs qgroup is based on the modification between 2
> transactions, it only has correct qgroup delta.
> While if the rescan can't provide a correct result from the very
> beginning, qgroup numbers are corrupted.
> 
> The patchset is fixing two types of qgroup corruption which could happen
> by looping btrfs/017 with some possibility.
> 
> 1) Not accounting tree blocks
>    Caused by the fact that qgroup rescan only searches commit root for
>    backref, while we're passing current extent root to search.
>    Fix it by also passing commit extent root.
> 
> 2) Double accounting tree blocks
>    Caused by wrong rescan exit condition.
>    Currently qgroup only exit when it can't find any leaves beyond
>    rescan progress.
>    However it could cause problem when new transaction happens after
>    last rescan, and old leaves CoWed to new location, and double
>    accounting could happen.
>    Fix it by checking and leave qgroup rescan if we have hit last leaf,
>    instead of leaving it to next leaf rescan.
> 
> 
> Changelog:
> v2:
>   Remove unused tree_mod_seq_elem for the 1st patch.
>   Fix double unlock in 2nd patch.
>   Thanks Jeff for the update.

V1 patches replaced, thanks.
