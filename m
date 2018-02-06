Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbeBFQNb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Feb 2018 11:13:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C8470AE85
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Feb 2018 16:13:29 +0000 (UTC)
Date: Tue, 6 Feb 2018 17:11:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Handle btrfs_set_extent_delalloc failure in
 relocate_file_extent_cluster
Message-ID: <20180206161116.GD31890@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517322767-3044-1-git-send-email-nborisov@suse.com>
 <1517411642-6564-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517411642-6564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 05:14:02PM +0200, Nikolay Borisov wrote:
> Essentially duplicate the error handling from the above block which
> handles the !PageUptodate(page) case and additionally clear
> EXTENT_BOUNDARY.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Added to next, thanks.
