Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbeFENpY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 09:45:24 -0400
Date: Tue, 5 Jun 2018 15:42:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
Message-ID: <20180605134237.GA3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
> Hi David,
> 
> It would be pretty nice if we could get this fix (or previous RFC patch)
> to get into current release cycle.
> 
> As it's a unrecoverable data corruption, it would be better to get it
> fixed as soon as possible.

That we can do, I'm planning to send 2nd pull by the end of the next
week as there's at least one patch in the queue now.

This patch seems to big, can you please prepare a minimal version?
Thanks.
