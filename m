Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55719 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeDSMvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:51:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3190FAEDF
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 12:51:51 +0000 (UTC)
Date: Thu, 19 Apr 2018 14:49:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: print-tree: output enhancement
Message-ID: <20180419124919.GB21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180411090813.19495-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180411090813.19495-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 05:08:12PM +0800, Qu Wenruo wrote:
> This patch enhance the following things:
> 
> - tree block header
>   * add generation and owner output for node and leaf
> - node pointer generation output
> - allow btrfs_print_tree() to not follow nodes
>   * just like btrfs-progs
> 
> Please note that, although function btrfs_print_tree() is not called by
> anyone right now, it's still a pretty useful function to debug kernel.
> So that function is still kept for later use.

It will stay of course, code deletionists have no chance removing useful
debugging stuff.

Reviewed-by: David Sterba <dsterba@suse.com>

Some time ago I improved the progs output of print-tree, this would be
also good to port to kernel and we can then keep the files in 1:1.
