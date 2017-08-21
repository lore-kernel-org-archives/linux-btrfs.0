Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753257AbdHUOje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 10:39:34 -0400
Date: Mon, 21 Aug 2017 16:38:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 1/7] Btrfs: add a helper to retrive extent inline ref
 type
Message-ID: <20170821143809.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:18PM -0600, Liu Bo wrote:
> An invalid value of extent inline ref type may be read from a
> malicious image which may force btrfs to crash.
> 
> This adds a helper which does sanity check for the ref type, so we can
> know if it's sane, return type if so, otherwise return an error.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
