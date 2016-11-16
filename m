Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752955AbcKPQTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 11:19:37 -0500
Date: Wed, 16 Nov 2016 17:19:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: don't poke into bio internals
Message-ID: <20161116161933.GW12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1479300736-9724-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:07PM +0100, Christoph Hellwig wrote:
> this series has a few patches that switch btrfs to use the proper helpers for
> accessing bio internals.  This helps to prepare for supporting multi-page
> bio_vecs, which are currently under development.

Looks good to me, thanks. I'll let it pass through tests, expected
merge target is 4.10.
