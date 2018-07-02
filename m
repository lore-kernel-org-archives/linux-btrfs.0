Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753258AbeGBWTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 18:19:09 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99E88AD52
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 22:19:07 +0000 (UTC)
Date: Tue, 3 Jul 2018 00:19:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Fix wrong root parameter of
 btrfs_next_leaf call
Message-ID: <20180702221902.GF3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529320239-23033-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529320239-23033-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 02:10:39PM +0300, Nikolay Borisov wrote:
> The first thing that check_chunks_and_extents does is to iterate all
> the root items in the root tree and link them to either the "normal_list"
> or "dropping_trees" list. If a leaf has to be crossed during this
> operation btrfs_next_leaf is called to do that. However, currently it's
> called with a wrong argument for its 'root' parameter. Since we are
> iterating the root tree the passed root should be fs_info->tree_rot,
> whereas right now we are passing the local variable 'root' which is
> assigned to the fs_tree. As it stands, this bug is actually benign since
> the passed root is only passed to reada_for_search, where it's used to
> reference the fs_info. Nevertheless the code is wrong and at the very least
> misleading, so fix it by passing the correct root.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
