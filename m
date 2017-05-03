Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752844AbdECOvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 10:51:42 -0400
Date: Wed, 3 May 2017 16:51:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Fix heap use after free.
Message-ID: <20170503145134.GW23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170503015014.2221-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170503015014.2221-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 03, 2017 at 09:50:14AM +0800, Su Yue wrote:
> While iterating over backrefs in repair_inode_backrefs, there are several
> situations to repair one backref according backref->found_dir_item and
> backref->found_dir_index.
> Two of these branches may free the backref, but next judgments will still
> access the freed memory.
> 
> Because these branches are independent, let repair_inode_backrefs skip to
> handle next backref after free can fix it.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
