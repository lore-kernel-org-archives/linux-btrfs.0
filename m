Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbcJFHlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 03:41:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 23FA9AAD1
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 07:41:36 +0000 (UTC)
Date: Thu, 6 Oct 2016 09:41:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: opencode chunk locking, remove helpers
Message-ID: <20161006074134.GG6576@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161005122306.3530-1-dsterba@suse.com>
 <50a2d25f-844b-651c-4d55-2a5ea66d178e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50a2d25f-844b-651c-4d55-2a5ea66d178e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 05, 2016 at 02:41:24PM -0400, Jeff Mahoney wrote:
> On 10/5/16 8:23 AM, David Sterba wrote:
> > The helpers are trivial and we don't use them consistently.
> 
> This one is going to conflict with the root->fs_info removal patchset in
> every chunk since the helper does nothing with the root.  Otherwise, the
> idea is sound.

No problem, I'll refresh and resend after the fsinfo/root series.
