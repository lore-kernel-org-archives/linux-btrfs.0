Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41493 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753949AbdKMRVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 12:21:05 -0500
Date: Mon, 13 Nov 2017 18:19:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: bail out gracefully rather than BUG_ON
Message-ID: <20171113171911.GC28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171030171440.27044-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171030171440.27044-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 30, 2017 at 11:14:38AM -0600, Liu Bo wrote:
> If a file's DIR_ITEM key is invalid (due to memory errors) and gets
> written to disk, a future lookup_path can end up with kernel panic due
> to BUG_ON().
> 
> This gets rid of the BUG_ON(), meanwhile output the corrupted key and
> return ENOENT if it's invalid.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> The diff doesn't show the logic well, 'goto out_err' will return with
> assigning 0 to location->objectid, and the caller already has a check
> for (location->objectid == 0) to return -ENOENT.

Feel free to send a cleanup patch.
