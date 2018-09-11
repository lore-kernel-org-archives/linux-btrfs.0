Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbeIKVq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 17:46:56 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5BF2ADC3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 16:46:46 +0000 (UTC)
Date: Tue, 11 Sep 2018 18:46:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: Don't return 1 if qgroup is marked
 inconsistent during relationship assignment
Message-ID: <20180911164644.GH2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180810023406.30303-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180810023406.30303-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 10:34:06AM +0800, Qu Wenruo wrote:
> BTRFS_IOC_QGROUP_ASSIGN ioctl could return >0 if qgroup is marked
> inconsistent after successful relationship assignment/removal.
> 
> We leak the return value as the final return value of btrfs command.
> But according to the man page, return value other than 0 means failure.
> 
> Fix this by resetting the return value to 0 for --no-rescan case.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
