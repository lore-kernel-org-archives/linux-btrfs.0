Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57602 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752179AbdLES2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:28:49 -0500
Date: Tue, 5 Dec 2017 19:26:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs: loop retry on raid6 read failures
Message-ID: <20171205182650.GR3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171204224037.7556-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 03:40:34PM -0700, Liu Bo wrote:
> Patch 1 is a simple cleanup.
> Patch 2 fixes a bug in raid56 rbio merging code.
> Patch 3 fixes a bug in raid6 reconstruction process which can end up
> read failure when it can rebuild up good data.
> 
> Liu Bo (3):
>   Btrfs: remove redundant check in rbio_can_merge
>   Btrfs: do not merge rbios if their fail stripe index are not identical
>   Btrfs: make raid6 rebuild retry more

I'll add the patches to next so we can get some testing. The patch 3 can
stay as is, the cleanups for special mirror values would be good as a
separate patch.
