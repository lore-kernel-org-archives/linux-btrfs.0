Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45019 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752952AbeDPSRA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 14:17:00 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ECE3CAEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 18:16:58 +0000 (UTC)
Date: Mon, 16 Apr 2018 20:14:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: Use while loop instead of labels in
 __endio_write_update_ordered
Message-ID: <20180416181428.GT21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
 <1523434880-7799-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1523434880-7799-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 11:21:17AM +0300, Nikolay Borisov wrote:
> Currently __endio_write_update_ordered uses labels to implement
> what is essentially a simple while loop. This makes the code more
> cumbersome to follow than it actually has to be. No functional
> changes. No xfstest regressions were found during testing.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
