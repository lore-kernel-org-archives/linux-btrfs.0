Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752417AbeDPSSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 14:18:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E71BEAEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 18:18:13 +0000 (UTC)
Date: Mon, 16 Apr 2018 20:15:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: Fix lock release order
Message-ID: <20180416181543.GU21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
 <1523434880-7799-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1523434880-7799-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 11:21:18AM +0300, Nikolay Borisov wrote:
> Locks should generally be released in the oppposite order they are
> acquired. Generally lock acquisiton ordering is used to ensure
> deadlocks don't happen. However, as becomes more complicated it's
> best to also maintain proper unlock order so as to avoid possible dead
> locks. This was found by code inspection and doesn't necessarily lead
> to a deadlock scenario.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
