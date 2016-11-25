Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753877AbcKYJkR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:40:17 -0500
Date: Fri, 25 Nov 2016 10:40:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: don't poke into bio internals V2
Message-ID: <20161125094012.GU12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480061273-5722-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 09:07:45AM +0100, Christoph Hellwig wrote:
> this series has a few patches that switch btrfs to use the proper helpers for
> accessing bio internals.  This helps to prepare for supporting multi-page
> bio_vecs, which are currently under development.
> 
> Changes since v1:
>  - fixed two compression related bugs
>  - various minor cleanups
>  - dropped the last patch of the old series for now - I think
>    the old code there is already buggy, but it seems like no one
>    can fully explain to me what it's actually supposed to do..

Added to 4.10 queue.
