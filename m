Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60507 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751244AbdHVRLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 13:11:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2D7EAD32
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:11:16 +0000 (UTC)
Date: Tue, 22 Aug 2017 19:09:53 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: convert: add support for converting
 reiserfs
Message-ID: <20170822170953.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170725205443.29874-1-jeffm@suse.com>
 <20170725205443.29874-3-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170725205443.29874-3-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:54:43PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch adds support to convert reiserfs file systems in-place to btrfs.
> 
> It will convert extended attribute files to btrfs extended attributes,
> translate ACLs, coalesce tails that consist of multiple items into one item,
> and convert tails that are too big into indirect files.
> 
> This requires that libreiserfscore 3.6.27 be available.
> 
> Many of the test cases for convert apply regardless of what the source
> file system is and using ext4 is sufficient.  I've included several
> test cases that are reiserfs-specific.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Patches merged, with quite a few small fixups here and there. It took me
less time to fix them on the way than to take it through the
mailinglist. The tests were split to separate patch. I'm fine with
keeping the reiserfs bits in one patch as it's an isolated feature.
The tests are now running, I'll let it finish. There's some code or
test code duplication that can be cleaned up eventually, but now I
consider reiserfs conversion support done. Thanks.
