Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50832 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754307AbdJPRe4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 13:34:56 -0400
Date: Mon, 16 Oct 2017 10:34:49 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add write_flags for compression bio
Message-ID: <20171016173449.GD19440@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171013211035.26765-1-bo.li.liu@oracle.com>
 <20171016133310.GI3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016133310.GI3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 03:33:10PM +0200, David Sterba wrote:
> On Fri, Oct 13, 2017 at 03:10:35PM -0600, Liu Bo wrote:
> > Compression code path has only flaged bios with REQ_OP_WRITE no matter
> > where the bios come from.  This breaks the rule that sync writes and
> > writeback writes need to be differentiated from each other.
> 
> What are the implications of the change?

All writes need to have the correct bio flag so that block layer can
recognize them to do throttle or other stuff.  Compression writes are
no exception, but currently we don't attach the correct bio flag to
either compressed writeback writes or compressed sync writes.

Does it make sense?

Thanks,

-liubo
