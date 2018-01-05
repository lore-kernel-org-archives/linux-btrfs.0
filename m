Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbeAEP4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 10:56:48 -0500
Date: Fri, 5 Jan 2018 16:54:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs: loop retry on raid6 read failures
Message-ID: <20180105155441.GP3553@twin.jikos.cz>
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

All (their most recent version) added to 4.16 queue.
