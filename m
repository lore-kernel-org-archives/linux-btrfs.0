Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751766AbdJFQM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 12:12:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2E57AC87
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Oct 2017 16:12:55 +0000 (UTC)
Date: Fri, 6 Oct 2017 18:11:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH v2 1/2] btrfs: Refactor transaction handling
Message-ID: <20171006161113.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506588327-6616-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 11:45:26AM +0300, Nikolay Borisov wrote:
> If btrfs_transaction_commit fails it will proceed to call cleanup_transaction,
> which in turn already does btrfs_abort_transaction. So let's remove the
> unnecessary code duplication. Also let's be explicit about handling failure
> of btrfs_uuid_tree_add by calling btrfs_end_transaction.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
