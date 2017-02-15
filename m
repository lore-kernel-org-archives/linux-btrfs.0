Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59985 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751836AbdBOPSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:18:21 -0500
Date: Wed, 15 Feb 2017 16:17:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/29] btrfs: remove unused parameter from
 submit_extent_page
Message-ID: <20170215151749.GQ16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1486977711.git.dsterba@suse.com>
 <ac49126de7d3f5dbdea72584f46befd549d084f4.1486977712.git.dsterba@suse.com>
 <20170214191031.GC31091@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170214191031.GC31091@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 11:10:32AM -0800, Liu Bo wrote:
> @pnr is only used here, it can be removed, too.
> 
> So does @max_nr.

Right, thanks. Patch udpated. I've tried if this can be caught by
'-Wunused-but-set-variable', strangely only max_nr is reported:

fs/btrfs/extent_io.c: In function ‘__extent_writepage_io’:
fs/btrfs/extent_io.c:3368:17: warning: variable ‘max_nr’ set but not used [-Wunused-but-set-variable]
   unsigned long max_nr;
