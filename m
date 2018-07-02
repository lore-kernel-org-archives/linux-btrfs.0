Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752610AbeGBP7I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 11:59:08 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EE91ADAF
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 15:59:07 +0000 (UTC)
Date: Mon, 2 Jul 2018 17:58:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: relocation: Only remove reloc rb_trees if reloc
 control has been initialized
Message-ID: <20180702155859.GC3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180702062538.30794-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180702062538.30794-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 02:25:38PM +0800, Qu Wenruo wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199833, where an
> invalid tree reloc tree can cause kernel NULL pointer dereference when
> btrfs does some cleanup for reloc roots.
> 
> It turns out that fs_info->reloc_ctl can be NULL in
> btrfs_recover_relocation() as we allocate relocation control after all
> reloc roots are verified.
> So when we hit out: tag, we haven't call set_reloc_control() thus
> fs_info->reloc_ctl is still NULL.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks for the fix, patch added to the queue. I've added the fuzzed
image from bugzilla to btrfs-progs.
