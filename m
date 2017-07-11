Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52643 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756038AbdGKRNq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 13:13:46 -0400
Date: Tue, 11 Jul 2017 19:12:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.com, clm@fb.com
Subject: Re: [PATCH] btrfs: Remove redundant argument of flush_space
Message-ID: <20170711171231.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499768713-23471-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499768713-23471-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 01:25:13PM +0300, Nikolay Borisov wrote:
> All callers of flush_space pass the same number for orig/num_bytes
> arguments. Let's remove one of the numbers and also modify the trace point 
> to show only a single number - bytes requested. 

Seems that last point where the two parameters could make a difference
is before the ticketed enospc rework, so it's ok.

Reviewed-by: David Sterba <dsterba@suse.com>
