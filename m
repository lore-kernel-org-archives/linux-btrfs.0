Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41517 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752464AbdK1PqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:46:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26C9CAE74
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 15:46:13 +0000 (UTC)
Date: Tue, 28 Nov 2017 16:44:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/7] btrfs-progs: mkfs: Reword --rootdir
Message-ID: <20171128154416.GT3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020015907.25430-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:59:00AM +0800, Qu Wenruo wrote:
> Qu Wenruo (7):
>   btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
>   btrfs-progs: mkfs/rootdir: Use over-reserve method to make size
>     estimate easier
>   btrfs-progs: mkfs: Only zero out the first 1M for rootdir
>   btrfs-progs: mkfs/rootdir: Introduce function to get end position of
>     last device extent
>   btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
>   btrfs-progs: mkfs: Update allocation info before verbose output
>   btrfs-progs: mkfs: Separate shrink from rootdir

I've merged independent patches or what applied almost cleanly on
current devel. Please refresh and resend patches 1, 2, 5 and 7, thanks.
