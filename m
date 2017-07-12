Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750899AbdGLOlu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 10:41:50 -0400
Date: Wed, 12 Jul 2017 16:40:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: report errors when checksum is not found
Message-ID: <20170712144036.GC2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170711204316.11283-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170711204316.11283-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 02:43:16PM -0600, Liu Bo wrote:
> When btrfs fails the checksum check, it'll fill the whole page with
> "1".

One could ask, why is the page filled with 1s. Brought by commit
07157aacb1ecd394a54949 from 2007, without mentioning any justification.
I'm more inclined to revisit this behaviour and drop it eventually.

> However, if %csum_expected is 0 (which means there is no checksum), then
> for some unknown reason, we just pretend that the read is correct, so
> userspace would be confused about the dilemma that read is successful but
> getting a page with all content being "1".

Here 'no checksum' means that no checksum was found but was expected,
right? An EIO would fail the read, I don't see a reason why the page
needs to be "zeroed". The contents would be inaccessible anyway.

> This can happen due to a bug in btrfs-convert.
> 
> This fixes it by always returning errors if checksum doesn't match.

Independent of the above, this fix makes sense.

Reviewed-by: David Sterba <dsterba@suse.com>
