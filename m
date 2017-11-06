Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932426AbdKFPaP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:30:15 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ABD25ACD3
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 15:30:14 +0000 (UTC)
Date: Mon, 6 Nov 2017 16:28:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
Message-ID: <20171106152823.GJ28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031060816.683-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031060816.683-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 02:08:16PM +0800, Qu Wenruo wrote:
> btrfs_create_tree() will unconditionally generate UUID for any root.
> So for quota tree and data reloc tree created by kernel, they will have
> unique UUIDs.
> 
> However UUID in root item is only referred by UUID tree, which only
> records UUID for fs trees.
> This makes unique UUIDs for quota/data reloc tree meaningless.
> 
> Leave the UUID as zero for non-fs tree, making btrfs-debug-tree output
> less confusing.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Can you please point me to the report?

> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
