Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58103 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753618AbdEJRx2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 13:53:28 -0400
Date: Wed, 10 May 2017 19:53:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6 RFC] utilize bio_clone_fast to clean up
Message-ID: <20170510175319.GB27439@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <20170505142447.GC10575@twin.jikos.cz>
 <20170509224913.GG17312@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170509224913.GG17312@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 03:49:13PM -0700, Liu Bo wrote:
> > This patch is too big, can you split it to smaller chunks? I was not
> > able to review it, it seems to touch several things at once, it's hard
> > to keep the context.
> 
> Oh I see, the diff does look scary but the changes are in fact not
> intrusive, I'll try to do something.

On second read, I think it's not that bad as it looked. Some of the code
is just moved/indented differently and I see the core of the change now.

I'm concerned about the used types for length/size, but this can be done
as a followup patch. If you have split the patch already, please send
it anyway.
