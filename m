Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47703 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbdJPOwz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:52:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68790AAF1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 14:52:54 +0000 (UTC)
Date: Mon, 16 Oct 2017 16:51:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Replace opencoded sizes with their symbolic
 constants
Message-ID: <20171016145105.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171016134125.GK3521@twin.jikos.cz>
 <1508161720-638-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508161720-638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:48:40PM +0300, Nikolay Borisov wrote:
> Currently btrfs' code uses a mix of opencoded sizes and defines from sizes.h.
> Let's unifiy the code base to always use the symbolic constants. No functional
> changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
