Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbeEVPZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 11:25:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C292ADAA
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:25:14 +0000 (UTC)
Date: Tue, 22 May 2018 17:22:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: Simplify alloc_reserved_tree_block interface
Message-ID: <20180522152232.GP6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
 <1526894843-8732-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526894843-8732-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 12:27:21PM +0300, Nikolay Borisov wrote:
> This function currently takes 7 parameters, most of which are
> proxies for values from btrfs_delayed_ref_node struct which is not
> passed. This patch simplifies the interface of the function by
> simply passing said delayed ref node struct to the function. This
> enables us to:
> 
> 1. Move locals variables and init code related to them from
> run_delayed_tree_ref which should only be used inside
> alloc_reserved_tree_block, such as skinny_metadata and the btrfs_key,
> representing the extent being inserted. This removes the need for the
> "ins" argument. Instead, it's replaced by a local var with a more
> verbose name - extent_key.
> 
> 2. Now that we have a reference to the node in alloc_reserved_tree_block
> the delayed_tree_ref struct can be referenced inside the function and
> this enable removing the "ref->level", "parent" and "ref_root"
> arguments.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
