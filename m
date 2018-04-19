Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753333AbeDSO6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 10:58:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C0FFACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 14:58:24 +0000 (UTC)
Date: Thu, 19 Apr 2018 16:55:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs: Sink extent_tree arguments in
 try_release_extent_mapping
Message-ID: <20180419145553.GG21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 10:46:34AM +0300, Nikolay Borisov wrote:
> This function already gets the page from which the two extent trees
> are referenced. Simplify its signature by moving the code getting the
> trees inside the function. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

1-6 added to next, thanks.
