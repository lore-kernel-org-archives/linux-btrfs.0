Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdLLTRU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 14:17:20 -0500
Date: Tue, 12 Dec 2017 20:15:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: raid56: fix race between merge_bio and
 rbio_orig_end_io
Message-ID: <20171212191519.GW3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171208230235.30636-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20171208230235.30636-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 04:02:35PM -0700, Liu Bo wrote:
> We're not allowed to take any new bios to rbio->bio_list in
> rbio_orig_end_io(), otherwise we may get merged with more bios and
> rbio->bio_list is not empty.
> 
> This should only happens in error-out cases, the normal path of
> recover and full stripe write have already set RBIO_RMW_LOCKED_BIT to
> disable merge before doing IO.
> 
> Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Added to next, thanks.
