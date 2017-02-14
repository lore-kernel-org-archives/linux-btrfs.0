Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21444 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbdBNSpe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 13:45:34 -0500
Date: Tue, 14 Feb 2017 10:44:40 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/29] btrfs: remove unused parameter from
 btrfs_check_super_valid
Message-ID: <20170214184440.GA31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <30b7866b2b154b6bbdf3959dfd4ecc754e78c208.1486977712.git.dsterba@suse.com>
 <20170214021156.GC24037@localhost.localdomain>
 <20170214114207.GK16928@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170214114207.GK16928@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 12:42:07PM +0100, David Sterba wrote:
> On Mon, Feb 13, 2017 at 06:11:56PM -0800, Liu Bo wrote:
> > On Mon, Feb 13, 2017 at 10:33:55AM +0100, David Sterba wrote:
> > > None of the checks need to know the RO/RW status.
> > >
> > 
> > OK...there was a readonly check, which lets us skip all checks,
> > it was removed by the below commit, should we add the check back?
> 
> All the current checks do not modify the superblock, so it's read-only
> and we can keep it as-is. The superblock is available from inside the
> function anyway so we don't need to check sb_flags externally. I'll
> update the changelog.
Yes, this makes sense.

Thanks,

-liubo
