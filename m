Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbdK0Q5g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 11:57:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2DB6CABFC
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 16:57:35 +0000 (UTC)
Date: Mon, 27 Nov 2017 17:55:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, enadolski@suse.com
Subject: Re: [PATCH] btrfs: Remove redundant FLAG_VACANCY
Message-ID: <20171127165538.GE3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1511427103-3843-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511427103-3843-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 23, 2017 at 10:51:43AM +0200, Nikolay Borisov wrote:
> Commit 9036c10208e1 ("Btrfs: update hole handling v2") added the FLAG_VACANCY
> to denote holes, however there was already a consistent way of flagging
> extents which represent hole - ->block_start = EXTENT_MAP_HOLE. And also
> the only place where this flag is checked is in the fiemap code, but the
> block_start value is also checked and every other place in the filesystem
> detects holes by using block_start value's. So remove the extra flag. This
> survived a full xfstest run
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
