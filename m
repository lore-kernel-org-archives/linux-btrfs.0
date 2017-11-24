Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40843 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752367AbdKXOsy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 09:48:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4258AAAD
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 14:48:53 +0000 (UTC)
Date: Fri, 24 Nov 2017 15:46:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] Lowmem mode btrfs fixes exposed by complex tree
Message-ID: <20171124144658.GW3553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171122090325.29458-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 05:03:14PM +0800, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
> 
> The patchset is mostly rebased to v4.14, since there is some conflicts
> with lowmem repair enhancement from Su Yue.
> 
> However the lowmem repair enhancement from Su Yue caused one regression,
> and the original lowmem code also has some problem handling tree reloc
> tree.

Thanks for the fixes, patchset added to devel. I've also enabled the
lowmem mode in the CI build tests.
