Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43513 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750724AbdEBPin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:38:43 -0400
Date: Tue, 2 May 2017 17:38:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Make flush bios explicitely sync
Message-ID: <20170502153835.GN23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170502150351.29452-1-jack@suse.cz>
 <20170502150351.29452-7-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502150351.29452-7-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:03:50PM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> definitions.  generic_make_request_checks() however strips REQ_FUA and
> REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> write cache and thus write effectively becomes asynchronous which can
> lead to performance regressions
> 
> Fix the problem by making sure all bios which are synchronous are
> properly marked with REQ_SYNC.
> 
> CC: David Sterba <dsterba@suse.com>
> CC: linux-btrfs@vger.kernel.org
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: David Sterba <dsterba@suse.com>
