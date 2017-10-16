Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41791 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752241AbdJPNe5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:34:57 -0400
Date: Mon, 16 Oct 2017 15:33:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add write_flags for compression bio
Message-ID: <20171016133310.GI3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171013211035.26765-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013211035.26765-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 03:10:35PM -0600, Liu Bo wrote:
> Compression code path has only flaged bios with REQ_OP_WRITE no matter
> where the bios come from.  This breaks the rule that sync writes and
> writeback writes need to be differentiated from each other.

What are the implications of the change?
